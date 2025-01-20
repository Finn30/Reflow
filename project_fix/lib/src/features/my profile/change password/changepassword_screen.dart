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

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async{
                    if (_formKey.currentState!.validate()) {
                      try {
                        await fs.updatePassword(
                          email, _currentPasswordController.text, _newPasswordController.text,
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyProfileScreen(),
                          ),
                        );
                      } catch (e) {
                        print('Error updating user data: $e');
                      }
                    }
                  },
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
    Function(bool) toggleVisibility,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
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
    );
  }
}