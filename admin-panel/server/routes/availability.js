const express = require('express');
const router = express.Router();
const { generateDateRange } = require('../utils/dateRange');

/**
 * GET /api/availability
 * Query params: hotelId, roomId, startDate, endDate
 *
 * Returns availability for each date in the range.
 * If no availability doc exists for a date → fully available.
 */
router.get('/', async (req, res) => {
  const { hotelId, roomId, startDate, endDate } = req.query;
  const db = req.db;

  if (!hotelId || !roomId || !startDate || !endDate) {
    return res.status(400).json({
      error: 'Missing required query params: hotelId, roomId, startDate, endDate',
    });
  }

  let dates;
  try {
    // We want to check availability for each date including checkOut night
    // For availability display we show all nights in the range
    dates = generateDateRange(startDate, endDate);
  } catch (err) {
    return res.status(400).json({ error: err.message });
  }

  try {
    // Fetch the room doc to get totalCount
    const roomRef = db
      .collection('hotels')
      .doc(hotelId)
      .collection('rooms')
      .doc(roomId);
    const roomSnap = await roomRef.get();

    if (!roomSnap.exists) {
      return res.status(404).json({ error: 'Room not found.' });
    }

    const totalCount = roomSnap.data().totalCount;
    if (!totalCount || typeof totalCount !== 'number' || totalCount < 1) {
      return res.status(400).json({
        error: 'Room is missing a valid totalCount field.',
      });
    }

    // Read all availability docs in parallel
    const availRef = db.collection('availability');
    const docReads = dates.map((date) => {
      const docId = `${hotelId}_${roomId}_${date}`;
      return availRef.doc(docId).get();
    });

    const snaps = await Promise.all(docReads);

    const result = snaps.map((snap, i) => {
      const date = dates[i];
      if (!snap.exists) {
        return {
          date,
          available: true,
          bookedCount: 0,
          totalCount,
          remainingRooms: totalCount,
        };
      }
      const data = snap.data();
      const bookedCount = data.bookedCount || 0;
      const remaining = totalCount - bookedCount;
      return {
        date,
        available: remaining > 0,
        bookedCount,
        totalCount,
        remainingRooms: Math.max(0, remaining),
      };
    });

    res.json(result);
  } catch (err) {
    console.error('Availability check error:', err);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
