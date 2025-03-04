import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class RealNameAuthScreen extends StatefulWidget {
  const RealNameAuthScreen({super.key});

  @override
  _RealNameAuthScreenState createState() => _RealNameAuthScreenState();
}

class _RealNameAuthScreenState extends State<RealNameAuthScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  XFile? _ktpFront;
  final double frameWidth = 300;
  final double frameHeight = 180;
  String nik = "Tidak Ditemukan";
  String nama = "Tidak Ditemukan";
  String tanggalLahir = "Tidak Ditemukan";

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(_cameras![0], ResolutionPreset.high, enableAudio: false);
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    if (_cameraController!.value.isTakingPicture) {
      print("Masih memproses foto sebelumnya...");
      return;
    }

    try {
      XFile photo = await _cameraController!.takePicture();
      File savedImage = await _cropAndSaveImage(File(photo.path));

      setState(() {
        _ktpFront = XFile(savedImage.path);
      });

      _cameraController?.dispose(); // Menutup kamera setelah mengambil gambar
      _sendToOCR(savedImage);
    } catch (e) {
      print("Gagal mengambil foto: $e");
    }
  }

  Future<File> _cropAndSaveImage(File imageFile) async {
    img.Image? image = img.decodeImage(await imageFile.readAsBytes());
    if (image == null) return imageFile;

    // Crop area yang sesuai dengan frame
    int startX = (image.width / 2 - frameWidth / 2).toInt();
    int startY = (image.height / 2 - frameHeight / 2).toInt();
    img.Image croppedImage = img.copyCrop(image, x: startX, y: startY, width: frameWidth.toInt(), height: frameHeight.toInt());

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/ktp_cropped_${DateTime.now().millisecondsSinceEpoch}.jpg';
    File croppedFile = File(path)..writeAsBytesSync(img.encodeJpg(croppedImage));

    return croppedFile;
  }

  Future<void> _sendToOCR(File imageFile) async {
    try {
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(imageFile.path, filename: "ktp.jpg"),
      });

      Response response = await Dio().post("http://192.168.1.27:5000/ocr", data: formData);

      print("Response dari server: ${response.data}");

      if (response.statusCode == 200) {
        setState(() {
          nik = response.data['nik'] ?? "Tidak Ditemukan";
          nama = response.data['nama'] ?? "Tidak Ditemukan";
          tanggalLahir = response.data['tanggal_lahir'] ?? "Tidak Ditemukan";
        });
      } else {
        print("Gagal OCR: Status ${response.statusCode}");
      }
    } catch (e) {
      print("Error OCR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Base color dari gambar profil
      appBar: AppBar(
        title: const Text("Verifikasi Identitas"),
        backgroundColor: Colors.blue.shade700, // Warna dari gambar profil
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_ktpFront == null) ...[
              Expanded(
                child: _cameraController == null || !_cameraController!.value.isInitialized
                    ? const Center(child: CircularProgressIndicator())
                    : AspectRatio(
                        aspectRatio: _cameraController!.value.aspectRatio,
                        child: Stack(
                          children: [
                            CameraPreview(_cameraController!),
                            Center(
                              child: Container(
                                width: frameWidth,
                                height: frameHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent, width: 4),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: _capturePhoto,
                child: const Text("Ambil Foto KTP"),
              ),
            ] else ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(File(_ktpFront!.path), width: double.infinity, height: 200, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Data dari KTP:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Divider(),
                      Text("NIK: $nik", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      Text("Nama: $nama", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      Text("Tanggal Lahir: $tanggalLahir", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
