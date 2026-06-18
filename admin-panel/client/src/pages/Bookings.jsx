import { useState, useEffect } from 'react';
import api from '../api';
import {
  Calendar, User, Mail, Phone, CreditCard, Loader2,
  CheckCircle, Clock, XCircle, Search, RefreshCw,
  Hotel, Zap, Tag, ChevronRight, X, MapPin, Users, BedDouble,
  Info, DollarSign, Gift, Ban, Moon
} from 'lucide-react';

const STATUS_STYLES = {
  confirmed: 'bg-emerald-100 text-emerald-700 border border-emerald-200',
  pending:   'bg-amber-100 text-amber-700 border border-amber-200',
  cancelled: 'bg-red-100 text-red-700 border border-red-200',
};
const STATUS_ICONS = { confirmed: CheckCircle, pending: Clock, cancelled: XCircle };

const formatDate = (date) => {
  if (!date) return null;
  try {
    const d = date?.seconds ? new Date(date.seconds * 1000) : new Date(date);
    return d.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });
  } catch { return null; }
};

const Field = ({ label, value, icon: Icon, mono }) => {
  if (value == null || value === '' || value === 'null') return null;
  return (
    <div className="flex gap-3 py-2.5 border-b border-gray-50 last:border-0">
      {Icon && <Icon className="w-4 h-4 text-gray-400 mt-0.5 flex-shrink-0" />}
      <div className="flex-1 min-w-0">
        <p className="text-xs text-gray-400 font-medium uppercase tracking-wider mb-0.5">{label}</p>
        <p className={`text-sm text-gray-800 break-all font-medium ${mono ? 'font-mono text-xs' : ''}`}>{value}</p>
      </div>
    </div>
  );
};

