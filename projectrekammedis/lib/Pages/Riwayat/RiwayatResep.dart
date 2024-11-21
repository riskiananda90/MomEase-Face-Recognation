import 'package:flutter/material.dart';

class Riwayatresep extends StatefulWidget {
  const Riwayatresep({super.key});

  @override
  State<Riwayatresep> createState() => _RiwayatresepState();
}

class _RiwayatresepState extends State<Riwayatresep> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Riwayat resep")),
    );
  }
}
