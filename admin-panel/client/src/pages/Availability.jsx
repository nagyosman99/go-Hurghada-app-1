import { useState, useEffect, useCallback } from 'react';
import api from '../api';
import {
  Calendar, Search, Loader2, RefreshCw, CheckCircle2,
  XCircle, Hotel, Layers, AlertTriangle, ChevronDown,
  Info, Home
} from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

// ─── Helpers ────────────────────────────────────────────────────────────────

const today = () => new Date().toISOString().split('T')[0];
const addDays = (dateStr, n) => {
  const d = new Date(`${dateStr}T00:00:00Z`);
  d.setUTCDate(d.getUTCDate() + n);
  return d.toISOString().split('T')[0];
};

const formatDateDisplay = (dateStr) => {
  const [y, m, d] = dateStr.split('-');
  const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  return `${d} ${months[parseInt(m) - 1]}`;
};

const weekDays = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];

// ─── Day Cell ────────────────────────────────────────────────────────────────

const DayCell = ({ dateStr, data }) => {
  const dayOfWeek = new Date(`${dateStr}T00:00:00Z`).getUTCDay();
  const dayNum = dateStr.split('-')[2];
  const isWeekend = dayOfWeek === 0 || dayOfWeek === 6;

  let bg = 'bg-emerald-50 border-emerald-200';
  let textColor = 'text-emerald-800';
  let badge = null;

  if (!data) {
    // No data = fully available (no availability doc)
    badge = (
      <span className="text-[10px] font-bold text-emerald-500 uppercase tracking-wide">
        Free
      </span>
    );
  } else if (!data.available) {
    bg = 'bg-red-50 border-red-200';
    textColor = 'text-red-800';
    badge = (
      <span className="text-[10px] font-bold text-red-500 uppercase tracking-wide">
        Full
      </span>
    );
  } else {
    const pct = Math.round((data.remainingRooms / data.totalCount) * 100);
    if (pct <= 30) {
      bg = 'bg-amber-50 border-amber-200';
      textColor = 'text-amber-800';
    }
    badge = (
      <span className={`text-[10px] font-bold ${pct <= 30 ? 'text-amber-500' : 'text-emerald-500'} uppercase tracking-wide`}>
        {data.remainingRooms}/{data.totalCount}
      </span>
    );
  }

  return (
    <div className={`relative border rounded-xl p-2 flex flex-col items-center gap-0.5 transition-all
      ${bg} ${isWeekend ? 'opacity-75' : ''}`}>
      <span className={`text-[10px] font-semibold uppercase tracking-widest ${textColor} opacity-60`}>
        {weekDays[dayOfWeek]}
      </span>
      <span className={`text-lg font-bold leading-none ${textColor}`}>{dayNum}</span>
      {badge}
      {data && !data.available && (
        <XCircle className="absolute top-1.5 right-1.5 w-3 h-3 text-red-400" />
      )}
      {(!data || data.available) && (
        <CheckCircle2 className="absolute top-1.5 right-1.5 w-3 h-3 text-emerald-400" />
      )}
    </div>
  );
};

// ─── Main Component ──────────────────────────────────────────────────────────

