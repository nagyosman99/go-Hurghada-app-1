import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { onAuthStateChanged } from 'firebase/auth';
import { doc, getDoc } from 'firebase/firestore';
import { auth, db } from './firebase';

import Layout from './components/Layout';
import Dashboard from './pages/Dashboard';
import Hotels from './pages/Hotels';
import Activities from './pages/Activities';
import Bookings from './pages/Bookings';
import Availability from './pages/Availability';
import Login from './pages/Login';
import AiAssistant from './pages/AiAssistant';

function App() {
  const [user, setUser] = useState(null);
  const [isAdmin, setIsAdmin] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, async (user) => {
      if (user) {
        setUser(user);
        const userDoc = await getDoc(doc(db, 'users', user.uid));
        setIsAdmin(userDoc.exists() && userDoc.data().role === 'admin');
      } else {
        setUser(null);
        setIsAdmin(false);
      }
      setLoading(false);
    });

    return () => unsubscribe();
  }, []);

  if (loading) return <div className="flex items-center justify-center h-screen font-bold">Loading...</div>;

  return (
    <Router>
      <Routes>
        {/* Only redirect to dashboard if user IS admin. Otherwise show Login. */}
        <Route path="/login" element={!(user && isAdmin) ? <Login /> : <Navigate to="/" />} />
        
        {/* Protected routes: Must be logged in AND be admin */}
        <Route element={(user && isAdmin) ? <Layout /> : <Navigate to="/login" />}>
          <Route path="/" element={<Dashboard />} />
          <Route path="/hotels" element={<Hotels />} />
          <Route path="/activities" element={<Activities />} />
          <Route path="/bookings" element={<Bookings />} />
          <Route path="/availability" element={<Availability />} />
          <Route path="/flights" element={<div>Flights Management</div>} />
          <Route path="/ai" element={<AiAssistant />} />
        </Route>

        {/* Fallback for any other route */}
        <Route path="*" element={<Navigate to="/" />} />
      </Routes>
    </Router>
  );
}

export default App;
