import React, { useState, useEffect } from 'react';
import api from '../api';
import {
  Plus, Edit2, Trash2, Search, Loader2, X,
  CheckCircle2, Star, DollarSign, Clock, MapPin
} from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

const CATEGORIES = ['Water Sports', 'Safari', 'Boat Trips', 'Family', 'Luxury', 'City Tour', 'Cultural', 'Adventure'];
const LANGUAGES = ['English', 'Arabic', 'German', 'French', 'Italian', 'Russian', 'Spanish'];
const LOCATIONS = ['El Gouna', 'Makadi Bay', 'Soma Bay', 'Sahl Hasheesh', 'Hurghada'];

const emptyForm = {
  title: '', description: '', fullDescription: '',
  price: '', rating: '', location: '', duration: '',
  category: 'Water Sports', ageRequirement: '',
  images: [''],
  languages: [],
  pickupIncluded: false, instantConfirmation: false, freeCancellation: false,
  whatsIncluded: [''],
  whatsNotIncluded: [''],
  pickupInfo_location: '', pickupInfo_time: '',
  discount: '',
};

const DynamicList = ({ items, onChange, placeholder, label }) => {
  const add = () => onChange([...items, '']);
  const remove = i => onChange(items.filter((_, idx) => idx !== i));
  const update = (i, v) => onChange(items.map((x, idx) => idx === i ? v : x));
  return (
    <div>
      {label && <label className="block text-sm font-semibold text-gray-700 mb-2">{label}</label>}
      <div className="space-y-2">
        {items.map((item, i) => (
          <div key={i} className="flex gap-2">
            <input value={item} onChange={e => update(i, e.target.value)} placeholder={placeholder}
              className="flex-1 px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all" />
            {items.length > 1 && (
              <button type="button" onClick={() => remove(i)} className="p-2.5 text-gray-400 hover:text-red-500 hover:bg-red-50 rounded-xl transition-all flex-shrink-0">
                <X className="w-4 h-4" />
              </button>
            )}
          </div>
        ))}
        <button type="button" onClick={add} className="flex items-center gap-1.5 text-xs text-blue-600 hover:text-blue-700 font-semibold mt-1">
          <Plus className="w-3.5 h-3.5" /> Add item
        </button>
      </div>
    </div>
  );
};

const ImageField = ({ images, onChange }) => {
  const add = () => onChange([...images, '']);
  const remove = i => onChange(images.filter((_, idx) => idx !== i));
  const update = (i, v) => onChange(images.map((x, idx) => idx === i ? v : x));
  return (
    <div className="space-y-3">
      {images.map((url, i) => (
        <div key={i}>
          <div className="flex gap-2">
            <input value={url} onChange={e => update(i, e.target.value)} placeholder="https://..."
              className="flex-1 px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all font-mono" />
            {images.length > 1 && (
              <button type="button" onClick={() => remove(i)} className="p-2.5 text-gray-400 hover:text-red-500 hover:bg-red-50 rounded-xl transition-all flex-shrink-0">
                <X className="w-4 h-4" />
              </button>
            )}
          </div>
          {url && (
            <img src={url} alt={`preview ${i+1}`} className="mt-1.5 w-full h-28 object-cover rounded-xl bg-gray-100 border border-gray-100"
              onError={e => { e.target.style.display='none'; }} onLoad={e => { e.target.style.display='block'; }} />
          )}
        </div>
      ))}
      <button type="button" onClick={add} className="flex items-center gap-1.5 text-xs text-blue-600 hover:text-blue-700 font-semibold">
        <Plus className="w-3.5 h-3.5" /> Add another image
      </button>
    </div>
  );
};

