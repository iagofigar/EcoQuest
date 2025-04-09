import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QRCodeScreen extends StatelessWidget {
  final String userId;

  const QRCodeScreen({this.userId = '0', super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'EcoQuest',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: PrettyQr(
          data: userId,
          size: 360.0,
          roundEdges: false,
        ),
      ),
    );
  }
}