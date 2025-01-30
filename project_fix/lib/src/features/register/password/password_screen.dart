import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_fix/src/features/register/password/username/username_screen.dart';
import 'package:project_fix/src/function/services.dart';

class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final FirestoreService fs = FirestoreService();
  final currentUser = FirebaseAuth.instance.currentUser;

  // Fungsi untuk validasi password
  bool validatePassword(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$');
    return regex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildPasswordField('Silakan masukkan password', passwordController,
                isPasswordVisible, (value) {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            }),
            const SizedBox(height: 16),
            _buildPasswordField('Silakan masukkan konfirmasi password',
                confirmPasswordController, isConfirmPasswordVisible, (value) {
              setState(() {
                isConfirmPasswordVisible = !isConfirmPasswordVisible;
              });
            }),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
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
                              'Password harus minimal 6 karakter dengan kombinasi huruf besar, huruf kecil, dan angka tanpa symbol.')),
                    );
                    return;
                  }

                  if (password != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password tidak cocok')),
                    );
                    return;
                  }
                  if (currentUser != null) {
                    await currentUser?.updatePassword(password);
                    await fs.addUsertoFirestore(confirmPassword);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UsernameScreen()), // Updated navigation
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal memperbarui password')),
                    );
                    return;
                  }
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

  Widget _buildPasswordField(String hintText, TextEditingController controller,
      bool isVisible, Function(bool) toggleVisibility) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () => toggleVisibility(isVisible),
          ),
        ),
      ),
    );
  }
}
