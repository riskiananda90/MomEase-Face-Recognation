import { firestore } from "../../lib/FirebaseAdmin";

export default async function handler(req, res) {
  try {
    const firestoreSnapshot = await firestore.collection("users").get();
    if (!firestoreSnapshot.empty) {
      const firestoreData = firestoreSnapshot.docs.map((doc) => doc.data());
      res.status(200).json({
        message: "success",
        firestoreData,
      });
    } else {
      res.status(404).json({
        message: "data not found",

      })
    }
  } catch (e) {
    console.error("error koneksi ke database : ", e);
    if (
      res.status(500).json({
        message: "error koneksi ke database",
        error: e.message,
      })
    );
  }
}
