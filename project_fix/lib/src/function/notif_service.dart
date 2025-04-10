import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert'; // Untuk decode Base64

class NotifService {
  static final NotifService _instance = NotifService._internal();
  factory NotifService() => _instance;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotifService._internal();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/reflow'); // Pakai icon custom

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
    String? imageUrl, // URL gambar atau Base64
  }) async {
    NotificationDetails details;

    String? imagePath;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        if (imageUrl.startsWith("http")) {
          // Jika gambar adalah URL
          imagePath = await _downloadAndSaveImage(imageUrl, "notif_image.jpg");
        } else {
          // Jika gambar adalah Base64, decode dan simpan sebagai file
          imagePath = await _saveBase64Image(imageUrl, "notif_base64.jpg");
        }

        print("📸 Menampilkan notifikasi dengan gambar: $imagePath");

        final BigPictureStyleInformation bigPictureStyle =
            BigPictureStyleInformation(
          FilePathAndroidBitmap(imagePath),
          largeIcon: DrawableResourceAndroidBitmap("reflow"),
          contentTitle: title,
          summaryText: body,
        );

        final AndroidNotificationDetails androidDetails =
            AndroidNotificationDetails(
          'popup_channel',
          'Popup Notifications',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
          styleInformation: bigPictureStyle,
        );

        details = NotificationDetails(android: androidDetails);
      } catch (e) {
        print("❌ Gagal menampilkan gambar di notifikasi: $e");

        final AndroidNotificationDetails androidDetails =
            AndroidNotificationDetails(
          'popup_channel',
          'Popup Notifications',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
        );

        details = NotificationDetails(android: androidDetails);
      }
    } else {
      print("📝 Menampilkan notifikasi teks biasa");

      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'popup_channel',
        'Popup Notifications',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
      );

      details = NotificationDetails(android: androidDetails);
    }

    await _notificationsPlugin.show(id, title, body, details);
  }

  // Download gambar dari URL dan simpan ke storage
  Future<String> _downloadAndSaveImage(String url, String fileName) async {
    print("🌍 Sedang mendownload gambar dari: $url");
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("✅ Gambar berhasil didownload!");

      final Uint8List bytes = response.bodyBytes;
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = '${tempDir.path}/$fileName';

      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      print("📂 Gambar disimpan di: $filePath");
      return filePath;
    } else {
      throw Exception("Gagal download gambar dari URL");
    }
  }

  // Decode Base64 ke file gambar dan simpan di storage
  Future<String> _saveBase64Image(String base64Str, String fileName) async {
    print("🖼️ Sedang menyimpan gambar dari Base64...");

    try {
      Uint8List bytes = base64Decode(base64Str);
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = '${tempDir.path}/$fileName';

      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      print("📂 Gambar dari Base64 disimpan di: $filePath");
      return filePath;
    } catch (e) {
      throw Exception("Gagal decode Base64 ke gambar: $e");
    }
  }
}