const DetailModal = ({ booking, onClose, onStatusChange, onCancel }) => {
  const [saving, setSaving] = useState(false);
  const [cancelling, setCancelling] = useState(false);

  const changeStatus = async (newStatus) => {
    setSaving(true);
    try {
      await onStatusChange(booking, newStatus);
    } finally {
      setSaving(false);
    }
  };

  const handleCancel = async () => {
    if (!window.confirm('Cancel this booking? Availability will be restored.')) return;
    setCancelling(true);
    try {
      await onCancel(booking);
    } finally {
      setCancelling(false);
    }
  };

  const isHotel = booking.type === 'hotel' || !!booking.hotelId;
  // nights from new booking docs
  const nights = booking.nights ||
    (booking.checkIn && booking.checkOut
      ? Math.round((new Date(booking.checkOut) - new Date(booking.checkIn)) / 86400000)
      : null);

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm" onClick={onClose}>
      <div className="bg-white rounded-3xl shadow-2xl w-full max-w-2xl max-h-[90vh] overflow-hidden flex flex-col" onClick={e => e.stopPropagation()}>
        {/* Header */}
        <div className={`px-6 py-5 flex items-start justify-between ${isHotel ? 'bg-gradient-to-r from-blue-600 to-indigo-600' : 'bg-gradient-to-r from-emerald-500 to-teal-500'}`}>
          <div>
            <div className="flex items-center gap-2 mb-1">
              {isHotel ? <BedDouble className="w-5 h-5 text-white/80" /> : <Zap className="w-5 h-5 text-white/80" />}
              <span className="text-white/80 text-sm font-semibold uppercase tracking-wide">{isHotel ? 'Hotel Booking' : 'Activity Booking'}</span>
            </div>
            <h2 className="text-xl font-bold text-white">{booking.hotelName || booking.activityName || 'Booking'}</h2>
            <p className="text-white/70 text-xs font-mono mt-1">{booking.id}</p>
          </div>
          <button onClick={onClose} className="p-2 rounded-full hover:bg-white/20 text-white transition-colors">
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Content */}
        <div className="overflow-y-auto flex-1 px-6 py-4 space-y-5">

          {/* Status Control */}
          <div className="flex items-center gap-3 flex-wrap">
            <span className="text-sm font-semibold text-gray-600">Status:</span>
            {['confirmed', 'pending', 'cancelled'].map(s => (
              <button key={s} disabled={saving || booking.status === s}
                onClick={() => changeStatus(s)}
                className={`px-3 py-1.5 rounded-full text-xs font-bold transition-all border ${booking.status === s ? STATUS_STYLES[s] + ' ring-2 ring-offset-1 ring-current' : 'bg-gray-100 text-gray-500 border-gray-200 hover:bg-gray-200'}`}>
                {s.charAt(0).toUpperCase() + s.slice(1)}
              </button>
            ))}
            {saving && <Loader2 className="w-4 h-4 animate-spin text-gray-400" />}
          </div>

          {/* Cancel Booking (new availability system) */}
          {isHotel && booking.status === 'confirmed' && booking.checkIn && (
            <div className="flex items-center gap-3 p-3 bg-red-50 rounded-xl border border-red-100">
              <Ban className="w-4 h-4 text-red-500 flex-shrink-0" />
              <div className="flex-1 min-w-0">
                <p className="text-xs font-semibold text-red-700">Cancel this booking?</p>
                <p className="text-xs text-red-500 mt-0.5">Availability will be restored for all booked dates.</p>
              </div>
              <button
                onClick={handleCancel}
                disabled={cancelling}
                className="flex items-center gap-1.5 px-3 py-1.5 bg-red-500 text-white text-xs font-bold rounded-lg hover:bg-red-600 transition-all disabled:opacity-60 flex-shrink-0"
              >
                {cancelling ? <Loader2 className="w-3 h-3 animate-spin" /> : <Ban className="w-3 h-3" />}
                {cancelling ? 'Cancelling...' : 'Cancel Booking'}
              </button>
            </div>
          )}

          {/* Guest Info */}
          <div className="bg-gray-50 rounded-2xl p-4">
            <h3 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-3">Guest Information</h3>
            <Field icon={User}     label="Full Name"   value={booking.guestName} />
            <Field icon={Mail}     label="Email"       value={booking.guestEmail} />
            <Field icon={Phone}    label="Phone"       value={booking.guestPhone} />
            <Field icon={Info}     label="User ID"     value={booking.userId} mono />
          </div>

          {/* Booking Info */}
          <div className="bg-gray-50 rounded-2xl p-4">
            <h3 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-3">{isHotel ? 'Hotel Details' : 'Activity Details'}</h3>
            <Field icon={Hotel}    label="Hotel"          value={booking.hotelName} />
            <Field icon={MapPin}   label="Address"        value={booking.hotelAddress} />
            <Field icon={BedDouble} label="Room"          value={booking.roomName} />
            <Field icon={Info}     label="Hotel ID"       value={booking.hotelId} mono />
            <Field icon={Info}     label="Room ID"        value={booking.roomId} mono />
            <Field icon={Zap}      label="Activity"       value={booking.activityName} />
            <Field icon={Info}     label="Activity ID"    value={booking.activityId} mono />
          </div>

          {/* Dates & Occupancy */}
          <div className="bg-gray-50 rounded-2xl p-4">
            <h3 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-3">Dates &amp; Guests</h3>
            {/* New booking system fields */}
            <Field icon={Calendar} label="Check-in"      value={booking.checkIn || formatDate(booking.checkInDate)} />
            <Field icon={Calendar} label="Check-out"     value={booking.checkOut || formatDate(booking.checkOutDate)} />
            {nights != null && <Field icon={Moon} label="Nights" value={`${nights} night${nights !== 1 ? 's' : ''}`} />}
            {/* Legacy fields */}
            <Field icon={Calendar} label="Selected Date"  value={formatDate(booking.selectedDate)} />
            <Field icon={Users}    label="Adults"         value={booking.adults} />
            <Field icon={Users}    label="Children"       value={booking.children} />
            <Field icon={BedDouble} label="Rooms Count"   value={booking.roomsCount} />
            <Field icon={Users}    label="Persons"        value={booking.persons} />
            <Field icon={MapPin}   label="Pickup Location" value={booking.pickupLocation} />
          </div>

          {/* Pricing */}
          <div className="bg-gray-50 rounded-2xl p-4">
            <h3 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-3">Pricing</h3>
            <Field icon={DollarSign} label="Total Price"       value={booking.totalPrice != null ? `$${Number(booking.totalPrice).toFixed(2)}` : null} />
            <Field icon={DollarSign} label="Original Price"    value={booking.totalOriginalPrice != null ? `$${Number(booking.totalOriginalPrice).toFixed(2)}` : null} />
            <Field icon={Tag}        label="Discount %"        value={booking.discountPercentage != null && booking.discountPercentage > 0 ? `${(booking.discountPercentage * 100).toFixed(0)}%` : null} />
            <Field icon={Info}       label="Pricing Mode"      value={booking.isPerGuest ? 'Per Guest' : null} />
          </div>

          {/* Offer Info */}
          {(booking.offerId && booking.offerId !== booking.hotelId) && (
            <div className="bg-amber-50 rounded-2xl p-4 border border-amber-100">
              <h3 className="text-xs font-bold text-amber-500 uppercase tracking-wider mb-3">Applied Offer</h3>
              <Field icon={Gift}  label="Offer Title" value={booking.offerTitle} />
              <Field icon={Info}  label="Offer ID"    value={booking.offerId} mono />
            </div>
          )}

          {/* Meta */}
          <div className="bg-gray-50 rounded-2xl p-4">
            <h3 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-3">Metadata</h3>
            <Field icon={Clock}  label="Created At"   value={formatDate(booking.createdAt)} />
            <Field icon={Info}   label="Booking Type" value={booking.type} />
            <Field icon={Info}   label="Status"       value={booking.status} />
            <Field icon={Info}   label="Booking ID"   value={booking.id} mono />
          </div>
        </div>
      </div>
    </div>
  );
};

