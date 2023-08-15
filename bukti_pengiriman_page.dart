import 'package:flutter/material.dart';

class BuktiPengirimanPage extends StatelessWidget {
  const BuktiPengirimanPage({super.key, required this.bukti_pembayaran});
  final String bukti_pembayaran;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bukti Pengiriman"),
      ),
      body: Image.network(bukti_pembayaran),
    );
  }
}
