from flask import Flask, request, jsonify
import numpy as np
import cv2
import base64
from deepface import DeepFace
import os
import time

app = Flask(__name__)

# Membuat direktori untuk menyimpan hasil crop
os.makedirs("cropped_faces", exist_ok=True)

def calculate_distance(embedding1, embedding2):
    embedding1_vector = np.array(embedding1[0]['embedding'])
    embedding2_vector = np.array(embedding2[0]['embedding'])
    return np.linalg.norm(embedding1_vector - embedding2_vector)

def save_cropped_face(image, filename):
    start_time = time.time()
    faces = DeepFace.extract_faces(image, detector_backend="mtcnn", enforce_detection=True)
    end_time = time.time()
    print(f"Time taken to detect face: {end_time - start_time} seconds")
    if faces:
        detected_face = faces[0]
        # Konversi wajah terdeteksi ke skala 8-bit untuk disimpan
        face_image = (detected_face["face"] * 255).astype(np.uint8)
        face_image_bgr = cv2.cvtColor(face_image, cv2.COLOR_RGB2BGR)
        cv2.imwrite(f"cropped_faces/{filename}.jpg", face_image_bgr)
        
    else:
        print(f"No face detected for {filename}")

@app.route('/bacaText', methods=['POST'])




@app.route('/authenticate', methods=['POST'])
def authenticate():
    data = request.json
    image1_base64 = data['image1']
    image2_base64 = data['image2']

    # Decode base64 images
    image1_data = base64.b64decode(image1_base64)
    image2_data = base64.b64decode(image2_base64)
    image1 = np.frombuffer(image1_data, np.uint8)
    image2 = np.frombuffer(image2_data, np.uint8)
    image1 = cv2.imdecode(image1, cv2.IMREAD_COLOR)
    image2 = cv2.imdecode(image2, cv2.IMREAD_COLOR)

    # Simpan hasil cropping wajah
    save_cropped_face(image1, "cropped_image1")
    save_cropped_face(image2, "cropped_image2")

    # Deteksi wajah dan ekstraksi embedding dengan DeepFace
    try:
        start_embedding_time = time.time()
        embedding1 = DeepFace.represent(image1, model_name="Facenet", detector_backend="mtcnn")
        embedding2 = DeepFace.represent(image2, model_name="Facenet", detector_backend="mtcnn")
        end_embedding_time = time.time()
        print(f"Ekstraksi embedding membutuhkan waktu {end_embedding_time - start_embedding_time} detik")
        
        print("Embedding1:", embedding1)
        print("Embedding2:", embedding2)
    except ValueError:
        return jsonify({"error": "Tidak ada wajah yang terdeteksi"}), 400

    # Hitung jarak antara kedua embedding
    start_distance_time = time.time()
    distance = calculate_distance(embedding1, embedding2)
    end_distance_time = time.time()
    print("Distance:", distance)
    print(f"Hitung jarak membutuhkan waktu {end_distance_time - start_distance_time} detik")
    
    # Threshold untuk FaceNet biasanya di sekitar 1.0, bisa disesuaikan
    threshold = 8.5
    if distance < threshold:
        return jsonify({"status": "sukses", "message": "Autentikasi berhasil"})
    else:
        return jsonify({"status": "gagal", "message": "Autentikasi gagal"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
