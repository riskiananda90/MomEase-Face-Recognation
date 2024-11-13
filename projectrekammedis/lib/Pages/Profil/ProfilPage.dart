import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:projectrekammedis/Component/AppColor.dart';

class Profilpage extends StatefulWidget {
  const Profilpage({super.key});

  @override
  State<Profilpage> createState() => _JadwalpageState();
}

class _JadwalpageState extends State<Profilpage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final box = GetStorage();
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isEditing = true;
  String? imageUrl;
  String? uid;

  void initState() {
    super.initState();
    uid = box.read("uidAktif");
    userData = box.read(uid!) ?? {};
    print("UID : $uid");
    AmbilDataGambar();
  }

  Future<void> AmbilDataGambar() async {
    try {
      if (userData != null && uid != null) {
        final storageRef =
            FirebaseStorage.instance.ref().child('/Users/Pasien/${uid}.jpg');
        final url = await storageRef.getDownloadURL();
        setState(() {
          imageUrl = url;
        });
      }
    } catch (e) {
      print("Error AmbilDataGambar : $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.Primary,
      appBar: AppBar(
        backgroundColor: Appcolor.textPrimary,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
            icon: Icon(
              Icons.edit,
              color: Appcolor.Primary,
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Appcolor.Primary,
          ),
        ),
        title: const Text("Profil",
            style: TextStyle(
                color: Appcolor.Primary, fontWeight: FontWeight.bold)),
      ),
      // bottomNavigationBar: Bottomnavigation(currentIndex: ,),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 70, top: 30),
                decoration: BoxDecoration(
                    color: Appcolor.textPrimary,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20))),
                child: Center(
                  child: SizedBox(
                    child: CircleAvatar(
                      radius: 63,
                      backgroundColor: Appcolor.Primary,
                      child: isLoading
                          ? CircularProgressIndicator()
                          : imageUrl != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(imageUrl!),
                                  radius: 60,
                                )
                              : CircleAvatar(
                                  radius: 60,
                                  child: Icon(
                                    Icons.person,
                                    size: 40,
                                  ),
                                ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(" Nama :",
                              style: TextStyle(color: Appcolor.textPrimary)),
                          TextFormField(
                            readOnly: isEditing,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Appcolor.textPrimary, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Appcolor.Primary, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                hintStyle:
                                    TextStyle(color: Appcolor.textPrimary),
                                hintText: "${userData?['name']}"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(" Email :",
                              style: TextStyle(color: Appcolor.textPrimary)),
                          TextFormField(
                            readOnly: isEditing,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Appcolor.textPrimary, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                hintStyle:
                                    TextStyle(color: Appcolor.textPrimary),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                hintText: "${userData?['email']}"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(" No HP :",
                              style: TextStyle(color: Appcolor.textPrimary)),
                          TextFormField(
                            readOnly: isEditing,
                            decoration: InputDecoration(
                                focusColor: Appcolor.textPrimary,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Appcolor.textPrimary, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                hintStyle:
                                    TextStyle(color: Appcolor.textPrimary),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                hintText: "${userData?['phone']}"),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Appcolor.textPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.save,
                                color: Appcolor.Primary,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Simpan ",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Appcolor.Primary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