const Activities = () => {
  const [activities, setActivities] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [current, setCurrent] = useState(null);
  const [formData, setFormData] = useState(emptyForm);
  const [saving, setSaving] = useState(false);

  useEffect(() => { fetchActivities(); }, []);

  const fetchActivities = async () => {
    setLoading(true);
    try {
      const res = await api.get('/activities');
      setActivities(res.data);
    } catch (err) { console.error(err); }
    finally { setLoading(false); }
  };

  const handleOpenModal = (item = null) => {
    if (item) {
      setCurrent(item);
      setFormData({
        title: item.title || '',
        description: item.description || '',
        fullDescription: item.fullDescription || '',
        price: item.price || '',
        rating: item.rating || '',
        location: item.location || '',
        duration: item.duration || '',
        category: item.category || 'Water Sports',
        ageRequirement: item.ageRequirement || '',
        images: item.images?.length ? item.images : [''],
        languages: item.languages || [],
        pickupIncluded: item.pickupIncluded || false,
        instantConfirmation: item.instantConfirmation || false,
        freeCancellation: item.freeCancellation || false,
        whatsIncluded: item.whatsIncluded?.length ? item.whatsIncluded : [''],
        whatsNotIncluded: item.whatsNotIncluded?.length ? item.whatsNotIncluded : [''],
        pickupInfo_location: item.pickupInfo?.location || '',
        pickupInfo_time: item.pickupInfo?.time || '',
        discount: item.discount || '',
      });
    } else {
      setCurrent(null);
      setFormData(emptyForm);
    }
    setIsModalOpen(true);
  };

  const toggleLang = lang => setFormData(f => ({
    ...f, languages: f.languages.includes(lang)
      ? f.languages.filter(l => l !== lang) : [...f.languages, lang]
  }));

  const handleSubmit = async (e) => {
    e.preventDefault();
    setSaving(true);
    const payload = {
      title: formData.title,
      description: formData.description,
      fullDescription: formData.fullDescription,
      price: parseFloat(formData.price) || 0,
      rating: parseFloat(formData.rating) || 0,
      location: formData.location,
      duration: formData.duration,
      category: formData.category,
      ageRequirement: formData.ageRequirement,
      images: formData.images.filter(Boolean),
      languages: formData.languages,
      pickupIncluded: formData.pickupIncluded,
      instantConfirmation: formData.instantConfirmation,
      freeCancellation: formData.freeCancellation,
      whatsIncluded: formData.whatsIncluded.filter(Boolean),
      whatsNotIncluded: formData.whatsNotIncluded.filter(Boolean),
      pickupInfo: formData.pickupInfo_location ? {
        location: formData.pickupInfo_location,
        time: formData.pickupInfo_time,
      } : null,
      discount: formData.discount.toString(),
    };
    try {
      if (current) {
        await api.put(`/activities/${current.id}`, payload);
      } else {
        await api.post('/activities', payload);
      }
      await fetchActivities();
      setIsModalOpen(false);
    } catch (err) {
      alert(`Error: ${err.response?.data?.error || 'Could not save. Check server and your admin role.'}`);
    } finally { setSaving(false); }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Delete this activity?')) return;
    try {
      await api.delete(`/activities/${id}`);
      setActivities(prev => prev.filter(a => a.id !== id));
    } catch (err) { alert('Error deleting.'); }
  };

  const filtered = activities.filter(a =>
    a.title?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    a.location?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const BoolToggle = ({ label, field }) => (
    <label className="flex items-center gap-3 cursor-pointer select-none w-fit">
      <div onClick={() => setFormData(f => ({...f, [field]: !f[field]}))}
        className={`relative w-10 h-6 rounded-full transition-all flex-shrink-0 ${formData[field] ? 'bg-blue-600' : 'bg-gray-200'}`}>
        <div className={`absolute top-1 w-4 h-4 bg-white rounded-full shadow transition-all ${formData[field] ? 'left-5' : 'left-1'}`} />
      </div>
      <span className="text-sm font-semibold text-gray-700">{label}</span>
    </label>
  );

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl sm:text-3xl font-bold text-gray-900">Manage Activities</h1>
          <p className="text-gray-500 mt-1 text-sm">{activities.length} activities total</p>
        </div>
        <button onClick={() => handleOpenModal()}
          className="inline-flex items-center gap-2 bg-blue-600 text-white px-5 py-2.5 rounded-xl font-semibold hover:bg-blue-700 transition-all shadow-lg shadow-blue-500/20 text-sm">
          <Plus className="w-4 h-4" /> Add Activity
        </button>
      </div>

      <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
        <div className="p-4 border-b border-gray-100">
          <div className="relative max-w-sm">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-4 h-4" />
            <input type="text" placeholder="Search activities..." value={searchTerm}
              onChange={e => setSearchTerm(e.target.value)}
              className="w-full pl-9 pr-4 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all" />
          </div>
        </div>
        <div className="overflow-x-auto">
          {loading ? (
            <div className="flex items-center justify-center py-20 gap-3">
              <Loader2 className="w-8 h-8 text-blue-600 animate-spin" />
              <span className="text-gray-500 text-sm">Loading activities...</span>
            </div>
          ) : filtered.length === 0 ? (
            <div className="text-center py-20 text-gray-400 text-sm">No activities found.</div>
          ) : (
            <table className="w-full text-sm">
              <thead className="bg-gray-50 text-gray-500 text-xs uppercase tracking-wide font-semibold">
                <tr>
                  <th className="px-6 py-3 text-left">Activity</th>
                  <th className="px-6 py-3 text-left hidden md:table-cell">Category</th>
                  <th className="px-6 py-3 text-left hidden lg:table-cell">Duration</th>
                  <th className="px-6 py-3 text-left hidden lg:table-cell">Price</th>
                  <th className="px-6 py-3 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {filtered.map(a => (
                  <tr key={a.id} className="hover:bg-gray-50/50 transition-colors">
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-3">
                        <img src={a.images?.[0]} alt={a.title}
                          className="w-10 h-10 rounded-lg object-cover bg-gray-100 flex-shrink-0"
                          onError={e => { e.target.src = 'https://placehold.co/100?text=N/A'; }} />
                        <div className="min-w-0">
                          <p className="font-semibold text-gray-900 truncate">{a.title}</p>
                          <p className="text-xs text-gray-400 flex items-center gap-1 mt-0.5">
                            <MapPin className="w-3 h-3" />{a.location}
                          </p>
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4 hidden md:table-cell">
                      <span className="px-2.5 py-1 bg-blue-50 text-blue-700 rounded-full text-xs font-semibold">{a.category}</span>
                    </td>
                    <td className="px-6 py-4 hidden lg:table-cell text-gray-500">{a.duration}</td>
                    <td className="px-6 py-4 hidden lg:table-cell font-bold text-gray-900">${a.price}</td>
                    <td className="px-6 py-4 text-right">
                      <div className="flex items-center justify-end gap-1">
                        <button onClick={() => handleOpenModal(a)} className="p-2 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-all"><Edit2 className="w-4 h-4" /></button>
                        <button onClick={() => handleDelete(a.id)} className="p-2 text-gray-400 hover:text-red-500 hover:bg-red-50 rounded-lg transition-all"><Trash2 className="w-4 h-4" /></button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>

      {/* Modal */}
      <AnimatePresence>
        {isModalOpen && (
          <div className="fixed inset-0 z-50 flex items-start justify-center p-4 overflow-y-auto">
            <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
              onClick={() => setIsModalOpen(false)} className="fixed inset-0 bg-black/50 backdrop-blur-sm" />
            <motion.div initial={{ opacity: 0, scale: 0.95, y: 20 }} animate={{ opacity: 1, scale: 1, y: 0 }} exit={{ opacity: 0, scale: 0.95, y: 20 }}
              className="relative bg-white w-full max-w-3xl rounded-2xl shadow-2xl my-8 overflow-hidden">
              <div className="sticky top-0 z-10 flex items-center justify-between px-6 py-4 bg-blue-600 text-white">
                <h2 className="font-bold text-lg">{current ? 'Edit Activity' : 'Add New Activity'}</h2>
                <button onClick={() => setIsModalOpen(false)} className="p-1.5 hover:bg-white/20 rounded-full transition-colors"><X className="w-5 h-5" /></button>
              </div>

              <form onSubmit={handleSubmit} className="p-6 space-y-6">
                <section>
                  <h3 className="text-xs uppercase tracking-wider text-gray-400 font-bold mb-4">Basic Information</h3>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div className="sm:col-span-2">
                      <label className="block text-sm font-semibold text-gray-700 mb-1.5">Title *</label>
                      <input required value={formData.title} onChange={e => setFormData({...formData, title: e.target.value})}
                        className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all" placeholder="e.g. Red Sea Snorkeling Tour" />
                    </div>
                    <div>
                      <label className="block text-sm font-semibold text-gray-700 mb-1.5">Category *</label>
                      <select value={formData.category} onChange={e => setFormData({...formData, category: e.target.value})}
                        className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all bg-white">
                        {CATEGORIES.map(c => <option key={c}>{c}</option>)}
                      </select>
                    </div>
                    <div>
                      <label className="block text-sm font-semibold text-gray-700 mb-1.5">Location *</label>
                      <select required value={formData.location} onChange={e => setFormData({...formData, location: e.target.value})}
                        className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all bg-white">
                        <option value="" disabled>Select a location...</option>
                        {LOCATIONS.map(loc => <option key={loc} value={loc}>{loc}</option>)}
                      </select>
                    </div>
                    <div>
                      <label className="block text-sm font-semibold text-gray-700 mb-1.5">Duration *</label>
                      <div className="relative">
                        <Clock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                        <input required value={formData.duration} onChange={e => setFormData({...formData, duration: e.target.value})}
                          className="w-full pl-9 pr-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all" placeholder="e.g. 4 Hours" />
                      </div>
                    </div>
                    <div>
                      <label className="block text-sm font-semibold text-gray-700 mb-1.5">Age Requirement</label>
                      <input value={formData.ageRequirement} onChange={e => setFormData({...formData, ageRequirement: e.target.value})}
                        className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all" placeholder="e.g. 8+ years" />
                    </div>
                    <div className="sm:col-span-2">
                      <label className="block text-sm font-semibold text-gray-700 mb-1.5">Short Description</label>
                      <textarea value={formData.description} onChange={e => setFormData({...formData, description: e.target.value})} rows={2}
                        className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all resize-none" placeholder="Brief overview..." />
                    </div>
                    <div className="sm:col-span-2">
                      <label className="block text-sm font-semibold text-gray-700 mb-1.5">Full Description</label>
                      <textarea value={formData.fullDescription} onChange={e => setFormData({...formData, fullDescription: e.target.value})} rows={4}
                        className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all resize-none" placeholder="Detailed description..." />
                    </div>
                  </div>
                </section>

                <section>
                  <h3 className="text-xs uppercase tracking-wider text-gray-400 font-bold mb-4">Pricing & Rating</h3>
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-semibold text-gray-700 mb-1.5">Price ($) *</label>
                      <div className="relative">
                        <DollarSign className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                        <input required type="number" min="0" step="0.01" value={formData.price} onChange={e => setFormData({...formData, price: e.target.value})}
                          className="w-full pl-9 pr-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all" placeholder="50" />
                      </div>
                    </div>
                    <div>
                      <label className="block text-sm font-semibold text-gray-700 mb-1.5">Rating (0–5)</label>
                      <div className="relative">
                        <Star className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                        <input type="number" min="0" max="5" step="0.1" value={formData.rating} onChange={e => setFormData({...formData, rating: e.target.value})}
                          className="w-full pl-9 pr-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all" placeholder="4.8" />
                      </div>
                    </div>
                    <div>
                      <label className="block text-sm font-semibold text-gray-700 mb-1.5">Discount (%)</label>
                      <div className="relative">
                        <input type="number" min="0" max="100" value={formData.discount} onChange={e => setFormData({...formData, discount: e.target.value})}
                          className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all" placeholder="10" />
                      </div>
                    </div>
                  </div>
                </section>

                <section>
                  <h3 className="text-xs uppercase tracking-wider text-gray-400 font-bold mb-4">Images *</h3>
                  <ImageField images={formData.images} onChange={v => setFormData({...formData, images: v})} />
                </section>

                <section>
                  <h3 className="text-xs uppercase tracking-wider text-gray-400 font-bold mb-4">What's Included / Not Included</h3>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
                    <DynamicList items={formData.whatsIncluded} onChange={v => setFormData({...formData, whatsIncluded: v})}
                      label="What's Included" placeholder="e.g. Equipment" />
                    <DynamicList items={formData.whatsNotIncluded} onChange={v => setFormData({...formData, whatsNotIncluded: v})}
                      label="What's Not Included" placeholder="e.g. Transport" />
                  </div>
                </section>

                <section>
                  <h3 className="text-xs uppercase tracking-wider text-gray-400 font-bold mb-3">Languages Available</h3>
                  <div className="flex flex-wrap gap-2">
                    {LANGUAGES.map(l => (
                      <button type="button" key={l} onClick={() => toggleLang(l)}
                        className={`px-3 py-1.5 rounded-full text-xs font-semibold border transition-all ${
                          formData.languages.includes(l)
                            ? 'bg-blue-600 text-white border-blue-600 shadow-sm scale-105'
                            : 'bg-white text-gray-600 border-gray-200 hover:border-blue-400'
                        }`}>
                        {l}
                      </button>
                    ))}
                  </div>
                </section>

                <section>
                  <h3 className="text-xs uppercase tracking-wider text-gray-400 font-bold mb-4">Pickup Information</h3>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-semibold text-gray-700 mb-1.5">Pickup Location</label>
                      <input value={formData.pickupInfo_location} onChange={e => setFormData({...formData, pickupInfo_location: e.target.value})}
                        className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all" placeholder="e.g. Hotel Lobby" />
                    </div>
                    <div>
                      <label className="block text-sm font-semibold text-gray-700 mb-1.5">Pickup Time</label>
                      <input value={formData.pickupInfo_time} onChange={e => setFormData({...formData, pickupInfo_time: e.target.value})}
                        className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all" placeholder="e.g. 08:00 AM" />
                    </div>
                  </div>
                </section>

                <section>
                  <h3 className="text-xs uppercase tracking-wider text-gray-400 font-bold mb-4">Options</h3>
                  <div className="space-y-3">
                    <BoolToggle label="Pickup Included" field="pickupIncluded" />
                    <BoolToggle label="Instant Confirmation" field="instantConfirmation" />
                    <BoolToggle label="Free Cancellation" field="freeCancellation" />
                  </div>
                </section>

                <div className="pt-2 border-t border-gray-100">
                  <button type="submit" disabled={saving}
                    className="w-full bg-blue-600 text-white py-3 rounded-xl font-bold text-sm hover:bg-blue-700 transition-all disabled:opacity-60 flex items-center justify-center gap-2 shadow-lg shadow-blue-500/20">
                    {saving ? <Loader2 className="w-4 h-4 animate-spin" /> : <CheckCircle2 className="w-4 h-4" />}
                    {saving ? 'Saving...' : (current ? 'Update Activity' : 'Create Activity')}
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

export default Activities;
