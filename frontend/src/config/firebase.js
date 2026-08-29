import { initializeApp } from "firebase/app";
import { getAuth, GoogleAuthProvider } from "firebase/auth";

const firebaseConfig = {
    apiKey: import.meta.env.VITE_FIREBASE_API_KEY || "AIzaSyCzF5bu-YibyR4M6LQCVXiKtaH4UFTI0Bk",
    authDomain: import.meta.env.VITE_FIREBASE_AUTH_DOMAIN || "wanderlust-fc9ed.firebaseapp.com",
    projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID || "wanderlust-fc9ed",
    storageBucket: import.meta.env.VITE_FIREBASE_STORAGE_BUCKET || "wanderlust-fc9ed.appspot.com",
    messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID || "469528775376",
    appId: import.meta.env.VITE_FIREBASE_APP_ID || "1:469528775376:web:297003ca97192fcc87acd5"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const googleProvider = new GoogleAuthProvider();
googleProvider.setCustomParameters({ prompt: 'select_account' });

export { app, auth, googleProvider };
export default app;