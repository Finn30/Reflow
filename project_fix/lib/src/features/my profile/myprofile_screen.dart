import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_fix/src/features/my%20profile/authorization%20settings/authorizationsettings_screen.dart';
import 'package:project_fix/src/features/my%20profile/change%20password/changepassword_screen.dart';
import 'package:project_fix/src/features/my%20profile/delete%20account/deleteaccount_screen.dart';
import 'package:project_fix/src/features/my%20profile/pop%20up/age_popup.dart';
import 'package:project_fix/src/features/my%20profile/pop%20up/fullname_popup.dart';
import 'package:project_fix/src/features/my%20profile/pop%20up/gender_popup.dart';
import 'package:project_fix/src/features/welcome%20screen/welcome_screen.dart';
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
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Data tidak ditemukan.'));
          } else {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            return SingleChildScrollView(
              padding: EdgeInsets.only(top: 0.0),
              child: Column(
                children: [
                  // Profile Picture Section
                  SizedBox(height: 20),
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
                    child: Text(
                      'Click to change photo',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Personal Information Section
                  _buildProfileItem(
                    context,
                    label: 'Full name',
                    value: '${userData['fullName'] ?? ''}',
                    isPopup: true,
                  ),
                  Divider(height: 0, thickness: 1, color: Colors.grey[200]),
                  _buildProfileItem(
                    context,
                    label: 'Gender',
                    value: '${userData['gender'] ?? ''}',
                    isPopup: true,
                  ),
                  _buildProfileItem(
                    context,
                    label: 'Age',
                    value: '${userData['age'] ?? ''}',
                    isPopup: true,
                  ),
                  _buildProfileItem(
                    context,
                    label: 'Phone number',
                    value: '${userData['phone'] ?? ''}',
                  ),
                  Divider(height: 0, thickness: 1, color: Colors.grey[200]),
                  _buildProfileItem(
                    context,
                    label: 'Email',
                    value: '${userData['email'] ?? ''}',
                  ),
                  SizedBox(height: 10),
                  _buildProfileItem(
                    context,
                    label: 'Nationality',
                    value: '',
                  ),
                  Divider(height: 0, thickness: 1, color: Colors.grey[200]),
                  _buildProfileItem(
                    context,
                    label: 'Vehicle ownership',
                    value: '',
                  ),
                  Divider(height: 0, thickness: 1, color: Colors.grey[200]),
                  _buildProfileItem(
                    context,
                    label: 'Real-name authentication',
                    value: 'Unknown',
                  ),
                  SizedBox(height: 10),
                  Divider(height: 0, thickness: 1, color: Colors.grey[200]),
                  SizedBox(height: 10),
                  _buildProfileItem(
                    context,
                    label: 'Change Password',
                    value: '',
                  ),
                  Divider(height: 0, thickness: 1, color: Colors.grey[200]),
                  _buildProfileItem(
                    context,
                    label: 'Authorization',
                    value: '',
                  ),
                  SizedBox(height: 10),

                  Container(
                    color: Colors.white,
                    child: ListTile(
                      title: const Center(
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Sign Out'),
                            content: const Text(
                                'Are you sure you want to sign out?'),
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
                  ),
                  SizedBox(height: 10),
                  Container(
                    color: Colors.white,
                    child: ListTile(
                      title: const Center(
                        child: Text(
                          'Delete Account',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeleteAccountScreen()),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context,
      {required String label, required String value, bool isPopup = false}) {
    return InkWell(
      onTap: () {
        if (isPopup) {
          switch (label) {
            case 'Full name':
              fullNamePopUp(context, value);
              break;
            case 'Gender':
              genderPopUp(context);
              break;
            case 'Age':
              agePopUp(context, value);
              setState(() {});
              break;
          }
        } else {
          switch (label) {
            case 'Phone number':
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
            case 'Nationality':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmailScreen()),
              );
              break;
            case 'Vehicle ownership':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmailScreen()),
              );
              break;
            case 'Real-name authentication':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmailScreen()),
              );
              break;
            case 'Change Password':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChangePasswordScreen()),
              );
              break;
            case 'Authorization':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AuthorizationSettingsScreen()),
              );
              break;
          }
        }
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
