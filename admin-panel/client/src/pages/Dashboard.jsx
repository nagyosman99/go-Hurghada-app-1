import { useState, useEffect } from 'react';
import api from '../api';
import {
  Hotel, BedDouble, Calendar, CheckCircle,
  Clock, XCircle, Loader2, RefreshCw,
  Palmtree, TrendingUp
} from 'lucide-react';

const formatDate = (d) => {
  if (!d) return '—';
  try {
    const date = d?.seconds ? new Date(d.seconds * 1000) : new Date(d);
    return date.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });
  } catch { return '—'; }
};

const StatCard = ({ icon: Icon, label, value, loading, accent, sub }) => (
  <div style={{
    background: '#fff', borderRadius: '20px', padding: '24px',
    border: '1px solid #f1f5f9', boxShadow: '0 1px 4px rgba(0,0,0,0.05)',
    display: 'flex', flexDirection: 'column', gap: '12px'
  }}>
    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
      <div style={{
        width: '44px', height: '44px', borderRadius: '12px',
        background: accent + '18', display: 'flex', alignItems: 'center', justifyContent: 'center'
      }}>
        <Icon size={20} color={accent} />
      </div>
    </div>
    <div>
      <p style={{ fontSize: '13px', color: '#94a3b8', fontWeight: 500, marginBottom: '4px' }}>{label}</p>
      {loading ? (
        <div style={{ width: '48px', height: '32px', background: '#f1f5f9', borderRadius: '8px' }} />
      ) : (
        <p style={{ fontSize: '32px', fontWeight: 800, color: '#0f172a', lineHeight: 1 }}>{value}</p>
      )}
      {sub && !loading && (
        <p style={{ fontSize: '12px', color: '#64748b', marginTop: '6px', fontWeight: 500 }}>{sub}</p>
      )}
    </div>
  </div>
);

