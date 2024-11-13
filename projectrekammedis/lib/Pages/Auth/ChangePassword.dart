import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:projectrekammedis/Component/AppColor.dart';
import 'package:projectrekammedis/Pages/Auth/CheckYourEmail.dart';

import '../Login/Login.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({super.key});

  @override
  State<Changepassword> createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {
  CollectionReference? users;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? uid;
  Map<String, dynamic>? userData;
  final box = GetStorage();
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    users = firestore.collection('users');
    uid = box.read("uidAktif");
    print("UID : $uid");
    userData = box.read(uid!) ?? {};
    setState(() {
      _emailController.text = userData!['email'] ?? {};
    });
  }

  Future<void> ResetPassword() async {
    try {
      _ShowDialogProgress();
      print("Ambil email ...");
      if (userData != null &&
          userData!['email'] != null &&
          userData!['email'] == _emailController.text) {
        String email = userData!['email'];
        await auth.sendPasswordResetEmail(email: email);
        Navigator.of(context).pop();
        _showSuccessDialog("Email berhasil dikirim");
      } else {
        Navigator.of(context).pop();
        _showErrorDialog("Email tidak terdaftar");
      }
    } catch (e) {
      Navigator.of(context).pop(); // Menutup dialog loading jika error
      _showErrorDialog("Gagal mengirim reset password.");
      print("Error: $e");
    }
  }

  void _ShowDialogProgress() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            padding: EdgeInsets.all(20),
            width: 160, // Atur lebar container agar tidak terlalu besar
            decoration: BoxDecoration(
              color: Appcolor.Primary,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Agar sesuai dengan tinggi konten
              children: [
                LoadingAnimationWidget.inkDrop(
                  color: Appcolor.textPrimary,
                  size: 50,
                ),
                SizedBox(height: 20),
                Text(
                  "Loading...",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Appcolor.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
      Get.offAll(() => const Checkyouremail());
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.Primary,
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text("Reset Password",
                      style: TextStyle(
                          height: 1,
                          color: Appcolor.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 45)),
                  SizedBox(height: 10),
                  Text(
                    "Please enter your email address to request a password reset",
                    style: TextStyle(fontSize: 15, color: Appcolor.textPrimary),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Email",
                    style: TextStyle(
                        fontSize: 15,
                        color: Appcolor.textPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return "Format email tidak valid";
                          }
                          return null;
                        },
                        controller: _emailController,
                        style: TextStyle(color: Appcolor.textPrimary),
                        cursorColor: Appcolor.textPrimary,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            suffixIcon: Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Appcolor.Primary,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ]),
                              child: Icon(
                                Icons.check_circle,
                                color: Appcolor.Card,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Appcolor.textPrimary),
                            ))),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Password reset sent to yout email address",
                    style: TextStyle(fontSize: 15, color: Appcolor.textPrimary),
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Appcolor.textPrimary),
                        onPressed: ResetPassword,
                        child: Text(
                          "Send reset password",
                          style: TextStyle(color: Appcolor.Primary),
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("you remember your password ?",
                          style: TextStyle(color: Appcolor.textPrimary)),
                      TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () {
                            Get.offAll(() => const Login());
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Appcolor.textPrimary,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
                ])),
          )),
    );
  }
}
