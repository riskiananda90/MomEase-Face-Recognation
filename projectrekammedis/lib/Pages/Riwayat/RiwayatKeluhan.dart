import 'package:flutter/material.dart';

class Riwayatkeluhan extends StatefulWidget {
  const Riwayatkeluhan({super.key});

  @override
  State<Riwayatkeluhan> createState() => _RiwayatkeluhanState();
}

class _RiwayatkeluhanState extends State<Riwayatkeluhan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Riwayat keluhan")),
    );
  }
}
