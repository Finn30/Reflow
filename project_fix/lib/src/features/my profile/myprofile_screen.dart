import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_fix/src/features/home%20screen/home_screen.dart';
import 'package:project_fix/src/features/my%20profile/authorization%20settings/authorizationsettings_screen.dart';
import 'package:project_fix/src/features/my%20profile/change%20password/changepassword_screen.dart';

import 'package:project_fix/src/features/my%20profile/delete%20account/deleteaccount_screen.dart';
import 'package:project_fix/src/features/welcome%20screen/welcome_screen.dart';
import 'first name/firstname_screen.dart';
import 'last name/lastname_screen.dart';
import 'gender/gender_screen.dart';
import 'phone number/phonenumber_screen.dart';
import 'email/email_screen.dart';
import 'package:project_fix/src/function/services.dart';
import 'package:image_picker/image_picker.dart';

class MyProfileScreen extends StatefulWidget {
  MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  File? _profileImage;
  FirestoreService fs = FirestoreService();
  String email = FirebaseAuth.instance.currentUser!.email!;
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
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Ganti Foto'),
                  actions: [
                    TextButton(
                      onPressed: changeProfileImage,
                      child: const Text('Pilih dari Galeri'),
                    ),
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

  Future<void> changeProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path); // Memperbarui gambar profil
          try {
            String fileName = pickedFile.path;
            fs.changeProfilPicture(email, fileName).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Gambar profil berhasil diperbarui.')),
              );
            });
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Terjadi kesalahan: $e')),
            );
          }
        });
      } else {
        // Jika tidak ada gambar yang dipilih
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak ada gambar yang dipilih.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile '),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fs.loadUser(email).then((value) => value ?? {}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Data tidak ditemukan.'));
          } else {
            var userData = snapshot.data!;
            return SingleChildScrollView(
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
                              : FileImage(File(userData['pictUrl'])),
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
                  _buildInfoField('Full name', '${userData['firstName']}'),
                  _buildInfoField('Gender', '${userData['gender']}'),
                  _buildInfoField('Age', '50'),
                  _buildInfoField('Phone Number', '${userData['phone']}'),
                  _buildInfoField('Email', '${userData['email']}'),
                  _buildInfoField('Nationality', 'Indonesia'),
                  _buildInfoField('Vehicle Ownership', 'Motorcycle/Gasoline'),
                  _buildActionButton(
                    text: 'Real-Name authentication',
                    icon: Icons.verified_user,
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePasswordScreen()),
                      );

                    }, 
                  ),

                  

                  const SizedBox(height: 5),

                  // Account Management Section
                  _buildActionButton(
                    icon: Icons.lock,
                    text: 'Change Password',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePasswordScreen()),
                      );
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.security,
                    text: 'Authorization Settings',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AuthorizationSettingsScreen()),
                      );
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.logout,
                    text: 'Sign Out',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Sign Out'),
                          content:
                              const Text('Are you sure you want to sign out?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                fs.signOut();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WelcomeScreen()),
                                );
                              },
                              child: const Text('Sign Out'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.delete,
                    text: 'Delete Account',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeleteAccountScreen()),
                      );
                    },
                    isDestructive: true,
                  ),
                ],
              ),
            );
          }
        },
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

