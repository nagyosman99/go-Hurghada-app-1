const express = require('express');
const router = express.Router();
const { GoogleGenAI, Type } = require('@google/genai');
const admin = require('firebase-admin');

// ─── Tool Definitions ──────────────────────────────────────────────────────────
const tools = [{
  functionDeclarations: [
    {
      name: 'search_hotels',
      description: 'Search and list hotels. Can filter by name or location. Returns hotel details including rooms.',
      parameters: {
        type: Type.OBJECT,
        properties: {
          name_filter:     { type: Type.STRING, description: 'Optional partial hotel name to filter by' },
          location_filter: { type: Type.STRING, description: 'Optional location to filter by' },
        },
      },
    },
    {
      name: 'get_hotel_rooms',
      description: 'Get all rooms for a specific hotel by hotel ID.',
      parameters: {
        type: Type.OBJECT,
        properties: {
          hotel_id: { type: Type.STRING, description: 'The Firestore document ID of the hotel' },
        },
        required: ['hotel_id'],
      },
    },
    {
      name: 'check_availability',
      description: 'Check room availability for specific dates. Returns remaining rooms per day.',
      parameters: {
        type: Type.OBJECT,
        properties: {
          hotel_id:  { type: Type.STRING, description: 'Hotel ID' },
          room_id:   { type: Type.STRING, description: 'Room ID' },
          check_in:  { type: Type.STRING, description: 'Check-in date YYYY-MM-DD' },
          check_out: { type: Type.STRING, description: 'Check-out date YYYY-MM-DD' },
        },
        required: ['hotel_id', 'room_id', 'check_in', 'check_out'],
      },
    },
    {
      name: 'get_activities',
      description: 'Get all available tours and activities.',
      parameters: { type: Type.OBJECT, properties: {} },
    },
    {
      name: 'get_bookings',
      description: 'Fetch bookings with optional filters by status, hotel name, or guest.',
      parameters: {
        type: Type.OBJECT,
        properties: {
          status_filter: { type: Type.STRING, description: 'Filter: confirmed, pending, cancelled, rejected' },
          hotel_filter:  { type: Type.STRING, description: 'Filter by hotel name (partial)' },
          guest_filter:  { type: Type.STRING, description: 'Filter by guest name or email (partial)' },
          limit:         { type: Type.NUMBER, description: 'Max results to return (default 20)' },
        },
      },
    },
    {
      name: 'update_booking_status',
      description: 'Update booking status to confirmed, cancelled, pending, or rejected.',
      parameters: {
        type: Type.OBJECT,
        properties: {
          booking_id: { type: Type.STRING, description: 'Firestore booking document ID' },
          new_status: { type: Type.STRING, description: 'New status: confirmed, cancelled, pending, rejected' },
        },
        required: ['booking_id', 'new_status'],
      },
    },
    {
      name: 'create_booking',
      description: 'Create a new hotel room booking with availability check. Use when admin wants to manually book for a guest.',
      parameters: {
        type: Type.OBJECT,
        properties: {
          hotel_id:    { type: Type.STRING, description: 'Hotel ID' },
          room_id:     { type: Type.STRING, description: 'Room ID' },
          hotel_name:  { type: Type.STRING, description: 'Hotel name' },
          room_name:   { type: Type.STRING, description: 'Room name or type' },
          guest_name:  { type: Type.STRING, description: 'Guest full name' },
          guest_email: { type: Type.STRING, description: 'Guest email' },
          check_in:    { type: Type.STRING, description: 'Check-in date YYYY-MM-DD' },
          check_out:   { type: Type.STRING, description: 'Check-out date YYYY-MM-DD' },
          total_price: { type: Type.NUMBER, description: 'Total price' },
          user_id:     { type: Type.STRING, description: 'Firebase user ID (use "admin_created" if unknown)' },
        },
        required: ['hotel_id', 'room_id', 'hotel_name', 'room_name', 'guest_name', 'guest_email', 'check_in', 'check_out', 'total_price'],
      },
    },
    {
      name: 'update_hotel',
      description: 'Update an existing hotel\'s details.',
      parameters: {
        type: Type.OBJECT,
        properties: {
          hotel_id: { type: Type.STRING, description: 'Hotel Firestore ID' },
          updates:  { type: Type.OBJECT, description: 'Key-value pairs of fields to update' },
        },
        required: ['hotel_id', 'updates'],
      },
    },
  ],
}];

