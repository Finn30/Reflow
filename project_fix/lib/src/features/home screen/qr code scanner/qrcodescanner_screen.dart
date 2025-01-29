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
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  void onQRViewCreated(QRViewController qrController) {
    controller = qrController;
    controller?.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData.code ?? "No data found"; // Handle nullable value
      });
    });
  }

  Future<void> toggleFlash() async {
    await controller?.toggleFlash();
    setState(() {});
  }

  Future<void> flipCamera() async {
    await controller?.flipCamera();
    setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget buildQrView() {
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.white,
        borderRadius: 12,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 250, // Adjusted size for better scanning
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Scan QR code', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: BackButton(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Center(child: buildQrView()), // Kotak scanner
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  // Tempat gambar di atas kotak scanner
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withOpacity(0.8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/img/gridwiz.jpg', // Ganti dengan path gambar Anda
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 270,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Menampilkan hasil scan
                Text(
                  result,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle vehicle number display
                      },
                      child: Text(
                        '1234',
                        style: TextStyle(color: Colors.blue),
                      ), // Example vehicle number
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                      ),
                    ),
                    Text(
                      'Vehicle number',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: toggleFlash,
                      child: Icon(Icons.flashlight_on, color: Colors.blue),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                      ),
                    ),
                    Text(
                      'Flashlight',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                // Column(
                //   children: [
                //     ElevatedButton(
                //       onPressed: flipCamera,
                //       child:
                //           Icon(Icons.flip_camera_android, color: Colors.blue),
                //       style: ElevatedButton.styleFrom(
                //         shape: CircleBorder(),
                //         padding: EdgeInsets.all(20),
                //       ),
                //     ),
                //     Text(
                //       'Flip Camera',
                //       style: TextStyle(color: Colors.white, fontSize: 12),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
