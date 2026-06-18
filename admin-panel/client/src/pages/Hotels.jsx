import React, { useState, useEffect, useCallback } from 'react';
import api from '../api';
import {
  Plus, Edit2, Trash2, Search, ChevronRight, Loader2, X,
  CheckCircle2, Star, DollarSign, ImageIcon, Home, Layers
} from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

const AMENITY_OPTIONS = [
  'WiFi', 'Pool', 'Beach Access', 'Spa', 'Gym', 'Restaurant', 'Bar',
  'Room Service', 'Airport Shuttle', 'Parking', 'Air Conditioning',
  'Mini Bar', 'Jacuzzi', 'Tennis Court', 'Sauna', 'Sea View',
];

const LOCATIONS = [
  'El Gouna',
  'Makadi Bay',
  'Soma Bay',
  'Sahl Hasheesh',
  'Hurghada',
];

const emptyForm = {
  name: '', address: '', description: '',
  pricePerNight: '', rating: '', imageUrl: '',
  photos: [''], amenities: [], isAllInclusive: false, discount: '',
};

const emptyRoom = {
  name: '', type: '', bedConfiguration: '', price: '',
  capacity: 2, size: '', view: '', originalPrice: '',
  amenities: [], photos: [''],
  totalCount: 1,
};

const ImageUrlField = ({ urls, onChange, label = 'Image URLs' }) => {
  const addUrl = () => onChange([...urls, '']);
  const removeUrl = (i) => onChange(urls.filter((_, idx) => idx !== i));
  const update = (i, val) => onChange(urls.map((u, idx) => idx === i ? val : u));

  return (
    <div>
      <label className="block text-sm font-semibold text-gray-700 mb-2">{label}</label>
      <div className="space-y-3">
        {urls.map((url, i) => (
          <div key={i} className="flex gap-2 items-start">
            <div className="flex-1 space-y-1">
              <div className="flex gap-2">
                <input
                  value={url}
                  onChange={e => update(i, e.target.value)}
                  placeholder="https://..."
                  className="flex-1 px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all font-mono"
                />
                {urls.length > 1 && (
                  <button type="button" onClick={() => removeUrl(i)}
                    className="p-2.5 text-gray-400 hover:text-red-500 hover:bg-red-50 rounded-xl transition-all flex-shrink-0">
                    <X className="w-4 h-4" />
                  </button>
                )}
              </div>
              {url && (
                <img src={url} alt="preview"
                  className="w-full h-28 object-cover rounded-xl bg-gray-100 border border-gray-100"
                  onError={e => { e.target.style.display = 'none'; }}
                  onLoad={e => { e.target.style.display = 'block'; }}
                />
              )}
            </div>
          </div>
        ))}
        <button type="button" onClick={addUrl}
          className="flex items-center gap-2 text-sm text-blue-600 hover:text-blue-700 font-semibold">
          <Plus className="w-4 h-4" /> Add another image
        </button>
      </div>
    </div>
  );
};

