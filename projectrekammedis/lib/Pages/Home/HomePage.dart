import 'dart:ui';
// ignore: non_constant_identifier_names
import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../Component/AppColor.dart';
import '../../Component/NavBattom.dart';
import 'package:get_storage/get_storage.dart';
import 'DetailBuah.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final box = GetStorage();
  late YoutubePlayerController _controller;
  // ignore: non_constant_identifier_names
  int waktu_kehamilan = 124;
  late Color _colorHari;
  late Color _colorMinggu;
  Map<String, dynamic>? userData;
  final firabase = FirebaseFirestore.instance;
  final TextEditingController _keluhanController = TextEditingController();
  CollectionReference? Users;
  String? uid;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    uid = box.read("uidAktif");
    print("UID : $uid");
    userData = box.read(uid!) ?? {};
    Users = firabase.collection('users');
    _colorHari = Appcolor.textPrimary;
    _colorMinggu = Appcolor.Primary;
  }

  final List<String> _listVideo = [
    '4ZAHX-N-AhM',
    '4evfiP9cTkk',
    'aFH1SyFkbDg',
    'mlKTiG_Ct_Q',
    'bnQjTwwpjKA',
  ];

  Future<void> SimpanDataKeluhan() async {
    print("Ingin simpan data ...");
    try {
      _ShowDialogProgress();
      final Keluhan = _keluhanController.text;
      await Users!.doc(uid).update({
        'Keluhan': FieldValue.arrayUnion([Keluhan])
      });
      userData!['Keluhan'] = Keluhan;
      await box.write(uid!, userData);

      _keluhanController.clear();
      Navigator.of(context).pop();
      _showSuccessDialog("Data Berhasil Disimpan");
      print("Simpan Data Keluhan");
    } catch (e) {
      print("Error SimpanDataKeluhan : $e");
      Navigator.of(context).pop();
      _showErrorDialog("Gagal menyimpan data keluhan");
    }
  }

  void _ShowBottomSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        enableDrag: false,
        backgroundColor: Colors.transparent,
        // Menyembunyikan overlay di sekitarnya
        elevation: 5,
        topRadius: Radius.circular(20), // Radius sudut atas
        // isDismissible: false,
        expand: false,
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(20), // Membuat sudut membulat
                child: Material(
                  color: Appcolor.Primary,
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: CustomPaint(
                        painter: CurvePainter(),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 20,
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom + 20,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                    height: 100,
                                    child: Image.asset("Images/logo.png")),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Masukan keluhan anda",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Appcolor.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Form(
                                  key: _formkey,
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Masukan keluhan anda";
                                      }
                                      return null;
                                    },
                                    controller: _keluhanController,
                                    style:
                                        TextStyle(color: Appcolor.textPrimary),
                                    cursorColor: Appcolor.textPrimary,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Appcolor.textPrimary),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Appcolor.textPrimary),
                                      ),
                                      hintText: "",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Appcolor.textPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formkey.currentState!.validate()) {
                                      SimpanDataKeluhan();
                                    } else {
                                      _showErrorDialog(
                                          "Gagal menyimpan data keluhan");
                                    }
                                    ;
                                  },
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        color: Appcolor.Primary,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
      Navigator.of(context).pop();
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
                  size: 40,
                ),
                SizedBox(height: 15),
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

  void _showCustomDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black54, // Warna latar belakang semi-transparan
      barrierDismissible: true,
      barrierLabel: 'Close Dialog',
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Align(
            alignment: Alignment.topRight, // Pojok kanan atas
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: EdgeInsets.only(top: 60, right: 10), // Sesuaikan posisi
                padding: EdgeInsets.all(8),
                width: 250,
                decoration: BoxDecoration(
                  color: Appcolor.textPrimary,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      spreadRadius: 1,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pop(); // Menutup dialog
                        Get.toNamed('/Profilpage');
                      },
                      title:
                          Text(style: TextStyle(color: Colors.black), "Profil"),
                      leading: Icon(Icons.person, color: Colors.black),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pop(); // Menutup dialog
                        Get.toNamed('/Settingspage');
                      },
                      title: Text(
                          style: TextStyle(color: Colors.black), "Pengaturan"),
                      leading: Icon(Icons.settings, color: Colors.black),
                      trailing: Icon(Icons.chevron_right, color: Colors.black),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pop(); // Menutup dialog
                        Get.toNamed('/Test');
                      },
                      title:
                          Text(style: TextStyle(color: Colors.black), "About"),
                      leading: Icon(Icons.info, color: Colors.black),
                      trailing: Icon(Icons.chevron_right, color: Colors.black),
                    ),
                    Divider(),
                    ListTile(
                      onTap: () {
                        box.erase().then((_) {
                          Get.offAllNamed('/Login');
                        });
                      },
                      title: Text(
                        "Logout",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 160, 27, 18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: Icon(Icons.logout,
                          color: const Color.fromARGB(255, 160, 27, 18)),
                      trailing: Icon(Icons.chevron_right,
                          color: const Color.fromARGB(255, 160, 27, 18)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return ScaleTransition(
          scale: animation1,
          alignment: Alignment.topRight,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Bottomnavigation(currentIndex: 0),
      backgroundColor: Appcolor.Primary,
      appBar: AppBar(
        backgroundColor: Appcolor.Primary,
        leading: const Icon(
          Icons.menu,
          color: Colors.black87,
        ),
        centerTitle: true,
        title: Text(
          "MomEase",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        actions: [
          badges.Badge(
            position: badges.BadgePosition.topEnd(top: -5, end: -5),
            badgeStyle: badges.BadgeStyle(
              elevation: 10,
              badgeColor: Colors.red,
            ),
            showBadge: true,
            badgeContent: const Text(
              "2",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 8),
            ),
            child: const Icon(
              Icons.notifications,
              color: Appcolor.textPrimary,
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: CircleAvatar(
              radius: 12,
              backgroundColor: Appcolor.textPrimary.withOpacity(0.4),
              child: const CircleAvatar(
                radius: 10,
                backgroundImage: AssetImage("Images/User/foto_rizki.png"),
              ),
            ),
            onPressed: () => _showCustomDialog(context),
          ),
          SizedBox(width: 5),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding:
              const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 7),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Selamat datang, ${userData?['name'] ?? "Tamu"}",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black54),
                                ),
                                Text(
                                  "Hamil bahagia , Ibu cerdas!",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 7),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Appcolor.textPrimary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Waktu kehamilan",
                                  style: TextStyle(
                                      color: Appcolor.Primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _colorHari == Appcolor.textPrimary
                                      ? "${waktu_kehamilan}  Hari"
                                      : "${(waktu_kehamilan / 7).floor()}  Minggu",
                                  style: TextStyle(
                                      color: Appcolor.Primary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              margin: EdgeInsets.only(left: 2, right: 2),
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: Appcolor.Primary,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  TextButton(
                                      style: TextButton.styleFrom(
                                        elevation: 0,
                                        side: BorderSide(
                                            color: _colorMinggu, width: 2),
                                        backgroundColor: _colorMinggu,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _colorMinggu = Appcolor.textPrimary;
                                          _colorHari = Appcolor.Primary;
                                        });
                                      },
                                      child: Text(
                                        "Minggu",
                                        style: TextStyle(
                                            color: _colorHari, fontSize: 12),
                                      )),
                                  TextButton(
                                      style: TextButton.styleFrom(
                                          elevation: 0,
                                          side: BorderSide(
                                              color: _colorHari, width: 2),
                                          backgroundColor: _colorHari),
                                      onPressed: () {
                                        setState(() {
                                          _colorHari = Appcolor.textPrimary;
                                          _colorMinggu = Appcolor.Primary;
                                        });
                                      },
                                      child: Text(
                                        "Hari",
                                        style: TextStyle(
                                            color: _colorMinggu, fontSize: 12),
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 7),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Appcolor.textPrimary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 210,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Masukan keluhan",
                                    style: TextStyle(
                                        color: Appcolor.Primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Kami akan menindak lanjuti keluhan anda dalam    1 x 24 jam kerja",
                                    style: TextStyle(
                                      color: Appcolor.Primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              style: IconButton.styleFrom(
                                  elevation: 10,
                                  shadowColor: Colors.black,
                                  backgroundColor: Appcolor.Primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              onPressed: () {
                                setState(() {
                                  _ShowBottomSheet(context);
                                });
                              },
                              icon: Icon(
                                Icons.arrow_forward,
                                color: Appcolor.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(" Rekomendasi",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                                fontSize: 18,
                              )),
                          SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RekomendasiMakanan(
                                  DetailMenu: () => showDialog(
                                    context: context,
                                    builder: (context) => BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: Detailbuah(
                                        title: "Buah",
                                        gambar: "Images/Detail/DetailBuah.jpg",
                                        deskripsi:
                                            "Buah-buahan seperti apel kaya akan vitamin C dan serat, yang membantu menjaga sistem pencernaan ibu hamil tetap sehat dan mendukung sistem kekebalan tubuh.",
                                      ),
                                    ),
                                  ),
                                  title: "Buah",
                                  gambar: "Images/Logo/buah.png",
                                ),
                                RekomendasiMakanan(
                                  DetailMenu: () => showDialog(
                                    context: context,
                                    builder: (context) => BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: Detailbuah(
                                        title: "Sayur",
                                        gambar: "Images/Detail/DetailSayur.jpg",
                                        deskripsi:
                                            "Sayuran kaya akan folat, serat, dan berbagai vitamin yang penting untuk pertumbuhan janin dan menjaga kesehatan ibu hamil, terutama dalam mendukung fungsi sistem pencernaan.",
                                      ),
                                    ),
                                  ),
                                  title: "Sayur",
                                  gambar: "Images/Logo/sayur.png",
                                ),
                                RekomendasiMakanan(
                                  DetailMenu: () => showDialog(
                                    context: context,
                                    builder: (context) => BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: Detailbuah(
                                        title: "Susu",
                                        gambar: "Images/Detail/DetailSusu.jpg",
                                        deskripsi:
                                            "Susu mengandung kalsium, vitamin D, dan protein yang penting untuk perkembangan tulang dan gigi janin serta mendukung kesehatan tulang ibu hamil.",
                                      ),
                                    ),
                                  ),
                                  title: "Susu",
                                  gambar: "Images/Logo/susu.png",
                                ),
                                RekomendasiMakanan(
                                  DetailMenu: () => showDialog(
                                    context: context,
                                    builder: (context) => BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: Detailbuah(
                                        title: "Ikan",
                                        gambar: "Images/Detail/DetailIkan.jpg",
                                        deskripsi:
                                            "Ikan, terutama yang kaya akan omega-3 seperti salmon, membantu perkembangan otak dan mata janin. Pilih ikan yang rendah merkuri untuk kesehatan yang optimal.",
                                      ),
                                    ),
                                  ),
                                  title: "Ikan",
                                  gambar: "Images/Logo/ikan.png",
                                ),
                                RekomendasiMakanan(
                                  DetailMenu: () => showDialog(
                                    context: context,
                                    builder: (context) => BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: Detailbuah(
                                        title: "Kacang",
                                        gambar:
                                            "Images/Detail/DetailKacang.jpg",
                                        deskripsi:
                                            "Kacang-kacangan kaya akan protein nabati, zat besi, dan serat, yang mendukung pertumbuhan janin dan mencegah anemia pada ibu hamil.",
                                      ),
                                    ),
                                  ),
                                  title: "Kacang",
                                  gambar: "Images/Logo/kacang.png",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(" Temukan solusi ibu sehat",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                                fontSize: 18,
                              )),
                          SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _listVideo.map((videoId) {
                                return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      padding: EdgeInsets.all(2),
                                      height: 170,
                                      width: MediaQuery.of(context).size.width /
                                          1.1,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 1,
                                              blurRadius: 10,
                                              color: Colors.black26,
                                              offset: Offset(0, 2)),
                                        ],
                                        color: Appcolor.textPrimary,
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: YoutubePlayer(
                                          controller: YoutubePlayerController(
                                              initialVideoId: videoId,
                                              flags: YoutubePlayerFlags(
                                                  autoPlay: false,
                                                  mute: false,
                                                  disableDragSeek: true)),
                                          showVideoProgressIndicator: true,
                                        ),
                                      ),
                                    ));
                              }).toList(),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RekomendasiMakanan extends StatelessWidget {
  const RekomendasiMakanan({
    super.key,
    required this.title,
    required this.gambar,
    this.DetailMenu,
  });
  final String title;
  final String gambar;
  final VoidCallback? DetailMenu;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            onPressed: DetailMenu,
            style: ElevatedButton.styleFrom(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(10),
              backgroundColor: Appcolor.textPrimary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  gambar,
                  width: 30,
                  height: 30,
                  // fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 5), // Menambah jarak sedikit antara ikon dan teks
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Warna titik-titik
    final dotPaint = Paint()..color = Colors.grey.withOpacity(0.5);

    // Ukuran titik dan jarak antar titik
    double dotSize = 1.0;
    double spacing = 30.8;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotSize, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Mengembalikan false karena pola titik-titik statis
  }
}
