import axios from 'axios';
import { auth } from './firebase';

const api = axios.create({
  baseURL: 'http://127.0.0.1:5000/api',
});

// Attach Firebase ID token to every request
api.interceptors.request.use(async (config) => {
  const user = auth.currentUser;
  if (user) {
    const token = await user.getIdToken();
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export default api;