// ─── Tool Executor ─────────────────────────────────────────────────────────────
async function executeTool(name, args, db) {
  const convertTs = (v) => v?.seconds ? new Date(v.seconds * 1000).toISOString() : v;

  switch (name) {
    case 'search_hotels': {
      const snap = await db.collection('hotels').get();
      let hotels = await Promise.all(snap.docs.map(async (doc) => {
        const data = doc.data();
        const roomsSnap = await doc.ref.collection('rooms').get();
        return {
          id: doc.id,
          name: data.name,
          location: data.location,
          description: data.description,
          rating: data.rating,
          pricePerNight: data.pricePerNight,
          rooms: roomsSnap.docs.map(r => ({ id: r.id, ...r.data() })),
        };
      }));
      if (args.name_filter) {
        const f = args.name_filter.toLowerCase();
        hotels = hotels.filter(h => h.name?.toLowerCase().includes(f));
      }
      if (args.location_filter) {
        const f = args.location_filter.toLowerCase();
        hotels = hotels.filter(h => h.location?.toLowerCase().includes(f));
      }
      return { hotels, total: hotels.length };
    }

    case 'get_hotel_rooms': {
      const roomsSnap = await db.collection('hotels').doc(args.hotel_id).collection('rooms').get();
      const rooms = roomsSnap.docs.map(r => ({ id: r.id, ...r.data() }));
      return { hotel_id: args.hotel_id, rooms, total: rooms.length };
    }

    case 'check_availability': {
      const dates = [];
      const cur = new Date(args.check_in);
      const end = new Date(args.check_out);
      while (cur < end) { dates.push(cur.toISOString().split('T')[0]); cur.setDate(cur.getDate() + 1); }

      const roomSnap = await db.collection('hotels').doc(args.hotel_id).collection('rooms').doc(args.room_id).get();
      if (!roomSnap.exists) return { error: 'Room not found' };
      const totalCount = roomSnap.data().totalCount || 1;

      const snaps = await Promise.all(dates.map(d =>
        db.collection('availability').doc(`${args.hotel_id}_${args.room_id}_${d}`).get()
      ));
      const result = snaps.map((snap, i) => {
        const booked = snap.exists ? (snap.data().bookedCount || 0) : 0;
        return { date: dates[i], available: booked < totalCount, remaining: Math.max(0, totalCount - booked), bookedCount: booked, totalCount };
      });
      return { check_in: args.check_in, check_out: args.check_out, availability: result, fully_available: result.every(r => r.available) };
    }

    case 'get_activities': {
      const snap = await db.collection('activities').get();
      return { activities: snap.docs.map(d => ({ id: d.id, ...d.data() })), total: snap.size };
    }

    case 'get_bookings': {
      const limit = args.limit || 20;
      const snap = await db.collection('bookings').orderBy('createdAt', 'desc').get();
      let bookings = snap.docs.map(doc => {
        const data = doc.data();
        return {
          id: doc.id,
          guestName: data.guestName || data.userName || 'N/A',
          guestEmail: data.guestEmail || data.userEmail || 'N/A',
          hotelName: data.hotelName || 'N/A',
          roomName: data.roomName || data.roomType || 'N/A',
          checkIn: convertTs(data.checkIn) || convertTs(data.checkInDate),
          checkOut: convertTs(data.checkOut) || convertTs(data.checkOutDate),
          nights: data.nights || 0,
          totalPrice: data.totalPrice || 0,
          status: data.status || 'pending',
          type: data.type || 'hotel',
          createdAt: convertTs(data.createdAt),
        };
      });
      if (args.status_filter) bookings = bookings.filter(b => b.status === args.status_filter);
      if (args.hotel_filter) { const f = args.hotel_filter.toLowerCase(); bookings = bookings.filter(b => b.hotelName?.toLowerCase().includes(f)); }
      if (args.guest_filter) { const f = args.guest_filter.toLowerCase(); bookings = bookings.filter(b => b.guestName?.toLowerCase().includes(f) || b.guestEmail?.toLowerCase().includes(f)); }
      return { bookings: bookings.slice(0, limit), total: bookings.length, showing: Math.min(bookings.length, limit) };
    }

    case 'update_booking_status': {
      const { booking_id, new_status } = args;
      const validStatuses = ['confirmed', 'cancelled', 'pending', 'rejected'];
      if (!validStatuses.includes(new_status)) return { error: `Invalid status "${new_status}". Use: ${validStatuses.join(', ')}` };
      const bookingRef = db.collection('bookings').doc(booking_id);
      const snap = await bookingRef.get();
      if (!snap.exists) return { error: `Booking "${booking_id}" not found.` };
      const updateData = { status: new_status, updatedAt: admin.firestore.FieldValue.serverTimestamp() };
      if (new_status === 'cancelled') updateData.cancelledAt = admin.firestore.FieldValue.serverTimestamp();
      await bookingRef.update(updateData);
      return { success: true, booking_id, new_status, message: `Booking updated to "${new_status}" successfully.` };
    }

    case 'create_booking': {
      const { hotel_id, room_id, hotel_name, room_name, guest_name, guest_email, check_in, check_out, total_price, user_id } = args;
      const dates = [];
      const cur = new Date(check_in); const end = new Date(check_out);
      while (cur < end) { dates.push(cur.toISOString().split('T')[0]); cur.setDate(cur.getDate() + 1); }
      if (dates.length === 0) return { error: 'Invalid dates — no nights produced.' };

      const roomSnap = await db.collection('hotels').doc(hotel_id).collection('rooms').doc(room_id).get();
      if (!roomSnap.exists) return { error: 'Room not found.' };
      const totalCount = roomSnap.data().totalCount || 1;

      const availRef = db.collection('availability');
      const availDocRefs = dates.map(d => availRef.doc(`${hotel_id}_${room_id}_${d}`));
      const bookingRef = db.collection('bookings').doc();

      try {
        await db.runTransaction(async (t) => {
          const snaps = await Promise.all(availDocRefs.map(ref => t.get(ref)));
          for (let i = 0; i < dates.length; i++) {
            const booked = snaps[i].exists ? (snaps[i].data().bookedCount || 0) : 0;
            if (booked >= totalCount) { const e = new Error(`Fully booked on ${dates[i]}`); e.code = 'NOT_AVAILABLE'; throw e; }
          }
          for (let i = 0; i < dates.length; i++) {
            if (!snaps[i].exists) t.set(availDocRefs[i], { hotelId: hotel_id, roomId: room_id, date: dates[i], bookedCount: 1, totalCount });
            else t.update(availDocRefs[i], { bookedCount: admin.firestore.FieldValue.increment(1) });
          }
          t.set(bookingRef, {
            userId: user_id || 'admin_created', hotelId: hotel_id, roomId: room_id,
            hotelName: hotel_name, roomName: room_name, guestName: guest_name, guestEmail: guest_email,
            checkIn: check_in, checkOut: check_out, nights: dates.length, totalPrice: total_price,
            status: 'confirmed', type: 'hotel', createdBy: 'admin_ai',
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
          });
        });
        return { success: true, booking_id: bookingRef.id, nights: dates.length, guest: guest_name, hotel: hotel_name, room: room_name, check_in, check_out, total_price };
      } catch (err) {
        return err.code === 'NOT_AVAILABLE' ? { error: err.message } : { error: 'Booking failed: ' + err.message };
      }
    }

    case 'update_hotel': {
      const { hotel_id, updates } = args;
      const ref = db.collection('hotels').doc(hotel_id);
      const snap = await ref.get();
      if (!snap.exists) return { error: `Hotel "${hotel_id}" not found.` };
      await ref.update({ ...updates, updatedAt: admin.firestore.FieldValue.serverTimestamp() });
      return { success: true, hotel_id, updated_fields: Object.keys(updates) };
    }

    default:
      return { error: `Unknown tool: ${name}` };
  }
}