const Dashboard = () => {
  const [hotels, setHotels] = useState([]);
  const [activities, setActivities] = useState([]);
  const [bookings, setBookings] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchAll = async () => {
    setLoading(true);
    setError(null);
    try {
      const [h, a, b] = await Promise.all([
        api.get('/hotels'),
        api.get('/activities'),
        api.get('/bookings'),
      ]);
      setHotels(h.data);
      setActivities(a.data);
      setBookings(b.data);
    } catch (err) {
      console.error(err);
      setError('Failed to load dashboard data. Make sure the server is running.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchAll(); }, []);

  // Derived stats
  const confirmedBookings = bookings.filter(b => b.status === 'confirmed');
  const pendingBookings   = bookings.filter(b => b.status === 'pending');
  const cancelledBookings = bookings.filter(b => b.status === 'cancelled');
  const hotelBookings     = bookings.filter(b => b.type === 'hotel' || b.hotelId);
  const activityBookings  = bookings.filter(b => b.type === 'activity' || b.activityId);
  const totalRevenue      = confirmedBookings.reduce((sum, b) => sum + (Number(b.totalPrice) || 0), 0);
  const recentBookings    = [...bookings].slice(0, 6);

  const STATUS_STYLES = {
    confirmed: { bg: '#dcfce7', color: '#15803d' },
    pending:   { bg: '#fef9c3', color: '#b45309' },
    cancelled: { bg: '#fee2e2', color: '#dc2626' },
  };

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '32px' }}>
      {/* Header */}
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <div>
          <h1 style={{ fontSize: '26px', fontWeight: 800, color: '#0f172a', letterSpacing: '-0.5px' }}>
            Dashboard
          </h1>
          <p style={{ fontSize: '14px', color: '#64748b', marginTop: '4px' }}>
            Real-time overview of Go-Hurghada
          </p>
        </div>
        <button onClick={fetchAll} disabled={loading} style={{
          display: 'flex', alignItems: 'center', gap: '8px',
          padding: '10px 16px', borderRadius: '12px',
          border: '1.5px solid #e2e8f0', background: '#fff',
          fontSize: '13px', fontWeight: 600, color: '#475569',
          cursor: loading ? 'not-allowed' : 'pointer', opacity: loading ? 0.6 : 1,
        }}>
          <RefreshCw size={14} style={loading ? { animation: 'spin 1s linear infinite' } : {}} />
          Refresh
        </button>
      </div>

      {error && (
        <div style={{ padding: '14px 18px', background: '#fef2f2', borderRadius: '12px', color: '#dc2626', fontSize: '14px', border: '1px solid #fecaca' }}>
          ⚠️ {error}
        </div>
      )}

      {/* Primary Stats */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '16px' }}>
        <StatCard icon={Hotel}       label="Hotels"       value={hotels.length}       loading={loading} accent="#0061ff" />
        <StatCard icon={Palmtree}    label="Activities"   value={activities.length}   loading={loading} accent="#10b981" />
        <StatCard icon={Calendar}    label="All Bookings" value={bookings.length}      loading={loading} accent="#8b5cf6"
          sub={`${hotelBookings.length} hotel · ${activityBookings.length} activity`} />
        <StatCard icon={TrendingUp}  label="Revenue (Confirmed)" value={loading ? '—' : `$${totalRevenue.toLocaleString('en-US', { minimumFractionDigits: 0 })}`} loading={loading} accent="#f59e0b" />
      </div>

      {/* Booking Status Breakdown */}
      <div style={{ background: '#fff', borderRadius: '20px', padding: '24px', border: '1px solid #f1f5f9', boxShadow: '0 1px 4px rgba(0,0,0,0.05)' }}>
        <h2 style={{ fontSize: '16px', fontWeight: 700, color: '#0f172a', marginBottom: '20px' }}>Booking Status</h2>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '16px' }}>
          {[
            { label: 'Confirmed', count: confirmedBookings.length, icon: CheckCircle, style: STATUS_STYLES.confirmed },
            { label: 'Pending',   count: pendingBookings.length,   icon: Clock,       style: STATUS_STYLES.pending },
            { label: 'Cancelled', count: cancelledBookings.length, icon: XCircle,     style: STATUS_STYLES.cancelled },
          ].map(({ label, count, icon: Icon, style }) => (
            <div key={label} style={{
              background: style.bg, borderRadius: '14px', padding: '18px',
              display: 'flex', alignItems: 'center', gap: '14px'
            }}>
              <Icon size={22} color={style.color} />
              <div>
                <p style={{ fontSize: '22px', fontWeight: 800, color: style.color, lineHeight: 1 }}>
                  {loading ? '—' : count}
                </p>
                <p style={{ fontSize: '12px', fontWeight: 600, color: style.color, opacity: 0.8, marginTop: '3px' }}>{label}</p>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Recent Bookings */}
      <div style={{ background: '#fff', borderRadius: '20px', border: '1px solid #f1f5f9', boxShadow: '0 1px 4px rgba(0,0,0,0.05)', overflow: 'hidden' }}>
        <div style={{ padding: '20px 24px', borderBottom: '1px solid #f8fafc' }}>
          <h2 style={{ fontSize: '16px', fontWeight: 700, color: '#0f172a' }}>Latest Bookings</h2>
        </div>

        {loading ? (
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '10px', padding: '40px', color: '#94a3b8' }}>
            <Loader2 size={20} style={{ animation: 'spin 1s linear infinite' }} />
            <span style={{ fontSize: '14px', fontWeight: 500 }}>Loading...</span>
          </div>
        ) : recentBookings.length === 0 ? (
          <div style={{ textAlign: 'center', padding: '48px', color: '#94a3b8', fontSize: '14px' }}>
            No bookings yet.
          </div>
        ) : (
          <div style={{ overflowX: 'auto' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '13px' }}>
              <thead>
                <tr style={{ background: '#f8fafc' }}>
                  {['Guest', 'Service', 'Room', 'Check-in', 'Total', 'Status'].map(h => (
                    <th key={h} style={{ padding: '12px 20px', textAlign: 'left', fontSize: '11px', fontWeight: 700, color: '#94a3b8', textTransform: 'uppercase', letterSpacing: '0.06em' }}>{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {recentBookings.map((b, i) => {
                  const st = STATUS_STYLES[b.status] || { bg: '#f1f5f9', color: '#64748b' };
                  return (
                    <tr key={b.id} style={{ borderTop: '1px solid #f8fafc', background: i % 2 === 0 ? '#fff' : '#fafbfc' }}>
                      <td style={{ padding: '14px 20px' }}>
                        <p style={{ fontWeight: 600, color: '#0f172a' }}>{b.guestName || '—'}</p>
                        <p style={{ fontSize: '11px', color: '#94a3b8', marginTop: '2px' }}>{b.guestEmail || ''}</p>
                      </td>
                      <td style={{ padding: '14px 20px', color: '#475569', fontWeight: 500 }}>
                        {b.hotelName || b.activityName || '—'}
                      </td>
                      <td style={{ padding: '14px 20px', color: '#475569' }}>
                        {b.roomName || (b.persons ? `${b.persons} pax` : '—')}
                      </td>
                      <td style={{ padding: '14px 20px', color: '#475569' }}>
                        {formatDate(b.checkInDate || b.selectedDate)}
                      </td>
                      <td style={{ padding: '14px 20px', fontWeight: 700, color: '#0f172a' }}>
                        ${Number(b.totalPrice || 0).toFixed(2)}
                      </td>
                      <td style={{ padding: '14px 20px' }}>
                        <span style={{
                          display: 'inline-block', padding: '3px 10px', borderRadius: '20px',
                          background: st.bg, color: st.color,
                          fontSize: '11px', fontWeight: 700
                        }}>
                          {b.status || 'unknown'}
                        </span>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
};

export default Dashboard;
