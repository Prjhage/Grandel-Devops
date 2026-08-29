const admin = require("firebase-admin");
const path = require("path");
const fs = require("fs");

if (!admin.apps.length) {
  try {
    const serviceKeyPath = path.join(__dirname, "../firebaseServiceKey.json");
    
    if (process.env.FIREBASE_PROJECT_ID && process.env.FIREBASE_CLIENT_EMAIL && process.env.FIREBASE_PRIVATE_KEY) {
      const serviceAccount = {
        projectId: process.env.FIREBASE_PROJECT_ID,
        clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
        privateKey: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, "\n"),
      };
      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
      });
      console.log("Firebase Admin initialized successfully from env vars.");
    } else if (fs.existsSync(serviceKeyPath)) {
      const serviceAccount = require(serviceKeyPath);
      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
      });
      console.log("Firebase Admin initialized successfully from firebaseServiceKey.json.");
    } else {
      console.warn("Warning: Firebase environment variables missing and firebaseServiceKey.json not found.");
    }
  } catch (error) {
    console.error("Firebase initialization failed:", error.message);
  }
}

module.exports = admin;
