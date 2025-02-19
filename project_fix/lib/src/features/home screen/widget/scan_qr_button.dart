import 'package:flutter/material.dart';
import 'package:project_fix/src/features/home%20screen/qr%20code%20scanner/qrcodescanner_screen.dart';

class ScanQRButton extends StatelessWidget {
  const ScanQRButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 100,
      right: 100,
      child: GestureDetector(
        onTap: () async {
          final qrCodeResult = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRCodeScannerScreen()),
          );

          if (qrCodeResult != null) {
            // Tampilkan hasil QR code
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('QR Code: $qrCodeResult')),
            );
          }
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue, // Warna tombol
            borderRadius: BorderRadius.circular(30), // Sudut melengkung
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Warna bayangan
                blurRadius: 6,
                offset: Offset(0, 3), // Arah bayangan
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_scanner, // Ikon QR code
                color: Colors.white,
              ),
              SizedBox(width: 12), // Jarak antara ikon dan teks
              Column(
                children: [
                  Text(
                    'Scan QR code', // Teks tombol
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'to ride', // Teks tombol
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
