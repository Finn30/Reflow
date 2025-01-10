import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_fix/src/features/login/login_screen.dart';

class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  // Fungsi untuk validasi password
  bool validatePassword(String password) {
    final regex = RegExp(r'^(?=.[a-z])(?=.[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$');
    return regex.hasMatch(password);
  }

  Future<void> updatePassword() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Update password pengguna
        await currentUser.updatePassword(passwordController.text);

        // Tambahkan data baru ke Firestore
        DocumentReference userDoc = FirebaseFirestore.instance
            .collection('user')
            .doc(currentUser.uid);
            Map<String, dynamic> data = {
              'email': currentUser.email,
              'password': passwordController.text,
            };
        userDoc.set(data).whenComplete(() {
          print('Data berhasil ditambahkan ke Firestore');
        });
        await FirebaseAuth.instance.signOut();

        // Beralih ke halaman login setelah berhasil membuat password
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password berhasil diperbarui! Silakan login.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui password: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Buat Password'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Silakan masukkan password',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: confirmPasswordController,
                obscureText: !isConfirmPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Silakan masukkan konfirmasi password',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final password = passwordController.text;
                  final confirmPassword = confirmPasswordController.text;

                  if (password.isEmpty || confirmPassword.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password tidak boleh kosong')),
                    );
                    return;
                  }

                  if (!validatePassword(password)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Password harus minimal 6 karakter dengan kombinasi huruf besar, huruf kecil, dan angka.')),
                    );
                    return;
                  }

                  if (password != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password tidak cocok')),
                    );
                    return;
                  }

                  updatePassword();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Buat Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}