// ─── System Prompt ─────────────────────────────────────────────────────────────
const SYSTEM_PROMPT = `أنت "كونسيرج الغردقة" — المساعد الذكي لـ Go-Hurghada Travel Admin Panel.
بتكلم عربي وإنجليزي وبتفهم العامية المصرية كويس.

══════════════════════════════════
عندك أدوات تقدر تستخدمها:
══════════════════════════════════
- search_hotels → دور وعرض الفنادق والأوض
- get_hotel_rooms → اجيب أوض فندق معين
- check_availability → تحقق من التوافر بالتواريخ
- get_activities → اجيب الأنشطة والتورز
- get_bookings → اعرض الحجوزات مع فلاتر
- update_booking_status → أكد أو ألغي أو ارفض حجز
- create_booking → انشئ حجز جديد بفحص التوافر
- update_hotel → عدّل بيانات فندق

══════════════════════════════════
ترجمة العامية للأكشن:
══════════════════════════════════
"احجزلي" / "احجزله" / "عايز أحجز" / "ابقى احجزلي" → create_booking
"ألغي الحجز" / "كنسل" / "إلغاء" → update_booking_status (cancelled)
"أكد الحجز" / "تمم" / "confirm" → update_booking_status (confirmed)
"فيه أوضة؟" / "متاح؟" / "مفيش حاجة؟" / "الفندق فاضي؟" → check_availability
"ورّيني الفنادق" / "اعرض الفنادق" / "الفنادق إيه؟" → search_hotels
"الأوضة بكام؟" / "أرخص أوضة" / "الأغلى إيه؟" → search_hotels
"ورّيني الحجوزات" / "فيه حجوزات pending؟" → get_bookings
"الأنشطة إيه؟" / "فيه تورز؟" / "الرحلات إيه؟" → get_activities

══════════════════════════════════
قواعد أساسية:
══════════════════════════════════
1. استخدم الأدوات دايماً — ماتخمنش أي بيانات. الداتا بتيجي من الـ database فقط.
2. لو المستخدم قال "احجزلي أوضة في فندق X":
   - الخطوة 1: search_hotels (لقي hotel_id و room_id)
   - الخطوة 2: check_availability (تأكد التوافر)
   - الخطوة 3: create_booking (لو متاح)
3. لو معلومة ناقصة (التواريخ مثلاً أو اسم الضيف) — اسأل عنها بأسلوب ودود.
4. بعد أي أكشن (حجز / إلغاء / تعديل) — وضّح للمستخدم بالظبط إيه اللي حصل.
5. فرمت الردود بـ Markdown: جداول للقوائم، **bold** للأسعار والأسماء، ✅ للنجاح، ❌ للخطأ.
6. رد بنفس لغة المستخدم — عربي بعربي، إنجليزي بإنجليزي. لو عامية → رد بعامية.
7. كن ودود ودافئ — مش روبوت. ماتبقاش رسمي زيادة عن اللزوم.`;

