import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QRViewScreen extends StatefulWidget {
  @override
  _QRViewScreenState createState() => _QRViewScreenState();
}

class _QRViewScreenState extends State<QRViewScreen>
    with WidgetsBindingObserver {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String result = "Scan the QR code on the device to add";

  final List<String> imgList = [
    'assets/img/bicycle.png',
    'assets/img/bicycle.png',
    'assets/img/bicycle.png',
  ];

  int _currentIndex = 0;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      controller?.pauseCamera();
    } else if (state == AppLifecycleState.resumed) {
      controller?.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void onQRViewCreated(QRViewController qrController) {
    controller = qrController;
    controller?.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        controller?.pauseCamera();
        Navigator.pop(context, scanData.code);
      }
      setState(() {
        result = scanData.code ?? "No data found";
      });
    });
  }

  Future<void> toggleFlash() async {
    await controller?.toggleFlash();
    setState(() {});
  }

  Widget buildQrView(double screenWidth) {
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.white,
        borderRadius: 12,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: screenWidth * 0.7,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Scan code', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: BackButton(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Center(child: buildQrView(screenWidth)),
          Positioned(
            top: screenHeight * 0.1,
            left: 0,
            right: 0,
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: screenHeight * 0.15,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  items: imgList
                      .map((item) => Container(
                            width: screenWidth *
                                0.5, // Adjust width for responsiveness
                            height: screenHeight *
                                0.15, // Reduced height for carousel
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                item,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ))
                      .toList(),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => setState(() {
                        _currentIndex = entry.key;
                      }),
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              (Theme.of(context).primaryColorLight).withOpacity(
                            _currentIndex == entry.key ? 0.9 : 0.4,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.3,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                result,
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.1,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
