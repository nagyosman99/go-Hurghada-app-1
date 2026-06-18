const express = require('express');
const router = express.Router();
const admin = require('firebase-admin');
const { generateDateRange } = require('../utils/dateRange');

// ─── POST /api/bookings ──────────────────────────────────────────────────────
/**
 * Creates a new hotel room booking using a Firestore transaction.
 *
 * Body: { hotelId, roomId, checkIn, checkOut, userId,
 *         guestName, guestEmail, hotelName, roomName, totalPrice }
 *
 * Steps:
 *  1. Validate inputs
 *  2. Fetch room (for totalCount)
 *  3. Transaction: check all dates → if any full → abort (409)
 *  4. Transaction: increment bookedCount for all dates + create booking doc
 *  5. Return 201 with bookingId, or 409 / 500
 */
router.post('/', async (req, res) => {
  const db = req.db;
  const {
    hotelId, roomId, checkIn, checkOut, userId,
    guestName, guestEmail, hotelName, roomName, totalPrice,
  } = req.body;

  // --- Input validation ---
  if (!hotelId || !roomId || !checkIn || !checkOut || !userId) {
    return res.status(400).json({
      error: 'Missing required fields: hotelId, roomId, checkIn, checkOut, userId',
    });
  }

  let dates;
  try {
    dates = generateDateRange(checkIn, checkOut);
  } catch (err) {
    return res.status(400).json({ error: err.message });
  }

  if (dates.length === 0) {
    return res.status(400).json({ error: 'Date range produced no nights.' });
  }

  // --- Fetch room to get totalCount (outside transaction — OK for a snapshot read) ---
  let totalCount;
  try {
    const roomSnap = await db
      .collection('hotels').doc(hotelId)
      .collection('rooms').doc(roomId)
      .get();

    if (!roomSnap.exists) {
      return res.status(404).json({ error: 'Room not found.' });
    }
    totalCount = roomSnap.data().totalCount;
    if (!totalCount || typeof totalCount !== 'number' || totalCount < 1) {
      return res.status(400).json({ error: 'Room is missing a valid totalCount.' });
    }
  } catch (err) {
    return res.status(500).json({ error: 'Failed to fetch room data: ' + err.message });
  }

  // --- Build availability doc refs for the transaction ---
  const availRef = db.collection('availability');
  const availDocRefs = dates.map((date) =>
    availRef.doc(`${hotelId}_${roomId}_${date}`)
  );

  // --- Firestore Transaction ---
  // The SDK automatically retries on contention (up to 5 times by default)
  try {
    const bookingRef = db.collection('bookings').doc(); // pre-generate ID

    await db.runTransaction(async (t) => {
      // 1. Read all availability docs inside the transaction
      const snaps = await Promise.all(availDocRefs.map((ref) => t.get(ref)));

      // 2. Check every date for availability
      for (let i = 0; i < dates.length; i++) {
        const snap = snaps[i];
        const bookedCount = snap.exists ? (snap.data().bookedCount || 0) : 0;

        if (bookedCount >= totalCount) {
          // Throw a tagged error so we can distinguish it from system errors
          const err = new Error(
            `Room is fully booked on ${dates[i]}. (${bookedCount}/${totalCount} units taken)`
          );
          err.code = 'NOT_AVAILABLE';
          err.date = dates[i];
          throw err;
        }
      }

      // 3. All dates are available → write availability updates
      for (let i = 0; i < dates.length; i++) {
        const snap = snaps[i];
        const ref  = availDocRefs[i];

        if (!snap.exists) {
          // Create new availability doc
          t.set(ref, {
            hotelId,
            roomId,
            date: dates[i],
            bookedCount: 1,
            totalCount,          // snapshot for reference
          });
        } else {
          t.update(ref, {
            bookedCount: admin.firestore.FieldValue.increment(1),
          });
        }
      }

      // 4. Create the booking document
      t.set(bookingRef, {
        userId,
        hotelId,
        roomId,
        hotelName: hotelName || '',
        roomName:  roomName  || '',
        guestName: guestName || '',
        guestEmail: guestEmail || '',
        checkIn,
        checkOut,
        nights: dates.length,
        totalPrice: totalPrice || 0,
        status: 'confirmed',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        type: 'hotel',
      });
    });

    return res.status(201).json({
      success: true,
      bookingId: bookingRef.id,
      nights: dates.length,
      message: 'Booking confirmed successfully.',
    });

  } catch (err) {
    if (err.code === 'NOT_AVAILABLE') {
      return res.status(409).json({
        error: 'Room not available',
        message: err.message,
        date: err.date,
      });
    }
    console.error('Booking transaction error:', err);
    return res.status(500).json({ error: 'Booking failed: ' + err.message });
  }
});


