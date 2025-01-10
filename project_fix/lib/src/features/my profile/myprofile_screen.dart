import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_fix/src/features/welcome%20screen/welcome_screen.dart';
import 'first name/firstname_screen.dart';
import 'last name/lastname_screen.dart';
import 'gender/gender_screen.dart';
import 'phone number/phonenumber_screen.dart';
import 'email/email_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  File? _profileImage;

  Future<void> _changeProfileImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_profileImage != null)
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('Lihat Foto'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement view photo
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Image.file(_profileImage!),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Tutup'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Ganti Foto'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement change photo
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Ganti Foto'),
                  content: const Text('Fitur ini akan segera hadir!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
          if (_profileImage != null)
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title:
                  const Text('Hapus Foto', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _profileImage = null;
                });
              },
            ),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text('Batal'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture Section
            GestureDetector(
              onTap: _changeProfileImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('assets/img/gridwiz_logo.jpg')
                            as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _changeProfileImage,
              child: const Text('Ganti Gambar'),
            ),
            const SizedBox(height: 20),

            // Personal Information Section
            _buildInfoField('First Name', 'John'),
            _buildInfoField('Last Name', 'Doe'),
            _buildInfoField('Gender', 'Male'),
            _buildInfoField('Phone Number', '+62 812 3456 7890'),
            _buildInfoField('Email', 'john.doe@example.com'),

            const SizedBox(height: 30),

            // Account Management Section
            _buildActionButton(
              icon: Icons.lock,
              text: 'Change Password',
              onPressed: () {
                // TODO: Implement change password
              },
            ),
            _buildActionButton(
              icon: Icons.security,
              text: 'Authorization Settings',
              onPressed: () {
                // TODO: Implement authorization settings
              },
            ),
            _buildActionButton(
              icon: Icons.logout,
              text: 'Sign Out',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()));
                // TODO: Implement sign out
              },
            ),
            _buildActionButton(
              icon: Icons.delete,
              text: 'Delete Account',
              onPressed: () {
                // TODO: Implement delete account
              },
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return GestureDetector(
      onTap: () {
        switch (label) {
          case 'First Name':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FirstNameScreen()),
            );
            break;
          case 'Last Name':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LastNameScreen()),
            );
            break;
          case 'Gender':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GenderScreen()),
            );
            break;
          case 'Phone Number':
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PhoneNumberScreen()),
            );
            break;
          case 'Email':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EmailScreen()),
            );
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    bool isDestructive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? Colors.red : Colors.blue),
        title: Text(
          text,
          style: TextStyle(
            color: isDestructive ? Colors.red : Colors.black,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onPressed,
      ),
    );
  }
}
