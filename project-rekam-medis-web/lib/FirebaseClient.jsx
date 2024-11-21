import firebase from "firebase/app";
import "firebase/auth";
import "firebase/firestore";

const firebaseConfig = {
  apiKey: "AIzaSyBQRlQ0nXFx76pK9iVU4pHeyL5S3R4m2FI",
  authDomain: "medical-rekam.firebaseapp.com",
  databaseURL:
    "https://medical-rekam-default-rtdb.asia-southeast1.firebasedatabase.app",
  projectId: "medical-rekam",
  storageBucket: "medical-rekam.appspot.com",
  messagingSenderId: "982637508834",
  appId: "1:982637508834:web:6b393c0920aaa1d8b986bb",
  measurementId: "G-9SCWJ0D9LZ",
};

if (!firebase.apps.length) {
  firebase.initializeApp(firebaseConfig);
}

export default firebase;