// ─── PATCH /api/bookings/:bookingId/cancel ───────────────────────────────────
/**
 * Cancels a booking and restores availability using a Firestore transaction.
 *
 * Steps:
 *  1. Get booking doc
 *  2. Validate not already cancelled
 *  3. Transaction: decrement bookedCount for each date
 *     → delete availability doc if bookedCount reaches 0
 *  4. Update booking status → 'cancelled'
 */
router.patch('/:bookingId/cancel', async (req, res) => {
  const db = req.db;
  const { bookingId } = req.params;

  // --- Fetch the booking ---
  let bookingData;
  const bookingRef = db.collection('bookings').doc(bookingId);

  try {
    const snap = await bookingRef.get();
    if (!snap.exists) {
      return res.status(404).json({ error: 'Booking not found.' });
    }
    bookingData = snap.data();
  } catch (err) {
    return res.status(500).json({ error: 'Failed to fetch booking: ' + err.message });
  }

  if (bookingData.status === 'cancelled') {
    return res.status(400).json({ error: 'Booking is already cancelled.' });
  }

  // --- Reconstruct date range ---
  let dates;
  try {
    dates = generateDateRange(bookingData.checkIn, bookingData.checkOut);
  } catch (err) {
    return res.status(500).json({ error: 'Could not reconstruct date range: ' + err.message });
  }

  const { hotelId, roomId } = bookingData;
  const availRef = db.collection('availability');
  const availDocRefs = dates.map((date) =>
    availRef.doc(`${hotelId}_${roomId}_${date}`)
  );

  // --- Firestore Transaction ---
  try {
    await db.runTransaction(async (t) => {
      const snaps = await Promise.all(availDocRefs.map((ref) => t.get(ref)));

      for (let i = 0; i < dates.length; i++) {
        const snap = snaps[i];
        const ref  = availDocRefs[i];

        if (!snap.exists) {
          // Doc was already deleted or never existed — skip
          continue;
        }

        const bookedCount = snap.data().bookedCount || 0;
        const newCount = bookedCount - 1;

        if (newCount <= 0) {
          // No bookings left for this date — delete the doc to keep Firestore clean
          t.delete(ref);
        } else {
          t.update(ref, {
            bookedCount: admin.firestore.FieldValue.increment(-1),
          });
        }
      }

      // Update booking status
      t.update(bookingRef, {
        status: 'cancelled',
        cancelledAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    });

    return res.json({ success: true, message: 'Booking cancelled successfully.' });

  } catch (err) {
    console.error('Cancellation transaction error:', err);
    return res.status(500).json({ error: 'Cancellation failed: ' + err.message });
  }
});


// ─── GET /api/bookings (new top-level collection) ───────────────────────────
/**
 * Fetches all bookings from the top-level `bookings` collection.
 * (The existing endpoint in index.js fetches from user subcollections via collectionGroup)
 */
router.get('/all', async (req, res) => {
  const db = req.db;
  try {
    const snap = await db.collection('bookings')
      .orderBy('createdAt', 'desc')
      .get();

    const bookings = snap.docs.map((doc) => {
      const data = doc.data();
      const convert = (v) => (v?.seconds ? new Date(v.seconds * 1000).toISOString() : v);
      return {
        id: doc.id,
        ...data,
        createdAt:   convert(data.createdAt),
        cancelledAt: convert(data.cancelledAt),
      };
    });

    res.json(bookings);
  } catch (err) {
    console.error('Fetch top-level bookings error:', err);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
