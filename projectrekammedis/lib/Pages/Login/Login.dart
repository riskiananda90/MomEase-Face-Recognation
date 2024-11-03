import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:projectrekammedis/Component/AppColor.dart';
import '../Auth_Detect_face/login_face.dart';
import '../Biodata/BiodataPage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;

  final formKey = GlobalKey<FormState>();
  TextEditingController textControllerPass = TextEditingController();
  TextEditingController textControllerEmail = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference? users;

  @override
  void initState() {
    super.initState();
    users = firestore.collection('users');
  }

  Future<void> authenticateFaces() async {
    try {
      _ShowDialogProgress();
      // Ambil gambar pertama dari Firebase Storage
      print("Ambil gambar pertama dari Firebase Storage");

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('/Users/Pasien/${textControllerEmail.text}.jpg');
      final imageUrl = await storageRef.getDownloadURL();

      // Ambil data gambar dari URL dan ubah menjadi Base64
      print("Ambil data gambar dari URL dan ubah menjadi Base64");

      final responseImage1 = await http.get(Uri.parse(imageUrl));
      // final gambar_asset = await rootBundle.load("Images/User/foto_rizki.png");
      final gambar_asset2 =
          await rootBundle.load("Images/User2/foto_rizki.png");
      if (responseImage1.statusCode != 200) {
        print("Tidak bisa mengambil gambar di database");
        return;
      }
      print("Gambar berhasil di ambil dari database");
      String image1Base64 = base64Encode(responseImage1.bodyBytes);
      // String image1Base64 = base64Encode(gambar_asset.buffer.asUint8List());

      // Navigasi ke halaman LoginFace untuk mengambil gambar kedua
      final File? image2File = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginFace()),
      );

      if (image2File == null) {
        print("Pengambilan gambar kedua dibatalkan.");
        return;
      }
      print("Gambar kedua berhasil diambil dari camera");

      // Konversi gambar kedua menjadi Base64
      final bytes2 = await image2File.readAsBytes();
      // String image2Base64 = base64Encode(gambar_asset2.buffer.asUint8List());
      String image2Base64 = base64Encode(bytes2);
      print("Gambar kedua berhasil di konversi ke Base64");

      // Kirim kedua gambar ke server untuk verifikasi wajah
      final response = await http.post(
        Uri.parse(
            'http://172.20.10.3:5000/authenticate'), // Ganti dengan IP server Anda
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "image1": image1Base64,
          "image2": image2Base64,
        }),
      );
      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['status'] == 'sukses') {
          _showSuccessDialog("Autentikasi wajah berhasil!");
        } else {
          print('Authentication failed');
          _showErrorDialog("Autentikasi wajah gagal!");
        }
      } else if (response.statusCode == 400) {
        print('Authentication failed');
        _showErrorDialog("Wajah tidak terdeteksi.");
      } else {
        print('Authentication failed');
        _showErrorDialog("Gagal menghubungi server.");
      }
    } catch (e) {
      print("Error: $e");
      Navigator.of(context).pop();
      _showErrorDialog("Terjadi kesalahan.");
    }
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      try {
        final authentication = await users
            ?.where("email", isEqualTo: textControllerEmail.text)
            .where("password", isEqualTo: textControllerPass.text)
            .get();

        if (authentication!.docs.isNotEmpty) {
          // Panggil authenticateFaces untuk verifikasi wajah setelah login berhasil
          await authenticateFaces();
        } else {
          _showErrorDialog("Username atau Password salah");
        }
      } catch (e) {
        print(e);
      }

      // textControllerEmail.clear();
      // textControllerPass.clear();
    }
  }

  void _ShowDialogProgress() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Berhasil",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B8FAC),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Image.asset("Images/Logo/Check.png", width: 70, height: 70),
            ],
          ),
        );
      },
    ).then((_) {
      Get.offAll(() => const Biodatapage());
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Error",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Icon(Icons.error, color: Colors.red, size: 70),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    textControllerPass.dispose();
    textControllerEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Appcolor.Primary,
        appBar: AppBar(
          backgroundColor: Appcolor.Card,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back),
            color: Appcolor.textPrimary,
          ),
          title: const Text(
            "Login",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Appcolor.textPrimary,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Text(
                  "Log in to continue",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Appcolor.textPrimary),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Silahkan masuk ke akun anda untuk mengakses layanan kesehatan dan informasi medis yang anda butuhkan",
                  style: TextStyle(color: Appcolor.textPrimary),
                ),
                const SizedBox(height: 30),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Appcolor.textPrimary),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: textControllerEmail,
                        decoration: InputDecoration(
                          hintText: "Masukan email...",
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(
                            Icons.mail_outline,
                            color: Appcolor.Secondary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email tidak boleh kosong";
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return "Format email tidak valid";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Appcolor.textPrimary),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: textControllerPass,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: "Masukan password...",
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Appcolor.Secondary,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(_obscureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            color: Appcolor.Secondary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(color: Appcolor.Secondary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 10,
                            shadowColor: Colors.black,
                            backgroundColor: Appcolor.Secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: login,
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                color: Appcolor.Primary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Column(
                        children: [
                          Text("Atau",
                              style: TextStyle(color: Appcolor.textPrimary)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.facebook,
                                  color: const Color.fromARGB(255, 3, 76, 135),
                                  size: 40,
                                ),
                              ),
                              SizedBox(width: 5),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.email,
                                  color: const Color.fromARGB(255, 167, 19, 9),
                                  size: 40,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Tidak punya akun ? ",
                                  style:
                                      TextStyle(color: Appcolor.textPrimary)),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed("/sign");
                                },
                                child: Text(
                                  "Daftar sekarang",
                                  style: TextStyle(color: Appcolor.Secondary),
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