const Bookings = () => {
  const [bookings, setBookings] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [typeFilter, setTypeFilter] = useState('all');
  const [selected, setSelected] = useState(null);

  useEffect(() => { fetchBookings(); }, []);

  const fetchBookings = async () => {
    setLoading(true);
    try {
      const res = await api.get('/bookings');
      setBookings(res.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleStatusChange = async (booking, newStatus) => {
    try {
      const userId = booking.userId;
      const bookingId = booking.id;
      await api.patch(`/bookings/${userId}/${bookingId}`, { status: newStatus });
      setBookings(prev => prev.map(b => b.id === bookingId ? { ...b, status: newStatus } : b));
      setSelected(prev => prev?.id === bookingId ? { ...prev, status: newStatus } : prev);
    } catch (err) {
      alert('Failed to update status: ' + (err.response?.data?.error || err.message));
    }
  };

  const handleCancelBooking = async (booking) => {
    try {
      // New availability-aware cancellation endpoint
      await api.patch(`/hotel-bookings/${booking.id}/cancel`);
      setBookings(prev => prev.map(b =>
        b.id === booking.id ? { ...b, status: 'cancelled' } : b
      ));
      setSelected(prev =>
        prev?.id === booking.id ? { ...prev, status: 'cancelled' } : prev
      );
    } catch (err) {
      const msg = err.response?.data?.error || err.message;
      alert('Failed to cancel booking: ' + msg);
    }
  };

  const filtered = bookings.filter(b => {
    const matchStatus = statusFilter === 'all' || b.status === statusFilter;
    const matchType = typeFilter === 'all' || b.type === typeFilter;
    const term = searchTerm.toLowerCase();
    const matchSearch = !searchTerm ||
      b.guestName?.toLowerCase().includes(term) ||
      b.guestEmail?.toLowerCase().includes(term) ||
      b.hotelName?.toLowerCase().includes(term) ||
      b.activityName?.toLowerCase().includes(term) ||
      b.roomName?.toLowerCase().includes(term) ||
      b.id?.toLowerCase().includes(term) ||
      b.userId?.toLowerCase().includes(term);
    return matchStatus && matchSearch && matchType;
  });

  const totals = {
    all: bookings.length,
    confirmed: bookings.filter(b => b.status === 'confirmed').length,
    pending: bookings.filter(b => b.status === 'pending').length,
    cancelled: bookings.filter(b => b.status === 'cancelled').length,
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl sm:text-3xl font-bold text-gray-900">User Bookings</h1>
          <p className="text-gray-500 mt-1 text-sm font-medium">{bookings.length} total reservations across all users</p>
        </div>
        <button onClick={fetchBookings}
          className="inline-flex items-center gap-2 bg-white border border-gray-200 text-gray-600 px-4 py-2.5 rounded-xl font-semibold hover:bg-gray-50 transition-all text-sm">
          <RefreshCw className="w-4 h-4" /> Refresh
        </button>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
        {[
          { label: 'All', key: 'all', color: 'bg-gray-900 text-white' },
          { label: 'Confirmed', key: 'confirmed', color: 'bg-emerald-600 text-white' },
          { label: 'Pending', key: 'pending', color: 'bg-amber-400 text-white' },
          { label: 'Cancelled', key: 'cancelled', color: 'bg-red-500 text-white' },
        ].map(({ label, key, color }) => (
          <button key={key} onClick={() => setStatusFilter(key)}
            className={`p-4 rounded-2xl text-left transition-all ${statusFilter === key ? color : 'bg-white border border-gray-100 hover:border-gray-300'}`}>
            <p className={`text-2xl font-bold ${statusFilter === key ? '' : 'text-gray-900'}`}>{totals[key]}</p>
            <p className={`text-xs font-semibold mt-1 ${statusFilter === key ? 'opacity-80' : 'text-gray-500'}`}>{label}</p>
          </button>
        ))}
      </div>

      <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
        {/* Filters */}
        <div className="p-4 border-b border-gray-100 flex flex-col sm:flex-row gap-3">
          <div className="relative flex-1 max-w-sm">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-4 h-4" />
            <input type="text" placeholder="Search name, email, hotel, room..."
              value={searchTerm} onChange={e => setSearchTerm(e.target.value)}
              className="w-full pl-9 pr-4 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all" />
          </div>
          <select value={typeFilter} onChange={e => setTypeFilter(e.target.value)}
            className="px-3 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 bg-white">
            <option value="all">All Types</option>
            <option value="hotel">Hotel</option>
            <option value="activity">Activity</option>
          </select>
        </div>

        <div className="overflow-x-auto">
          {loading ? (
            <div className="flex items-center justify-center py-20 gap-3">
              <Loader2 className="w-8 h-8 text-blue-600 animate-spin" />
              <span className="text-gray-500 font-medium text-sm">Loading bookings...</span>
            </div>
          ) : filtered.length === 0 ? (
            <div className="text-center py-20 text-gray-400 font-medium">No bookings found.</div>
          ) : (
            <table className="w-full text-sm">
              <thead className="bg-gray-50 text-gray-500 text-xs uppercase tracking-wide font-semibold">
                <tr>
                  <th className="px-6 py-3 text-left">Type</th>
                  <th className="px-6 py-3 text-left">Guest</th>
                  <th className="px-6 py-3 text-left hidden md:table-cell">Service</th>
                  <th className="px-6 py-3 text-left hidden lg:table-cell">Room</th>
                  <th className="px-6 py-3 text-left hidden lg:table-cell">Check-in</th>
                  <th className="px-6 py-3 text-left hidden lg:table-cell">Nights</th>
                  <th className="px-6 py-3 text-left hidden sm:table-cell">Total</th>
                  <th className="px-6 py-3 text-left">Status</th>
                  <th className="px-6 py-3 text-left w-10"></th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {filtered.map(b => {
                  const StatusIcon = STATUS_ICONS[b.status] || Clock;
                  const isHotel = b.type === 'hotel' || !!b.hotelId;
                  const nights = b.checkInDate && b.checkOutDate
                    ? Math.round((new Date(b.checkOutDate) - new Date(b.checkInDate)) / 86400000)
                    : null;
                  const hasOffer = b.offerId && b.offerId !== b.hotelId;

                  return (
                    <tr key={b.id} onClick={() => setSelected(b)}
                      className="hover:bg-blue-50/30 transition-colors cursor-pointer">
                      <td className="px-6 py-4">
                        <span className={`inline-flex items-center gap-1 px-2 py-1 rounded-lg text-xs font-bold ${isHotel ? 'bg-blue-50 text-blue-600' : 'bg-emerald-50 text-emerald-600'}`}>
                          {isHotel ? <BedDouble className="w-3 h-3" /> : <Zap className="w-3 h-3" />}
                          {isHotel ? 'Hotel' : 'Activity'}
                        </span>
                      </td>
                      <td className="px-6 py-4">
                        <p className="font-semibold text-gray-900">{b.guestName || 'Guest'}</p>
                        <p className="text-xs text-gray-400 mt-0.5">{b.guestEmail}</p>
                        {b.guestPhone && <p className="text-xs text-gray-400">{b.guestPhone}</p>}
                      </td>
                      <td className="px-6 py-4 hidden md:table-cell">
                        <p className="font-semibold text-gray-900 truncate max-w-[140px]">
                          {b.hotelName || b.activityName || '—'}
                        </p>
                        {hasOffer && (
                          <p className="text-xs text-amber-500 flex items-center gap-1 mt-0.5">
                            <Gift className="w-3 h-3" /> {b.offerTitle}
                          </p>
                        )}
                      </td>
                      <td className="px-6 py-4 hidden lg:table-cell text-gray-500 text-xs">
                        {b.roomName || b.activityName || '—'}
                      </td>
                      <td className="px-6 py-4 hidden lg:table-cell">
                        <span className="flex items-center gap-1.5 text-gray-500 text-xs">
                          <Calendar className="w-3.5 h-3.5" />
                          {formatDate(b.checkInDate || b.selectedDate) || '—'}
                        </span>
                      </td>
                      <td className="px-6 py-4 hidden lg:table-cell text-gray-500 text-xs font-medium">
                        {nights != null ? `${nights}n` : b.persons ? `${b.persons} pax` : '—'}
                      </td>
                      <td className="px-6 py-4 hidden sm:table-cell">
                        <span className="font-bold text-gray-900">${Number(b.totalPrice || 0).toFixed(2)}</span>
                        {b.discountPercentage > 0 && (
                          <p className="text-xs text-emerald-500">{(b.discountPercentage * 100).toFixed(0)}% off</p>
                        )}
                      </td>
                      <td className="px-6 py-4">
                        <span className={`inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-bold ${STATUS_STYLES[b.status] || 'bg-gray-100 text-gray-600'}`}>
                          <StatusIcon className="w-3 h-3" />
                          {b.status || 'unknown'}
                        </span>
                      </td>
                      <td className="px-6 py-4">
                        <ChevronRight className="w-4 h-4 text-gray-300" />
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          )}
        </div>
      </div>

      {selected && (
        <DetailModal
          booking={selected}
          onClose={() => setSelected(null)}
          onStatusChange={handleStatusChange}
          onCancel={handleCancelBooking}
        />
      )}
    </div>
  );
};

export default Bookings;
