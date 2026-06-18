import { useState } from 'react';
import { signInWithEmailAndPassword } from 'firebase/auth';
import { auth, db } from '../firebase';
import { doc, getDoc } from 'firebase/firestore';
import { Eye, EyeOff, ShieldCheck, AlertCircle, Loader2, ArrowRight } from 'lucide-react';

const Login = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPass, setShowPass] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const currentUser = auth.currentUser;

  const handleLogin = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    try {
      const cred = await signInWithEmailAndPassword(auth, email, password);
      const snap = await getDoc(doc(db, 'users', cred.user.uid));
      if (!snap.exists() || snap.data().role !== 'admin') {
        await auth.signOut();
        setError('Access denied: You do not have administrator privileges.');
      }
    } catch {
      setError('Invalid email or password. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const handleLogout = async () => {
    await auth.signOut();
    window.location.reload();
  };

  return (
    <div className="min-h-screen flex" style={{ fontFamily: "'Inter', sans-serif" }}>
      {/* Left decorative panel */}
      <div className="hidden lg:flex lg:w-1/2 relative overflow-hidden"
        style={{ background: 'linear-gradient(135deg, #0061ff 0%, #003db5 50%, #001f6e 100%)' }}>
        {/* Blobs */}
        <div style={{
          position: 'absolute', top: '-80px', right: '-80px',
          width: '400px', height: '400px', borderRadius: '50%',
          background: 'rgba(255,255,255,0.06)'
        }} />
        <div style={{
          position: 'absolute', bottom: '-100px', left: '-60px',
          width: '350px', height: '350px', borderRadius: '50%',
          background: 'rgba(255,255,255,0.05)'
        }} />
        <div style={{
          position: 'absolute', top: '40%', left: '10%',
          width: '180px', height: '180px', borderRadius: '50%',
          background: 'rgba(255,255,255,0.04)'
        }} />

        <div className="relative z-10 flex flex-col justify-center px-16 text-white">
          {/* Logo */}
          <div className="flex items-center gap-3 mb-16">
            <div style={{
              width: '44px', height: '44px', borderRadius: '12px',
              background: 'rgba(255,255,255,0.2)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              backdropFilter: 'blur(8px)',
            }}>
              <ShieldCheck size={24} color="white" />
            </div>
            <span style={{ fontSize: '18px', fontWeight: 700, letterSpacing: '-0.3px' }}>Go-Hurghada</span>
          </div>

          <h2 style={{ fontSize: '40px', fontWeight: 800, lineHeight: 1.15, letterSpacing: '-1px', marginBottom: '20px' }}>
            Admin Control<br />Center
          </h2>
          <p style={{ fontSize: '16px', color: 'rgba(255,255,255,0.65)', lineHeight: 1.7, maxWidth: '360px' }}>
            Manage hotels, bookings, activities, and users from one powerful dashboard.
          </p>

          {/* Feature list */}
          <div style={{ marginTop: '48px', display: 'flex', flexDirection: 'column', gap: '16px' }}>
            {['Full hotel & room management', 'Real-time bookings overview', 'Activity catalog control'].map(f => (
              <div key={f} style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                <div style={{
                  width: '8px', height: '8px', borderRadius: '50%',
                  background: 'rgba(255,255,255,0.5)', flexShrink: 0
                }} />
                <span style={{ fontSize: '14px', color: 'rgba(255,255,255,0.75)', fontWeight: 500 }}>{f}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Right form panel */}
      <div className="flex-1 flex items-center justify-center px-6 py-12 bg-white">
        <div style={{ width: '100%', maxWidth: '420px' }}>

          {/* Mobile logo */}
          <div className="lg:hidden flex items-center gap-2 mb-10 justify-center">
            <div style={{
              width: '40px', height: '40px', borderRadius: '10px',
              background: '#0061ff', display: 'flex', alignItems: 'center', justifyContent: 'center'
            }}>
              <ShieldCheck size={22} color="white" />
            </div>
            <span style={{ fontSize: '17px', fontWeight: 700, color: '#111' }}>Go-Hurghada Admin</span>
          </div>

          <div style={{ marginBottom: '36px' }}>
            <h1 style={{ fontSize: '28px', fontWeight: 800, color: '#0f172a', letterSpacing: '-0.5px', marginBottom: '8px' }}>
              Welcome back 👋
            </h1>
            <p style={{ fontSize: '15px', color: '#64748b', fontWeight: 400 }}>
              Sign in to your admin account to continue.
            </p>
          </div>

          {/* Non-admin warning */}
          {currentUser && (
            <div style={{
              marginBottom: '20px', padding: '14px 16px',
              background: '#fef2f2', border: '1px solid #fecaca',
              borderRadius: '12px', fontSize: '13px', color: '#dc2626', fontWeight: 500
            }}>
              <p>Signed in as <strong>{currentUser.email}</strong> — no admin role.</p>
              <button onClick={handleLogout} style={{
                marginTop: '6px', color: '#b91c1c', fontWeight: 600,
                textDecoration: 'underline', background: 'none', border: 'none', cursor: 'pointer', fontSize: '13px'
              }}>
                Sign out and try another account
              </button>
            </div>
          )}

          <form onSubmit={handleLogin} style={{ display: 'flex', flexDirection: 'column', gap: '22px' }}>
            {/* Error */}
            {error && (
              <div style={{
                padding: '13px 16px', background: '#fef2f2', border: '1px solid #fecaca',
                borderRadius: '12px', display: 'flex', alignItems: 'center', gap: '10px',
                fontSize: '13px', color: '#dc2626', fontWeight: 500
              }}>
                <AlertCircle size={16} style={{ flexShrink: 0 }} />
                {error}
              </div>
            )}

            {/* Email */}
            <div>
              <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, color: '#374151', marginBottom: '8px' }}>
                Email Address
              </label>
              <input
                type="email" required value={email}
                onChange={e => setEmail(e.target.value)}
                placeholder="admin@gohurghada.com"
                style={{
                  width: '100%', padding: '13px 16px', fontSize: '14px', fontWeight: 500,
                  border: '1.5px solid #e2e8f0', borderRadius: '12px', outline: 'none',
                  color: '#0f172a', background: '#f8fafc', boxSizing: 'border-box',
                  transition: 'border-color 0.2s, background 0.2s',
                }}
                onFocus={e => { e.target.style.borderColor = '#0061ff'; e.target.style.background = '#fff'; }}
                onBlur={e => { e.target.style.borderColor = '#e2e8f0'; e.target.style.background = '#f8fafc'; }}
              />
            </div>

            {/* Password */}
            <div>
              <label style={{ display: 'block', fontSize: '13px', fontWeight: 600, color: '#374151', marginBottom: '8px' }}>
                Password
              </label>
              <div style={{ position: 'relative' }}>
                <input
                  type={showPass ? 'text' : 'password'} required value={password}
                  onChange={e => setPassword(e.target.value)}
                  placeholder="••••••••"
                  style={{
                    width: '100%', padding: '13px 48px 13px 16px', fontSize: '14px', fontWeight: 500,
                    border: '1.5px solid #e2e8f0', borderRadius: '12px', outline: 'none',
                    color: '#0f172a', background: '#f8fafc', boxSizing: 'border-box',
                    transition: 'border-color 0.2s, background 0.2s',
                  }}
                  onFocus={e => { e.target.style.borderColor = '#0061ff'; e.target.style.background = '#fff'; }}
                  onBlur={e => { e.target.style.borderColor = '#e2e8f0'; e.target.style.background = '#f8fafc'; }}
                />
                <button type="button" onClick={() => setShowPass(!showPass)} style={{
                  position: 'absolute', right: '14px', top: '50%', transform: 'translateY(-50%)',
                  background: 'none', border: 'none', cursor: 'pointer', color: '#94a3b8', padding: '2px'
                }}>
                  {showPass ? <EyeOff size={18} /> : <Eye size={18} />}
                </button>
              </div>
            </div>

            {/* Submit Button */}
            <button
              type="submit" disabled={loading}
              style={{
                width: '100%', padding: '15px', borderRadius: '14px', border: 'none', cursor: loading ? 'not-allowed' : 'pointer',
                background: loading ? '#93c5fd' : 'linear-gradient(135deg, #0061ff, #0040cc)',
                color: 'white', fontSize: '15px', fontWeight: 700, letterSpacing: '0.2px',
                display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '10px',
                boxShadow: loading ? 'none' : '0 8px 24px rgba(0, 97, 255, 0.35)',
                transition: 'all 0.2s', marginTop: '4px',
              }}
              onMouseEnter={e => { if (!loading) e.target.style.transform = 'translateY(-1px)'; }}
              onMouseLeave={e => { e.target.style.transform = 'translateY(0)'; }}
            >
              {loading ? (
                <><Loader2 size={18} style={{ animation: 'spin 1s linear infinite' }} /> Authenticating...</>
              ) : (
                <><span>Sign in to Admin</span><ArrowRight size={18} /></>
              )}
            </button>
          </form>

          <p style={{ textAlign: 'center', fontSize: '12px', color: '#94a3b8', marginTop: '28px' }}>
            Admin access only · Go-Hurghada © 2026
          </p>
        </div>
      </div>
    </div>
  );
};

export default Login;
