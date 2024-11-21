// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../Component/AppColor.dart';
import '../../Component/NavBattom.dart';

class Riwayatpage extends StatefulWidget {
  const Riwayatpage({super.key});

  @override
  State<Riwayatpage> createState() => _RiwayatpageState();
}

String FormatDate(DateTime NotificationTime) {
  final Waktu_sekarang = DateTime.now();
  final Selisih_waktu = Waktu_sekarang.difference(NotificationTime);

  if (Selisih_waktu.inSeconds < 60) {
    return "Baru saja";
  } else if (Selisih_waktu.inMinutes < 60) {
    return DateFormat('HH:mm').format(NotificationTime);
  } else if (Selisih_waktu.inHours < 24) {
    return "${Selisih_waktu.inHours} jam yang lalu";
  } else if (Selisih_waktu.inDays < 7) {
    return "${Selisih_waktu.inDays} hari yang lalu";
  } else {
    return DateFormat('dd/MM/yyyy').format(NotificationTime);
  }
}

class _RiwayatpageState extends State<Riwayatpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.Primary,
      appBar: AppBar(
        backgroundColor: Appcolor.Primary,
        centerTitle: true,
        title: Text("Riwayat"),
      ),
      bottomNavigationBar: Bottomnavigation(currentIndex: 1),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListRiwayat(
                    title: "Keluhan",
                    subtitle: "Lihat riwayat keluhan",
                    icon: Icons.speaker_notes_outlined,
                    time: DateTime.now(),
                    onTap: () {
                      Get.toNamed("/Riwayatkeluhan");
                    }),
                ListRiwayat(
                    title: "Quisioner",
                    subtitle: "Lihat riwayat quisioner",
                    icon: Icons.quiz_outlined,
                    time: DateTime.now(),
                    onTap: () {
                      Get.toNamed("/Riwayatquisioner");
                    }),
                ListRiwayat(
                    title: "Resep",
                    subtitle: "Lihat riwayat resep",
                    icon: Icons.medication_outlined,
                    time: DateTime.now(),
                    onTap: () {
                      Get.toNamed("/Riwayatresep");
                    }),
                ListRiwayat(
                    title: "Pemeriksaan",
                    subtitle: "Lihat riwayat pemeriksaan",
                    icon: Icons.fact_check_outlined,
                    time: DateTime.now(),
                    onTap: () {
                      Get.toNamed("/Riwayatpemeriksaan");
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListRiwayat extends StatelessWidget {
  const ListRiwayat({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.time,
    this.onTap,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final DateTime time;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Appcolor.textPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
        onPressed: () {
          if (onTap != null) {
            onTap!();
          }
        },
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.black,
          ),
          contentPadding: EdgeInsets.zero,
          title: Text(
            title,
            style: TextStyle(color: Colors.black),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: Colors.black),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 10,
              ),
              Icon(
                Icons.arrow_forward,
                size: 17,
              ),
              Spacer(),
              Text(
                "${time.hour}:${time.minute}",
                style: TextStyle(fontSize: 13, color: Colors.black45),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