const Hotels = () => {
  const [hotels, setHotels] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [activeTab, setActiveTab] = useState('info');
  const [currentHotel, setCurrentHotel] = useState(null);
  const [formData, setFormData] = useState(emptyForm);
  const [rooms, setRooms] = useState([]);
  const [isRoomModalOpen, setIsRoomModalOpen] = useState(false);
  const [currentRoom, setCurrentRoom] = useState(null);
  const [roomForm, setRoomForm] = useState(emptyRoom);
  const [saving, setSaving] = useState(false);

  useEffect(() => { fetchHotels(); }, []);

  const fetchHotels = async () => {
    setLoading(true);
    try {
      const res = await api.get('/hotels');
      setHotels(res.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const fetchRooms = async (hotelId) => {
    try {
      const res = await api.get(`/hotels/${hotelId}/rooms`);
      setRooms(res.data);
    } catch { setRooms([]); }
  };

  const handleOpenModal = (hotel = null) => {
    setActiveTab('info');
    if (hotel) {
      setCurrentHotel(hotel);
      setFormData({
        name: hotel.name || '',
        address: hotel.address || '',
        description: hotel.description || '',
        pricePerNight: hotel.pricePerNight || '',
        rating: hotel.rating || '',
        imageUrl: hotel.imageUrl || '',
        photos: hotel.photos?.length ? hotel.photos : [''],
        amenities: hotel.amenities || [],
        isAllInclusive: hotel.isAllInclusive || false,
        discount: hotel.discount || '',
      });
      fetchRooms(hotel.id);
    } else {
      setCurrentHotel(null);
      setFormData(emptyForm);
      setRooms([]);
    }
    setIsModalOpen(true);
  };

  const toggleAmenity = (amenity) => {
    setFormData(prev => ({
      ...prev,
      amenities: prev.amenities.includes(amenity)
        ? prev.amenities.filter(a => a !== amenity)
        : [...prev.amenities, amenity]
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setSaving(true);
    const payload = {
      ...formData,
      pricePerNight: parseFloat(formData.pricePerNight) || 0,
      rating: parseFloat(formData.rating) || 0,
      discount: formData.discount.toString(),
      photos: formData.photos.filter(Boolean),
    };
    try {
      if (currentHotel) {
        await api.put(`/hotels/${currentHotel.id}`, payload);
      } else {
        await api.post('/hotels', payload);
      }
      await fetchHotels();
      setIsModalOpen(false);
    } catch (err) {
      console.error(err);
      alert(`Error: ${err.response?.data?.error || 'Could not save. Check server and your admin role.'}`);
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Delete this hotel?')) return;
    try {
      await api.delete(`/hotels/${id}`);
      setHotels(prev => prev.filter(h => h.id !== id));
    } catch (err) {
      alert(`Error: ${err.response?.data?.error || 'Could not delete.'}`);
    }
  };

  // Room handlers
  const handleOpenRoomModal = (room = null) => {
    if (room) {
      setCurrentRoom(room);
      setRoomForm({
        name: room.name || '', type: room.type || '',
        bedConfiguration: room.bedConfiguration || '',
        price: room.price || '', capacity: room.capacity || 2,
        size: room.size || '', view: room.view || '',
        originalPrice: room.originalPrice || '',
        amenities: room.amenities || [],
        photos: room.photos?.length ? room.photos : [''],
        totalCount: room.totalCount || 1,
      });
    } else {
      setCurrentRoom(null);
      setRoomForm(emptyRoom);
    }
    setIsRoomModalOpen(true);
  };

  const handleRoomSubmit = async (e) => {
    e.preventDefault();
    setSaving(true);
    const payload = {
      ...roomForm,
      price: parseFloat(roomForm.price) || 0,
      capacity: parseInt(roomForm.capacity) || 2,
      size: parseFloat(roomForm.size) || 0,
      originalPrice: roomForm.originalPrice ? parseFloat(roomForm.originalPrice) : null,
      photos: roomForm.photos.filter(Boolean),
      totalCount: parseInt(roomForm.totalCount) || 1,
    };
    try {
      if (currentRoom) {
        await api.put(`/hotels/${currentHotel.id}/rooms/${currentRoom.id}`, payload);
      } else {
        await api.post(`/hotels/${currentHotel.id}/rooms`, payload);
      }
      await fetchRooms(currentHotel.id);
      setIsRoomModalOpen(false);
    } catch (err) {
      alert(`Error: ${err.response?.data?.error || 'Could not save room.'}`);
    } finally {
      setSaving(false);
    }
  };

  const handleDeleteRoom = async (roomId) => {
    if (!window.confirm('Delete this room?')) return;
    try {
      await api.delete(`/hotels/${currentHotel.id}/rooms/${roomId}`);
      setRooms(prev => prev.filter(r => r.id !== roomId));
    } catch (err) {
      alert('Error deleting room.');
    }
  };

  // Unique addresses for dropdown
  const addresses = [...new Set(hotels.map(h => h.address).filter(Boolean))];

  const filtered = hotels.filter(h =>
    h.name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    h.address?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl sm:text-3xl font-bold text-gray-900">Manage Hotels</h1>
          <p className="text-gray-500 mt-1 text-sm font-medium">{hotels.length} hotels in total</p>
        </div>
        <button onClick={() => handleOpenModal()}
          className="inline-flex items-center gap-2 bg-blue-600 text-white px-5 py-2.5 rounded-xl font-semibold hover:bg-blue-700 transition-all shadow-lg shadow-blue-500/20 text-sm">
          <Plus className="w-4 h-4" /> Add Hotel
        </button>
      </div>

      <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
        <div className="p-4 border-b border-gray-100">
          <div className="relative max-w-sm">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-4 h-4" />
            <input type="text" placeholder="Search hotels..." value={searchTerm}
              onChange={e => setSearchTerm(e.target.value)}
              className="w-full pl-9 pr-4 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all" />
          </div>
        </div>
        <div className="overflow-x-auto">
          {loading ? (
            <div className="flex items-center justify-center py-20 gap-3">
              <Loader2 className="w-8 h-8 text-blue-600 animate-spin" />
              <span className="text-gray-500 text-sm">Loading...</span>
            </div>
          ) : filtered.length === 0 ? (
            <div className="text-center py-20 text-gray-400 text-sm">No hotels found.</div>
          ) : (
            <table className="w-full text-sm">
              <thead className="bg-gray-50 text-gray-500 text-xs uppercase tracking-wide font-semibold">
                <tr>
                  <th className="px-6 py-3 text-left">Hotel</th>
                  <th className="px-6 py-3 text-left hidden md:table-cell">Location</th>
                  <th className="px-6 py-3 text-left hidden lg:table-cell">Price/Night</th>
                  <th className="px-6 py-3 text-left hidden lg:table-cell">Rating</th>
                  <th className="px-6 py-3 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {filtered.map(hotel => (
                  <tr key={hotel.id} className="hover:bg-gray-50/50 transition-colors">
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-3">
                        <img src={hotel.imageUrl} alt={hotel.name}
                          className="w-10 h-10 rounded-lg object-cover bg-gray-100 flex-shrink-0"
                          onError={e => { e.target.src = 'https://placehold.co/100?text=N/A'; }} />
                        <div className="min-w-0">
                          <p className="font-semibold text-gray-900 truncate">{hotel.name}</p>
                          <div className="flex gap-1 mt-0.5">
                            {hotel.isAllInclusive && <span className="text-[10px] bg-green-100 text-green-700 px-1.5 py-0.5 rounded-full font-bold uppercase">All Inclusive</span>}
                            {hotel.discount && <span className="text-[10px] bg-red-100 text-red-700 px-1.5 py-0.5 rounded-full font-bold">-{hotel.discount}%</span>}
                          </div>
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4 hidden md:table-cell text-gray-500 truncate max-w-[180px]">{hotel.address}</td>
                    <td className="px-6 py-4 hidden lg:table-cell font-bold text-gray-900">${hotel.pricePerNight}</td>
                    <td className="px-6 py-4 hidden lg:table-cell">
                      <span className="flex items-center gap-1 text-yellow-600 font-bold text-xs">
                        <Star className="w-3.5 h-3.5 fill-yellow-400 text-yellow-400" />{hotel.rating}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <div className="flex items-center justify-end gap-1">
                        <button onClick={() => handleOpenModal(hotel)} className="p-2 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-all"><Edit2 className="w-4 h-4" /></button>
                        <button onClick={() => handleDelete(hotel.id)} className="p-2 text-gray-400 hover:text-red-500 hover:bg-red-50 rounded-lg transition-all"><Trash2 className="w-4 h-4" /></button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>

      {/* Main Hotel Modal */}
      <AnimatePresence>
        {isModalOpen && (
          <div className="fixed inset-0 z-50 flex items-start justify-center p-4 overflow-y-auto">
            <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
              onClick={() => setIsModalOpen(false)} className="fixed inset-0 bg-black/50 backdrop-blur-sm" />
            <motion.div initial={{ opacity: 0, scale: 0.95, y: 20 }} animate={{ opacity: 1, scale: 1, y: 0 }} exit={{ opacity: 0, scale: 0.95, y: 20 }}
              className="relative bg-white w-full max-w-3xl rounded-2xl shadow-2xl my-8 overflow-hidden">
              <div className="sticky top-0 z-10 flex items-center justify-between px-6 py-4 bg-blue-600 text-white">
                <h2 className="font-bold text-lg">{currentHotel ? 'Edit Hotel' : 'Add New Hotel'}</h2>
                <button onClick={() => setIsModalOpen(false)} className="p-1.5 hover:bg-white/20 rounded-full transition-colors"><X className="w-5 h-5" /></button>
              </div>

              {/* Tabs — always visible; Rooms tab disabled in Add mode */}
              <div className="flex border-b border-gray-100 bg-gray-50/50">
                <button onClick={() => setActiveTab('info')}
                  className={`flex-1 py-3 text-sm font-semibold transition-all ${activeTab === 'info' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-500 hover:text-gray-700'}`}>
                  <Home className="w-4 h-4 inline mr-1.5" />Info
                </button>
                <button
                  onClick={() => currentHotel && setActiveTab('rooms')}
                  title={!currentHotel ? 'Save the hotel first to manage rooms' : ''}
                  className={`flex-1 py-3 text-sm font-semibold transition-all ${activeTab === 'rooms' ? 'text-blue-600 border-b-2 border-blue-600'
                      : !currentHotel ? 'text-gray-300 cursor-not-allowed'
                        : 'text-gray-500 hover:text-gray-700'
                    }`}>
                  <Layers className="w-4 h-4 inline mr-1.5" />
                  Rooms {currentHotel ? `(${rooms.length})` : '(save first)'}
                </button>
              </div>

              {activeTab === 'info' ? (
                <form onSubmit={handleSubmit} className="p-6 space-y-6">
                  <section>
                    <h3 className="text-xs uppercase tracking-wider text-gray-400 font-bold mb-4">Basic Information</h3>
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                      <div className="sm:col-span-2">
                        <label className="block text-sm font-semibold text-gray-700 mb-1.5">Hotel Name *</label>
                        <input required value={formData.name} onChange={e => setFormData({ ...formData, name: e.target.value })}
                          className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all" placeholder="e.g. Hurghada Marriott" />
                      </div>
                      <div className="sm:col-span-2">
                        <label className="block text-sm font-semibold text-gray-700 mb-1.5">Location *</label>
                        <select required value={formData.address} onChange={e => setFormData({ ...formData, address: e.target.value })}
                          className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all bg-white">
                          <option value="" disabled>Select a location...</option>
                          {LOCATIONS.map(loc => <option key={loc} value={loc}>{loc}</option>)}
                        </select>
                      </div>
                      <div className="sm:col-span-2">
                        <label className="block text-sm font-semibold text-gray-700 mb-1.5">Description</label>
                        <textarea value={formData.description} onChange={e => setFormData({ ...formData, description: e.target.value })} rows={3}
                          className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all resize-none" placeholder="Describe the hotel..." />
                      </div>
                    </div>
                  </section>

                  <section>
                    <h3 className="text-xs uppercase tracking-wider text-gray-400 font-bold mb-4">Pricing & Rating</h3>
                    <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1.5">Price/Night ($) *</label>
                        <div className="relative">
                          <DollarSign className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                          <input required type="number" min="0" step="0.01" value={formData.pricePerNight} onChange={e => setFormData({ ...formData, pricePerNight: e.target.value })}
                            className="w-full pl-9 pr-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all" placeholder="150" />
                        </div>
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1.5">Rating (0–5)</label>
                        <div className="relative">
                          <Star className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                          <input type="number" min="0" max="5" step="0.1" value={formData.rating} onChange={e => setFormData({ ...formData, rating: e.target.value })}
                            className="w-full pl-9 pr-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all" placeholder="4.5" />
                        </div>
                      </div>
                      <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1.5">Discount (%)</label>
                        <input type="number" min="0" max="100" value={formData.discount} onChange={e => setFormData({ ...formData, discount: e.target.value })}
                          className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all" placeholder="e.g. 20" />
                      </div>
                    </div>
                  </section>

                  <section>
                    <h3 className="text-xs uppercase tracking-wider text-gray-400 font-bold mb-4">Main Image *</h3>
                    <div>
                      <input required value={formData.imageUrl} onChange={e => setFormData({ ...formData, imageUrl: e.target.value })}
                        className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all font-mono" placeholder="https://..." />
                      {formData.imageUrl && (
                        <img src={formData.imageUrl} alt="preview" className="mt-2 w-full h-32 object-cover rounded-xl bg-gray-100"
                          onError={e => { e.target.style.display = 'none'; }} onLoad={e => { e.target.style.display = 'block'; }} />
                      )}
                    </div>
                  </section>

                  <section>
                    <h3 className="text-xs uppercase tracking-wider text-gray-400 font-bold mb-4">Gallery Photos</h3>
                    <ImageUrlField urls={formData.photos} onChange={v => setFormData({ ...formData, photos: v })} label="" />
                  </section>

                  <section>
                    <h3 className="text-xs uppercase tracking-wider text-gray-400 font-bold mb-3">Amenities</h3>
                    <div className="flex flex-wrap gap-2">
                      {AMENITY_OPTIONS.map(a => (
                        <button type="button" key={a} onClick={() => toggleAmenity(a)}
                          className={`px-3 py-1.5 rounded-full text-xs font-semibold border transition-all ${formData.amenities.includes(a)
                              ? 'bg-blue-600 text-white border-blue-600 shadow-sm scale-105'
                              : 'bg-white text-gray-600 border-gray-200 hover:border-blue-400'
                            }`}>
                          {a}
                        </button>
                      ))}
                    </div>
                  </section>

                  <section>
                    <label className="flex items-center gap-3 cursor-pointer select-none w-fit">
                      <div onClick={() => setFormData({ ...formData, isAllInclusive: !formData.isAllInclusive })}
                        className={`relative w-10 h-6 rounded-full transition-all ${formData.isAllInclusive ? 'bg-blue-600' : 'bg-gray-200'}`}>
                        <div className={`absolute top-1 w-4 h-4 bg-white rounded-full shadow transition-all ${formData.isAllInclusive ? 'left-5' : 'left-1'}`} />
                      </div>
                      <span className="text-sm font-semibold text-gray-700">All Inclusive Package Available</span>
                    </label>
                  </section>

                  <div className="pt-2 border-t border-gray-100">
                    <button type="submit" disabled={saving}
                      className="w-full bg-blue-600 text-white py-3 rounded-xl font-bold text-sm hover:bg-blue-700 transition-all disabled:opacity-60 flex items-center justify-center gap-2 shadow-lg shadow-blue-500/20">
                      {saving ? <Loader2 className="w-4 h-4 animate-spin" /> : <CheckCircle2 className="w-4 h-4" />}
                      {saving ? 'Saving...' : (currentHotel ? 'Update Hotel' : 'Create Hotel')}
                    </button>
                  </div>
                </form>
              ) : (
                /* Rooms Tab */
                <div className="p-6 space-y-4">
                  <div className="flex items-center justify-between">
                    <h3 className="font-bold text-gray-900">Rooms for {currentHotel?.name}</h3>
                    <button onClick={() => handleOpenRoomModal()}
                      className="inline-flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-xl font-semibold text-sm hover:bg-blue-700 transition-all">
                      <Plus className="w-4 h-4" /> Add Room
                    </button>
                  </div>
                  {rooms.length === 0 ? (
                    <div className="text-center py-12 text-gray-400 text-sm">No rooms added yet.</div>
                  ) : (
                    <div className="space-y-3">
                      {rooms.map(room => (
                        <div key={room.id} className="flex items-center justify-between p-4 bg-gray-50 rounded-xl border border-gray-100">
                          <div className="flex items-center gap-3">
                            {room.photos?.[0] && (
                              <img src={room.photos[0]} alt={room.name}
                                className="w-12 h-12 rounded-lg object-cover bg-gray-200 flex-shrink-0"
                                onError={e => { e.target.style.display = 'none'; }} />
                            )}
                            <div>
                              <p className="font-bold text-gray-900 text-sm">{room.name}</p>
                              <p className="text-xs text-gray-500">{room.type} · {room.bedConfiguration} · ${room.price}/night</p>
                              <p className="text-xs text-blue-600 mt-0.5">Capacity: {room.capacity} · {room.view}</p>
                              <p className="text-xs text-emerald-600 font-semibold mt-0.5">
                                {room.totalCount != null ? `${room.totalCount} unit${room.totalCount !== 1 ? 's' : ''} total` : <span className="text-amber-500">⚠ totalCount missing</span>}
                              </p>
                            </div>
                          </div>
                          <div className="flex gap-1 flex-shrink-0">
                            <button onClick={() => handleOpenRoomModal(room)} className="p-2 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-all"><Edit2 className="w-4 h-4" /></button>
                            <button onClick={() => handleDeleteRoom(room.id)} className="p-2 text-gray-400 hover:text-red-500 hover:bg-red-50 rounded-lg transition-all"><Trash2 className="w-4 h-4" /></button>
                          </div>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              )}
            </motion.div>
          </div>
        )}
      </AnimatePresence>

      {/* Room Modal */}
      <AnimatePresence>
        {isRoomModalOpen && (
          <div className="fixed inset-0 z-[60] flex items-start justify-center p-4 overflow-y-auto">
            <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
              onClick={() => setIsRoomModalOpen(false)} className="fixed inset-0 bg-black/60 backdrop-blur-sm" />
            <motion.div initial={{ opacity: 0, scale: 0.95, y: 20 }} animate={{ opacity: 1, scale: 1, y: 0 }} exit={{ opacity: 0, scale: 0.95, y: 20 }}
              className="relative bg-white w-full max-w-2xl rounded-2xl shadow-2xl my-8 overflow-hidden">
              <div className="sticky top-0 z-10 flex items-center justify-between px-6 py-4 bg-gray-900 text-white">
                <h2 className="font-bold text-lg">{currentRoom ? 'Edit Room' : 'Add New Room'}</h2>
                <button onClick={() => setIsRoomModalOpen(false)} className="p-1.5 hover:bg-white/20 rounded-full transition-colors"><X className="w-5 h-5" /></button>
              </div>
              <form onSubmit={handleRoomSubmit} className="p-6 space-y-5">
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  {[
                    { label: 'Room Name *', field: 'name', required: true, placeholder: 'e.g. Deluxe Sea View' },
                    { label: 'Room Type *', field: 'type', required: true, placeholder: 'e.g. Double, Suite, Villa' },
                    { label: 'Bed Configuration', field: 'bedConfiguration', placeholder: 'e.g. 1 King Bed' },
                    { label: 'View', field: 'view', placeholder: 'e.g. Sea View, Pool View' },
                  ].map(({ label, field, required, placeholder }) => (
                    <div key={field}>
                      <label className="block text-sm font-semibold text-gray-700 mb-1.5">{label}</label>
                      <input required={required} value={roomForm[field]} onChange={e => setRoomForm({ ...roomForm, [field]: e.target.value })}
                        placeholder={placeholder}
                        className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all" />
                    </div>
                  ))}
                  {[
                    { label: 'Price/Night ($) *', field: 'price', required: true, placeholder: '200' },
                    { label: 'Original Price ($)', field: 'originalPrice', placeholder: '250 (before discount)' },
                    { label: 'Capacity (guests)', field: 'capacity', placeholder: '2' },
                    { label: 'Size (m²)', field: 'size', placeholder: '35' },
                  ].map(({ label, field, required, placeholder }) => (
                    <div key={field}>
                      <label className="block text-sm font-semibold text-gray-700 mb-1.5">{label}</label>
                      <input type="number" required={required} min="0" value={roomForm[field]} onChange={e => setRoomForm({ ...roomForm, [field]: e.target.value })}
                        placeholder={placeholder}
                        className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all" />
                    </div>
                  ))}
                  {/* ── totalCount (new) ── */}
                  <div className="sm:col-span-2">
                    <label className="block text-sm font-semibold text-gray-700 mb-1.5">
                      Total Physical Rooms of This Type *
                      <span className="ml-2 text-xs font-normal text-gray-400">(used for availability tracking)</span>
                    </label>
                    <input
                      type="number"
                      required
                      min="1"
                      step="1"
                      value={roomForm.totalCount}
                      onChange={e => setRoomForm({ ...roomForm, totalCount: e.target.value })}
                      placeholder="e.g. 10"
                      className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-emerald-300 bg-emerald-50 focus:outline-none focus:ring-2 focus:ring-emerald-500/20 focus:border-emerald-500 transition-all font-semibold"
                    />
                    <p className="mt-1 text-xs text-emerald-600">How many physical rooms of this type exist in the hotel?</p>
                  </div>
                </div>

                <div>
                  <h4 className="text-xs uppercase tracking-wider text-gray-400 font-bold mb-3">Room Amenities</h4>
                  <div className="flex flex-wrap gap-2">
                    {AMENITY_OPTIONS.map(a => (
                      <button type="button" key={a}
                        onClick={() => setRoomForm(f => ({ ...f, amenities: f.amenities.includes(a) ? f.amenities.filter(x => x !== a) : [...f.amenities, a] }))}
                        className={`px-3 py-1.5 rounded-full text-xs font-semibold border transition-all ${roomForm.amenities.includes(a)
                            ? 'bg-gray-900 text-white border-gray-900 scale-105'
                            : 'bg-white text-gray-600 border-gray-200 hover:border-gray-400'
                          }`}>
                        {a}
                      </button>
                    ))}
                  </div>
                </div>

                <div>
                  <h4 className="text-xs uppercase tracking-wider text-gray-400 font-bold mb-3">Room Photos</h4>
                  <ImageUrlField urls={roomForm.photos} onChange={v => setRoomForm({ ...roomForm, photos: v })} label="" />
                </div>

                <div className="pt-2 border-t border-gray-100">
                  <button type="submit" disabled={saving}
                    className="w-full bg-gray-900 text-white py-3 rounded-xl font-bold text-sm hover:bg-gray-800 transition-all disabled:opacity-60 flex items-center justify-center gap-2">
                    {saving ? <Loader2 className="w-4 h-4 animate-spin" /> : <CheckCircle2 className="w-4 h-4" />}
                    {saving ? 'Saving...' : (currentRoom ? 'Update Room' : 'Add Room')}
                  </button>
                </div>
              </form>
            </motion.div>
          </div>
        )}
      </AnimatePresence>
    </div>
  );
};

export default Hotels;
