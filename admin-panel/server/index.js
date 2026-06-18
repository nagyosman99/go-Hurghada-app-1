const express = require('express');
const cors = require('cors');
const admin = require('firebase-admin');
require('dotenv').config();

// New availability system routes
const availabilityRouter = require('./routes/availability');
const bookingsRouter     = require('./routes/bookings');
const aiRouter           = require('./routes/ai');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Firebase Admin Setup
let db;

// Firebase Admin Setup
try {
  const serviceAccount = require('./serviceAccountKey.json');
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: `https://${process.env.FIREBASE_PROJECT_ID}.firebaseio.com`
  });
  db = admin.firestore();
  console.log('Firebase Admin initialized successfully');
} catch (error) {
  console.error('CRITICAL: Firebase Admin initialization failed:', error.message);
  console.log('Functionality will be limited until serviceAccountKey.json is provided.');
}

// Middleware to check if DB is initialized
const checkDb = (req, res, next) => {
  if (!db) {
    return res.status(503).json({ error: 'Database not initialized. Please provide serviceAccountKey.json' });
  }
  next();
};

// Inject db into every request so route modules can use it
app.use((req, res, next) => {
  req.db = db;
  next();
});

// ─── New Availability System Routes ───────────────────────────────────────
// These sit BEFORE the legacy booking routes so there is no path collision.
app.use('/api/availability', checkDb, availabilityRouter);
app.use('/api/hotel-bookings', checkDb, bookingsRouter);
app.use('/api/ai', checkDb, verifyAdmin, aiRouter);

// Auth Middleware (Admin Check)
async function verifyAdmin(req, res, next) {
  const token = req.headers.authorization?.split('Bearer ')[1];
  if (!token) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  try {
    const decodedToken = await admin.auth().verifyIdToken(token);
    const userDoc = await db.collection('users').doc(decodedToken.uid).get();
    const userData = userDoc.data();

    if (userData && userData.role === 'admin') {
      req.user = decodedToken;
      next();
    } else {
      res.status(403).json({ error: 'Forbidden: Admin access only' });
    }
  } catch (error) {
    res.status(401).json({ error: 'Invalid token' });
  }
}

// --- Routes ---

// Hotels
app.get('/api/hotels', async (req, res) => {
  try {
    const snapshot = await db.collection('hotels').get();
    const hotels = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.json(hotels);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/hotels', verifyAdmin, async (req, res) => {
  try {
    const hotelData = req.body;
    const docRef = await db.collection('hotels').add(hotelData);
    res.status(201).json({ id: docRef.id, ...hotelData });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.put('/api/hotels/:id', verifyAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const hotelData = req.body;
    await db.collection('hotels').doc(id).update(hotelData);
    res.json({ id, ...hotelData });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Hotel Rooms (sub-collection)
app.get('/api/hotels/:id/rooms', async (req, res) => {
  try {
    const snap = await db.collection('hotels').doc(req.params.id).collection('rooms').get();
    res.json(snap.docs.map(d => ({ id: d.id, ...d.data() })));
  } catch (error) { res.status(500).json({ error: error.message }); }
});

app.post('/api/hotels/:id/rooms', verifyAdmin, async (req, res) => {
  try {
    const ref = await db.collection('hotels').doc(req.params.id).collection('rooms').add(req.body);
    res.status(201).json({ id: ref.id, ...req.body });
  } catch (error) { res.status(500).json({ error: error.message }); }
});

app.put('/api/hotels/:id/rooms/:roomId', verifyAdmin, async (req, res) => {
  try {
    await db.collection('hotels').doc(req.params.id).collection('rooms').doc(req.params.roomId).update(req.body);
    res.json({ id: req.params.roomId, ...req.body });
  } catch (error) { res.status(500).json({ error: error.message }); }
});

app.delete('/api/hotels/:id/rooms/:roomId', verifyAdmin, async (req, res) => {
  try {
    await db.collection('hotels').doc(req.params.id).collection('rooms').doc(req.params.roomId).delete();
    res.status(204).send();
  } catch (error) { res.status(500).json({ error: error.message }); }
});

app.delete('/api/hotels/:id', verifyAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    await db.collection('hotels').doc(id).delete();
    res.status(204).send();
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Activities
app.get('/api/activities', async (req, res) => {
  try {
    const snapshot = await db.collection('activities').get();
    const activities = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.json(activities);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/activities', verifyAdmin, async (req, res) => {
  try {
    const data = req.body;
    const docRef = await db.collection('activities').add(data);
    res.status(201).json({ id: docRef.id, ...data });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.put('/api/activities/:id', verifyAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const data = req.body;
    await db.collection('activities').doc(id).update(data);
    res.json({ id, ...data });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.delete('/api/activities/:id', verifyAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    await db.collection('activities').doc(id).delete();
    res.status(204).send();
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Flights
app.get('/api/flights', async (req, res) => {
  try {
    const snapshot = await db.collection('flights').get();
    const flights = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.json(flights);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Bookings — fetch from ALL user subcollections via collectionGroup
app.get('/api/bookings', verifyAdmin, async (req, res) => {
  try {
    const snapshot = await db.collectionGroup('bookings').get();
    const bookings = snapshot.docs.map(doc => {
      const data = doc.data();
      // Convert Firestore Timestamps to ISO strings
      const convert = (v) => v?.seconds ? new Date(v.seconds * 1000).toISOString() : v;
      return {
        docPath: doc.ref.path,
        id: doc.id,
        ...data,
        createdAt: convert(data.createdAt),
        checkInDate: convert(data.checkInDate),
        checkOutDate: convert(data.checkOutDate),
        selectedDate: convert(data.selectedDate),
      };
    });
    // Sort newest first
    bookings.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
    res.json(bookings);
  } catch (error) {
    console.error('Bookings fetch error:', error);
    res.status(500).json({ error: error.message });
  }
});

// Update booking status
app.patch('/api/bookings/:userId/:bookingId', verifyAdmin, async (req, res) => {
  try {
    const { userId, bookingId } = req.params;
    const { status } = req.body;

    // Check if the booking exists in the root-level bookings collection (new hotel bookings)
    const rootBookingRef = db.collection('bookings').doc(bookingId);
    const rootSnap = await rootBookingRef.get();

    if (rootSnap.exists) {
      await rootBookingRef.update({ status });
      return res.json({ success: true, status });
    }

    // Fallback: update in user's bookings subcollection (activities/legacy bookings)
    await db.collection('users').doc(userId).collection('bookings').doc(bookingId).update({ status });
    res.json({ success: true, status });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
