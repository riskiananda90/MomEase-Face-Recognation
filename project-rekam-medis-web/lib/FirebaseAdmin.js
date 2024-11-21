import admin from "firebase-admin";

if (!admin.apps.length) {
  console.log("Firebase Project ID:", process.env.FIREBASE_PROJECT_ID);
  console.log("Firebase Client Email:", process.env.FIREBASE_CLIENT_EMAIL);
  console.log("Firebase Private Key:", process.env.FIREBASE_PRIVATE_KEY ? "Exists" : "Missing");

  admin.initializeApp({

    credential: admin.credential.cert({
      projectId: process.env.FIREBASE_PROJECT_ID,
      clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
      privateKey: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n'),
    }),
    databaseURL:
      "https://medical-rekam-default-rtdb.asia-southeast1.firebasedatabase.app",
  });
}

const firestore = admin.firestore();
export { firestore };