const Availability = () => {
  const [hotels, setHotels] = useState([]);
  const [rooms, setRooms] = useState([]);
  const [selectedHotel, setSelectedHotel] = useState('');
  const [selectedRoom, setSelectedRoom] = useState('');
  const [startDate, setStartDate] = useState(today());
  const [endDate, setEndDate] = useState(addDays(today(), 14));
  const [availability, setAvailability] = useState([]);
  const [loading, setLoading] = useState(false);
  const [loadingRooms, setLoadingRooms] = useState(false);
  const [error, setError] = useState('');
  const [searched, setSearched] = useState(false);

  // Load hotels on mount
  useEffect(() => {
    api.get('/hotels')
      .then(res => setHotels(res.data))
      .catch(() => setError('Failed to load hotels.'));
  }, []);

  // Load rooms when hotel changes
  useEffect(() => {
    if (!selectedHotel) { setRooms([]); setSelectedRoom(''); return; }
    setLoadingRooms(true);
    setSelectedRoom('');
    api.get(`/hotels/${selectedHotel}/rooms`)
      .then(res => setRooms(res.data))
      .catch(() => setRooms([]))
      .finally(() => setLoadingRooms(false));
  }, [selectedHotel]);

  const handleSearch = useCallback(async () => {
    if (!selectedHotel || !selectedRoom || !startDate || !endDate) {
      setError('Please select a hotel, a room, and a date range.');
      return;
    }
    if (endDate <= startDate) {
      setError('End date must be after start date.');
      return;
    }
    setError('');
    setLoading(true);
    setSearched(true);
    try {
      const res = await api.get('/availability', {
        params: { hotelId: selectedHotel, roomId: selectedRoom, startDate, endDate },
      });
      setAvailability(res.data);
    } catch (err) {
      setError(err.response?.data?.error || 'Failed to fetch availability.');
      setAvailability([]);
    } finally {
      setLoading(false);
    }
  }, [selectedHotel, selectedRoom, startDate, endDate]);

  // Build a map for O(1) lookup
  const availMap = {};
  availability.forEach(a => { availMap[a.date] = a; });

  const selectedHotelObj = hotels.find(h => h.id === selectedHotel);
  const selectedRoomObj   = rooms.find(r => r.id === selectedRoom);

  const availCount   = availability.filter(a => a.available).length;
  const unavailCount = availability.filter(a => !a.available).length;

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-2xl sm:text-3xl font-bold text-gray-900">Availability Calendar</h1>
        <p className="text-gray-500 mt-1 text-sm font-medium">
          Check real-time room availability across any date range
        </p>
      </div>

      {/* Filters Card */}
      <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
        <h2 className="text-xs uppercase tracking-wider text-gray-400 font-bold mb-4">Search Availability</h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          {/* Hotel */}
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5">
              <Hotel className="w-3.5 h-3.5 inline mr-1 text-blue-500" />Hotel
            </label>
            <select
              value={selectedHotel}
              onChange={e => setSelectedHotel(e.target.value)}
              className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all bg-white"
            >
              <option value="">Select hotel...</option>
              {hotels.map(h => (
                <option key={h.id} value={h.id}>{h.name}</option>
              ))}
            </select>
          </div>

          {/* Room */}
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5">
              <Layers className="w-3.5 h-3.5 inline mr-1 text-blue-500" />Room Type
            </label>
            <select
              value={selectedRoom}
              onChange={e => setSelectedRoom(e.target.value)}
              disabled={!selectedHotel || loadingRooms}
              className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all bg-white disabled:opacity-50"
            >
              <option value="">
                {loadingRooms ? 'Loading...' : !selectedHotel ? 'Select hotel first' : 'Select room...'}
              </option>
              {rooms.map(r => (
                <option key={r.id} value={r.id}>
                  {r.name} {r.totalCount ? `(${r.totalCount} units)` : '⚠ no totalCount'}
                </option>
              ))}
            </select>
          </div>

          {/* Start Date */}
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5">
              <Calendar className="w-3.5 h-3.5 inline mr-1 text-blue-500" />From Date
            </label>
            <input
              type="date"
              value={startDate}
              onChange={e => setStartDate(e.target.value)}
              className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all"
            />
          </div>

          {/* End Date */}
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5">
              <Calendar className="w-3.5 h-3.5 inline mr-1 text-blue-500" />To Date
            </label>
            <input
              type="date"
              value={endDate}
              onChange={e => setEndDate(e.target.value)}
              min={startDate}
              className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all"
            />
          </div>
        </div>

        {error && (
          <div className="mt-4 flex items-center gap-2 text-sm text-red-600 bg-red-50 border border-red-100 rounded-xl px-4 py-2.5">
            <AlertTriangle className="w-4 h-4 flex-shrink-0" />{error}
          </div>
        )}

        <button
          onClick={handleSearch}
          disabled={loading || !selectedHotel || !selectedRoom}
          className="mt-4 inline-flex items-center gap-2 bg-blue-600 text-white px-6 py-2.5 rounded-xl font-semibold text-sm hover:bg-blue-700 transition-all shadow-lg shadow-blue-500/20 disabled:opacity-50"
        >
          {loading ? <Loader2 className="w-4 h-4 animate-spin" /> : <Search className="w-4 h-4" />}
          {loading ? 'Checking...' : 'Check Availability'}
        </button>
      </div>

      {/* Results */}
      <AnimatePresence>
        {searched && (
          <motion.div
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: 12 }}
            className="space-y-4"
          >
            {/* Summary bar */}
            {!loading && availability.length > 0 && (
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 bg-white rounded-2xl border border-gray-100 px-5 py-4 shadow-sm">
                <div>
                  <p className="text-sm font-bold text-gray-900">
                    {selectedHotelObj?.name} — {selectedRoomObj?.name}
                  </p>
                  <p className="text-xs text-gray-400 mt-0.5">
                    {formatDateDisplay(startDate)} → {formatDateDisplay(endDate)}
                    {selectedRoomObj?.totalCount && (
                      <span className="ml-2 bg-blue-50 text-blue-600 px-1.5 py-0.5 rounded-full font-semibold">
                        {selectedRoomObj.totalCount} units total
                      </span>
                    )}
                  </p>
                </div>
                <div className="flex gap-3">
                  <div className="flex items-center gap-1.5 px-3 py-1.5 bg-emerald-50 rounded-xl text-emerald-700 text-xs font-bold">
                    <CheckCircle2 className="w-3.5 h-3.5" />{availCount} available
                  </div>
                  <div className="flex items-center gap-1.5 px-3 py-1.5 bg-red-50 rounded-xl text-red-700 text-xs font-bold">
                    <XCircle className="w-3.5 h-3.5" />{unavailCount} fully booked
                  </div>
                </div>
              </div>
            )}

            {/* Loading */}
            {loading && (
              <div className="flex items-center justify-center py-20 gap-3 bg-white rounded-2xl border border-gray-100">
                <Loader2 className="w-7 h-7 text-blue-600 animate-spin" />
                <span className="text-gray-500 text-sm font-medium">Fetching availability…</span>
              </div>
            )}

            {/* Calendar Grid */}
            {!loading && availability.length > 0 && (
              <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                <h3 className="text-xs uppercase tracking-wider text-gray-400 font-bold mb-4">
                  Day-by-Day Availability
                </h3>

                {/* Legend */}
                <div className="flex flex-wrap gap-3 mb-4 text-xs font-semibold">
                  <span className="flex items-center gap-1.5 text-emerald-700">
                    <span className="w-3 h-3 rounded bg-emerald-200 inline-block" />Available
                  </span>
                  <span className="flex items-center gap-1.5 text-amber-600">
                    <span className="w-3 h-3 rounded bg-amber-200 inline-block" />Almost full (≤30%)
                  </span>
                  <span className="flex items-center gap-1.5 text-red-600">
                    <span className="w-3 h-3 rounded bg-red-200 inline-block" />Fully booked
                  </span>
                </div>

                <div className="grid grid-cols-4 sm:grid-cols-7 lg:grid-cols-10 gap-2">
                  {availability.map(item => (
                    <DayCell
                      key={item.date}
                      dateStr={item.date}
                      data={item}
                    />
                  ))}
                </div>
              </div>
            )}

            {/* No data */}
            {!loading && searched && availability.length === 0 && !error && (
              <div className="text-center py-16 bg-white rounded-2xl border border-gray-100">
                <Info className="w-10 h-10 text-gray-300 mx-auto mb-3" />
                <p className="text-gray-400 text-sm font-medium">No availability data returned.</p>
                <p className="text-gray-300 text-xs mt-1">Check that this room has a valid totalCount.</p>
              </div>
            )}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};

export default Availability;
