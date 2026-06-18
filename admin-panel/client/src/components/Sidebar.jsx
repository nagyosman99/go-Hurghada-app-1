import React, { useState } from 'react';
import { NavLink, useNavigate } from 'react-router-dom';
import {
  LayoutDashboard, Hotel, Palmtree, PlaneTakeoff,
  CalendarClock, LogOut, ShieldCheck, Menu, X, CalendarSearch, Sparkles
} from 'lucide-react';
import { auth } from '../firebase';
import { motion, AnimatePresence } from 'framer-motion';

const navItems = [
  { name: 'Dashboard',    path: '/',            icon: LayoutDashboard },
  { name: 'Hotels',       path: '/hotels',       icon: Hotel },
  { name: 'Activities',   path: '/activities',   icon: Palmtree },
  { name: 'Flights',      path: '/flights',      icon: PlaneTakeoff },
  { name: 'Bookings',     path: '/bookings',     icon: CalendarClock },
  { name: 'Availability', path: '/availability', icon: CalendarSearch },
  { name: 'AI Assistant', path: '/ai',           icon: Sparkles },
];

const NavItems = ({ onClose }) => {
  const navigate = useNavigate();

  const handleLogout = async () => {
    await auth.signOut();
    navigate('/login');
  };

  return (
    <>
      <div className="p-5 border-b border-gray-100 flex items-center gap-3">
        <div className="w-9 h-9 bg-blue-600 rounded-xl flex items-center justify-center flex-shrink-0">
          <ShieldCheck className="text-white w-5 h-5" />
        </div>
        <div>
          <h1 className="font-bold text-gray-900 text-sm leading-tight">Go-Hurghada</h1>
          <p className="text-xs text-gray-400 font-medium">Admin Panel</p>
        </div>
      </div>

      <nav className="flex-1 p-4 space-y-1 overflow-y-auto">
        {navItems.map((item) => (
          <NavLink
            key={item.path}
            to={item.path}
            end={item.path === '/'}
            onClick={onClose}
            className={({ isActive }) =>
              `flex items-center gap-3 px-3.5 py-2.5 rounded-xl transition-all text-sm font-semibold ${
                isActive
                  ? 'bg-blue-600 text-white shadow-lg shadow-blue-500/20'
                  : 'text-gray-500 hover:bg-gray-50 hover:text-gray-900'
              }`
            }
          >
            <item.icon className="w-4.5 h-4.5 w-[18px] h-[18px] flex-shrink-0" />
            <span>{item.name}</span>
          </NavLink>
        ))}
      </nav>

      <div className="p-4 border-t border-gray-100">
        <button
          onClick={handleLogout}
          className="flex items-center gap-3 w-full px-3.5 py-2.5 text-red-500 hover:bg-red-50 rounded-xl transition-colors text-sm font-semibold"
        >
          <LogOut className="w-[18px] h-[18px] flex-shrink-0" />
          <span>Logout</span>
        </button>
      </div>
    </>
  );
};

const Sidebar = () => {
  const [mobileOpen, setMobileOpen] = useState(false);

  return (
    <>
      {/* Desktop Sidebar */}
      <aside className="hidden lg:flex w-60 bg-white border-r border-gray-100 flex-col flex-shrink-0">
        <NavItems onClose={() => {}} />
      </aside>

      {/* Mobile Top Bar */}
      <div className="lg:hidden fixed top-0 left-0 right-0 z-40 bg-white border-b border-gray-100 flex items-center justify-between px-4 py-3">
        <div className="flex items-center gap-2.5">
          <div className="w-7 h-7 bg-blue-600 rounded-lg flex items-center justify-center">
            <ShieldCheck className="text-white w-4 h-4" />
          </div>
          <span className="font-bold text-gray-900 text-sm">Go-Hurghada Admin</span>
        </div>
        <button
          onClick={() => setMobileOpen(true)}
          className="p-2 rounded-xl hover:bg-gray-100 transition-colors"
        >
          <Menu className="w-5 h-5 text-gray-600" />
        </button>
      </div>

      {/* Mobile Drawer */}
      <AnimatePresence>
        {mobileOpen && (
          <>
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setMobileOpen(false)}
              className="lg:hidden fixed inset-0 z-50 bg-black/40 backdrop-blur-sm"
            />
            <motion.aside
              initial={{ x: -280 }}
              animate={{ x: 0 }}
              exit={{ x: -280 }}
              transition={{ type: 'spring', damping: 25, stiffness: 300 }}
              className="lg:hidden fixed top-0 left-0 bottom-0 z-50 w-64 bg-white flex flex-col shadow-xl"
            >
              <button
                onClick={() => setMobileOpen(false)}
                className="absolute top-4 right-4 p-1.5 hover:bg-gray-100 rounded-full transition-colors"
              >
                <X className="w-4 h-4 text-gray-500" />
              </button>
              <NavItems onClose={() => setMobileOpen(false)} />
            </motion.aside>
          </>
        )}
      </AnimatePresence>
    </>
  );
};

export default Sidebar;
