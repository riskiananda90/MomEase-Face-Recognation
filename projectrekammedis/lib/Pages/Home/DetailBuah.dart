import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Component/AppColor.dart';

class Detailbuah extends StatelessWidget {
  const Detailbuah(
      {super.key,
      required this.title,
      required this.gambar,
      required this.deskripsi});
  final String title;
  final String gambar;
  final String deskripsi;

  Future<void> _loadImage(BuildContext context) async {
    await precacheImage(AssetImage(gambar), context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadImage(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Appcolor.textPrimary,
              color: Appcolor.Primary,
            ),
          );
        } else if (snapshot.hasError) {
          return Text("Tidak bisa load image");
        } else {
          return AlertDialog(
            backgroundColor: Appcolor.Primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      gambar,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    deskripsi,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      _buildTimeTag("Pagi"),
                      SizedBox(
                        width: 10,
                      ),
                      _buildTimeTag("Siang"),
                      SizedBox(
                        width: 10,
                      ),
                      _buildTimeTag("Malam"),
                    ],
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

Widget _buildTimeTag(String text) {
  return Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Appcolor.textPrimary.withOpacity(0.7),
      boxShadow: [
        BoxShadow(
          blurRadius: 5,
          offset: Offset(1, 3),
          color: Colors.grey,
        ),
      ],
    ),
    child: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
    ),
  );
}
