import 'package:flutter/material.dart';
import 'package:project_fix/src/function/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_fix/src/features/my%20profile/myprofile_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final FirestoreService fs = FirestoreService();
  String email = FirebaseAuth.instance.currentUser!.email!;
  bool _isCurrentPasswordValid = true;
  bool _isNewPasswordValid = true;
  bool _isConfirmPasswordValid = true; // Tambahan untuk validasi warna border

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool validatePassword(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$');
    return regex.hasMatch(password);
  }

  Future<void> _validateAndChangePassword() async {
    bool isPasswordCorrect =
        await fs.checkPassword(email, _currentPasswordController.text);

    if (!isPasswordCorrect) {
      setState(() {
        _isCurrentPasswordValid = false;
      });
      return;
    }

    setState(() {
      _isCurrentPasswordValid = true;
    });

    if (_formKey.currentState!.validate()) {
      if (validatePassword(_newPasswordController.text)) {
        if (_newPasswordController.text == _confirmPasswordController.text) {
          await fs.updatePassword(email, _confirmPasswordController.text);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyProfileScreen()),
          );
        } else {
          _isConfirmPasswordValid = false;
        }
      } else {
        _isNewPasswordValid = false;
      }
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
        title: const Text('Change Password'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildPasswordField(
                'Current Password',
                _currentPasswordController,
                _isCurrentPasswordVisible,
                (value) {
                  setState(() {
                    _isCurrentPasswordVisible = value;
                  });
                },
                isValid: _isCurrentPasswordValid,
                errorMessage: "Password tidak sesuai",
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                'New Password',
                _newPasswordController,
                _isNewPasswordVisible,
                (value) {
                  setState(() {
                    _isNewPasswordVisible = value;
                  });
                },
                isValid: _isNewPasswordValid,
                errorMessage:
                    "Password harus mengandung huruf besar, huruf kecil, dan angka",
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                'Confirm New Password',
                _confirmPasswordController,
                _isConfirmPasswordVisible,
                (value) {
                  setState(() {
                    _isConfirmPasswordVisible = value;
                  });
                },
                isValid: _isConfirmPasswordValid,
                errorMessage: "Password tidak sesuai",
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _validateAndChangePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Change Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String hintText,
    TextEditingController controller,
    bool isVisible,
    Function(bool) toggleVisibility, {
    bool isValid = true,
    String? errorMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isValid
                  ? Colors.transparent
                  : Colors.red, // Ubah warna border jika tidak valid
              width: 2,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                onPressed: () => toggleVisibility(!isVisible),
              ),
            ),
          ),
        ),
        if (!isValid && errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 5),
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
