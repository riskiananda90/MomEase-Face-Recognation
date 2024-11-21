import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:projectrekammedis/Component/AppColor.dart';

class Hasilpemeriksaan extends StatefulWidget {
  const Hasilpemeriksaan({super.key});

  @override
  State<Hasilpemeriksaan> createState() => _HasilpemeriksaanState();
}

class _HasilpemeriksaanState extends State<Hasilpemeriksaan> {
  final riwayat = Get.arguments as Map<String, dynamic>;
  CollectionReference? riwayatCollection;
  Map<String, dynamic>? userData;
  String? uid;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    uid = box.read("uidAktif");
    print("UID : $uid");
    print("Riwayat : $riwayat");
    riwayatCollection = FirebaseFirestore.instance.collection('Riwayat');
    userData = box.read(uid!);
    print("User Data : $userData");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.Primary,
      appBar: AppBar(
        backgroundColor: Appcolor.Primary,
        title: Text("Hasil Pemeriksaan"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Get.back(), icon: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
            decoration: BoxDecoration(
              color: Appcolor.textPrimary,
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                userData?["name"] ?? "Tamu",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2.4,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Appcolor.Primary, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nik pasien"),
                        Text(userData?["Biodata"]['nik'] ?? "Tidak ada data")
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.4,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Appcolor.Primary, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("No register"),
                        Text(userData?["Biodata"]['NoRegister'] ??
                            "Tidak ada data")
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2.4,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Appcolor.Primary, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Alamat"),
                        Text(
                            userData?["Biodata"]["address"] ?? "Tidak ada data")
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.4,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Appcolor.Primary, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tgl Lahir"),
                        Text(userData?["Biodata"]['TglLahir'] ??
                            "Tidak ada data")
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2.4,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Appcolor.Primary, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Alamat"),
                        Text(
                            userData?["Biodata"]["address"] ?? "Tidak ada data")
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.4,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Appcolor.Primary, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tgl Lahir"),
                        Text(userData?["Biodata"]['TglLahir'] ??
                            "Tidak ada data")
                      ],
                    ),
                  )
                ],
              )
            ]),
          )
        ]),
      ),
    );
  }
}
