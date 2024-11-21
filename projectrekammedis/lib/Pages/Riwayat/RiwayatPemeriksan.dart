import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:projectrekammedis/Component/AppColor.dart';
import 'package:intl/intl.dart';

class RiwayatPemeriksaan extends StatefulWidget {
  const RiwayatPemeriksaan({super.key});

  @override
  State<RiwayatPemeriksaan> createState() => _RiwayatPemeriksaanState();
}

class _RiwayatPemeriksaanState extends State<RiwayatPemeriksaan> {
  CollectionReference? riwayatCollection;
  final box = GetStorage();
  String? uid;

  @override
  void initState() {
    super.initState();
    riwayatCollection = FirebaseFirestore.instance.collection('Riwayat');
    // Ambil UID pengguna
    uid = "na7ZV7ck55hL85euhMnp"; // Ubah sesuai data pengguna
    print("UID: $uid");
  }

  Stream<List<Map<String, dynamic>>> getRiwayatPemeriksaanStream() {
    return riwayatCollection!.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final riwayatList = data["RiwayatPemeriksaan"] as List<dynamic>;
        return riwayatList.map((item) => item as Map<String, dynamic>).toList();
      } else {
        return [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.Primary,
      appBar: AppBar(
        backgroundColor: Appcolor.Primary,
        title: const Text("Semua Pemeriksaan"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: getRiwayatPemeriksaanStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Terjadi kesalahan saat memuat data"),
                      );
                    }
                    final riwayatList = snapshot.data ?? [];
                    if (riwayatList.isEmpty) {
                      return const Center(
                        child: Text(
                          "Tidak ada riwayat pemeriksaan",
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: riwayatList.length,
                      itemBuilder: (context, index) {
                        final riwayat = riwayatList[index];
                        final timestamp =
                            riwayat['TglPemeriksaan'] as Timestamp;
                        final dateTime = timestamp.toDate();

                        final formattedDate =
                            DateFormat('dd MMM yyyy').format(dateTime);

                        return Card(
                          color: Appcolor.textPrimary,
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10.0),
                          child: ListTile(
                            onTap: () {
                              Get.toNamed("/Hasilpemeriksaan",
                                  arguments: riwayat);
                            },
                            title: Text(
                              "$formattedDate",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Dokter: ${riwayat["DokterPemeriksaan"] ?? "Tidak tersedia"}",
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Appcolor.Primary),
                              onPressed: () async {
                                try {
                                  await riwayatCollection!.doc(uid).update({
                                    "RiwayatPemeriksaan":
                                        FieldValue.arrayRemove([riwayat]),
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Riwayat berhasil dihapus"),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Gagal menghapus riwayat: $e"),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
