import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_fix/src/function/services.dart';

void fullNamePopUp(BuildContext context, String value) {
  final FirestoreService fs = FirestoreService();
  final String email = FirebaseAuth.instance.currentUser!.email!;
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController(text: value);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = MediaQuery.of(context).size.width;
          double dialogWidth = screenWidth * 0.85; // 85% dari lebar layar
          double buttonHeight = 50;

          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: Colors.white, // Background putih sesuai gambar
                child: Container(
                  width: screenWidth,
                  padding:
                      EdgeInsets.all(screenWidth * 0.05), // Padding dinamis
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header dengan judul dan tombol close
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Center(
                            child: Text(
                              "Change the name",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          )),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(Icons.close, size: 24),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Input field dengan border bulat
                      Form(
                        key: _formKey,
                        child: Container(
                          width: dialogWidth * 0.9, // 90% dari dialog width
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextFormField(
                            controller: _textController,
                            textAlign: TextAlign.center,
                            maxLength: 20, // Batas maksimum karakter
                            onChanged: (text) {
                              setState(
                                  () {}); // Update UI saat pengguna mengetik
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 12),
                              counterText:
                                  "", // Hilangkan counter bawaan Flutter
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Menampilkan jumlah karakter secara real-time
                      Text(
                        "${_textController.text.length}/20",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),

                      // Tombol Confirm yang responsif
                      SizedBox(
                        width: dialogWidth * 0.9, // 90% dari dialog width
                        height: buttonHeight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await fs.updateFullname(
                                  email, _textController.text);
                              Navigator.pop(context, _textController.text);
                            }
                          },
                          child: const Text(
                            "Confirm",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}
