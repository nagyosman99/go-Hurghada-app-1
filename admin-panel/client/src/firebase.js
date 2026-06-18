import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";

const firebaseConfig = {
  apiKey: "AIzaSyC-wXV_u4LV7B20w4eCqhQeouuqcjp3_A4",
  authDomain: "go-hurghada-ffab9.firebaseapp.com",
  projectId: "go-hurghada-ffab9",
  storageBucket: "go-hurghada-ffab9.appspot.com",
  messagingSenderId: "925908168972",
  appId: "1:925908168972:web:1e7195909f8ac0b93d1929"
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
