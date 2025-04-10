import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ImageNotifScreen extends StatelessWidget {
  final String paragraph;
  final String? imageUrl;
  final String title;

  const ImageNotifScreen(
      {Key? key, required this.paragraph, this.imageUrl, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (imageUrl != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.memory(
                    base64Decode(imageUrl!)), // Menampilkan gambar jika ada
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MarkdownBody(
                data: paragraph,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(fontSize: 16),
                  strong: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  em: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  blockquote: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey),
                  code: TextStyle(
                      fontSize: 14,
                      backgroundColor: Colors.grey[200],
                      fontFamily: 'monospace'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
