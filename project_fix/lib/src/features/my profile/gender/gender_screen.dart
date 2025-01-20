import 'package:flutter/material.dart';
import 'package:project_fix/src/function/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_fix/src/features/my%20profile/myprofile_screen.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String? _selectedGender;
  final FirestoreService fs = FirestoreService();
  String email = FirebaseAuth.instance.currentUser!.email!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Gender'),
        actions: [
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            onPressed: () async {
              if (_selectedGender != null) {
                try {
                  await fs.updateGender(email, _selectedGender!);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyProfileScreen()));
                } catch (e) {
                  print("Error updating user data: $e");
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            RadioListTile<String>(
              title: const Text('Male'),
              value: 'Male',
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Female'),
              value: 'Female',
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Other'),
              value: 'Other',
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}