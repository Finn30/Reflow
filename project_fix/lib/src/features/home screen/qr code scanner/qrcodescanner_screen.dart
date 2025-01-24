import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QRCodeScannerScreen extends StatefulWidget {
  @override
  _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  String result = "Scan a QR code";
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR'); // Perbaikan key

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera(); // Perbaikan null checking
    }
    controller?.resumeCamera(); // Perbaikan null checking
  }

  void onQRViewCreated(QRViewController qrController) {
    controller = qrController;
    controller?.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData.code ?? "No data found"; // Handle nullable value
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            child: QRView(
              key: qrKey, // Menggunakan key yang sudah diinisialisasi
              onQRViewCreated: onQRViewCreated,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(result),
          ),
        ],
      ),
    );
  }
}