// ─── POST /api/ai/chat ─────────────────────────────────────────────────────────
router.post('/chat', async (req, res) => {
  const { messages } = req.body;
  const db = req.db;

  if (!messages || !Array.isArray(messages)) {
    return res.status(400).json({ error: 'Invalid or missing messages array.' });
  }
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) return res.status(500).json({ error: 'GEMINI_API_KEY not configured.' });

  try {
    const ai = new GoogleGenAI({ apiKey });

    // Convert client message history to Gemini format
    const history = messages.slice(0, -1).map(msg => ({
      role: msg.role === 'assistant' ? 'model' : 'user',
      parts: [{ text: msg.content }],
    }));

    const lastUserMessage = messages[messages.length - 1].content;

    // Start chat session with history
    const chat = ai.chats.create({
      model: 'gemini-2.5-flash',
      config: {
        systemInstruction: SYSTEM_PROMPT,
        tools,
      },
      history,
    });

    // Agentic loop
    const toolCallLog = [];
    let finalText = null;
    let currentMessage = lastUserMessage;

    for (let turn = 0; turn < 8; turn++) {
      const response = await chat.sendMessage({ message: currentMessage });

      // Check for function calls
      const functionCalls = response.functionCalls;

      if (!functionCalls || functionCalls.length === 0) {
        finalText = response.text;
        break;
      }

      // Execute all tool calls
      const toolResults = await Promise.all(
        functionCalls.map(async (fc) => {
          toolCallLog.push({ tool: fc.name, args: fc.args });
          const result = await executeTool(fc.name, fc.args, db);
          return { name: fc.name, response: result };
        })
      );

      // Send tool results back and continue loop
      currentMessage = toolResults.map(tr => ({
        functionResponse: {
          name: tr.name,
          response: tr.response
        }
      }));
    }

    if (!finalText) {
      finalText = 'معلش، في مشكلة في معالجة الطلب. جرّب تاني.';
    }

    res.json({ response: finalText, toolsUsed: toolCallLog.map(t => t.tool) });

  } catch (error) {
    console.error('AI Chat Error:', error);
    res.status(500).json({ error: 'AI request failed: ' + error.message });
  }
});

module.exports = router;
