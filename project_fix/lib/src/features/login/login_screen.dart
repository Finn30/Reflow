import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_fix/src/constant/image_string.dart';
import 'package:project_fix/src/features/home%20screen/home_screen.dart';
import 'package:project_fix/src/features/register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool useEmail = false;
  bool obscurePassword = true;
  TextEditingController inputController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isChecked = false;
  String activeIcon = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void login() async {
    try {
      final input = inputController.text.trim();
      final password = passwordController.text;

      if (input.isEmpty || password.isEmpty) {
        showError("Email atau Kata Sandi tidak boleh kosong.");
        return;
      }

      // Mengacu ke koleksi pengguna di Firestore
      final usersCollection = FirebaseFirestore.instance.collection('user');

      // Mencari email dalam database
      final querySnapshot =
          await usersCollection.where('email', isEqualTo: input).get();

      if (querySnapshot.docs.isEmpty) {
        showError("Email tidak terdaftar. Silakan daftar terlebih dahulu.");
        return;
      }

      // Mendapatkan dokumen pertama yang sesuai dengan email
      final userDoc = querySnapshot.docs.first;
      final userData = userDoc.data();

      // Memeriksa kecocokan password
      if (userData['password'] == password) {
        // Jika login berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        showError("Password salah. Silakan coba lagi.");
        return;
      }
    } catch (e) {
      showError("Terjadi kesalahan: $e");
    }
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
          // backgroundColor: Colors.white,
          // foregroundColor: Colors.black,
          // elevation: 0,
          ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Gambar
                          Image(
                            image: AssetImage(gambar_gridwiz),
                            height: 200,
                          ),
                          SizedBox(height: 20),
                          // Input Email atau Telepon
                          if (!useEmail)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  DropdownButton<String>(
                                    value: '+62',
                                    items: ['+62', '+1', '+44', '+91', '+81']
                                        .map((code) {
                                      return DropdownMenuItem(
                                        value: code,
                                        child: Text(code,
                                            style: TextStyle(fontSize: 16)),
                                      );
                                    }).toList(),
                                    onChanged: (value) {},
                                    underline: SizedBox(),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: inputController,
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                      ],
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            'Silakan masukkan nomor telepon',
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      inputController.clear();
                                    },
                                  ),
                                ],
                              ),
                            )
                          else
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: inputController,
                                      keyboardType: TextInputType.emailAddress,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(
                                            RegExp(r'[^a-zA-Z0-9@._-]')),
                                      ],
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Silakan masukkan email',
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      inputController.clear();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 20),
                          // Input Kata Sandi
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              obscureText: obscurePassword,
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTapDown: (_) {
                                    setState(() {
                                      obscurePassword = false;
                                    });
                                  },
                                  onTapUp: (_) {
                                    setState(() {
                                      obscurePassword = true;
                                    });
                                  },
                                  child: Icon(
                                    obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                                border: InputBorder.none,
                                hintText: 'Silakan masukkan kata sandi',
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          // Perjanjian Pengguna
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isChecked = !isChecked;
                                  });
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.black),
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isChecked
                                            ? Colors.blue
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                    children: [
                                      TextSpan(
                                          text:
                                              'Saya telah membaca dan setuju dengan '),
                                      TextSpan(
                                        text: 'Perjanjian Pengguna',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      TextSpan(text: ' dan '),
                                      TextSpan(
                                        text: 'Kebijakan Privasi',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          // Tombol Login
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 15),
                                // backgroundColor: Colors.grey[400],
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              child: Text("Login"),
                            ),
                          ),
                          SizedBox(height: 20),
                          // Register dan Lupa Kata Sandi
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterScreen()),
                                  );
                                },
                                child: Text("Daftar",
                                    style: TextStyle(color: Colors.blue)),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text("Lupa kata sandi?",
                                    style: TextStyle(color: Colors.grey[700])),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Login dengan Ikon
                Container(
                  // color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: activeIcon == 'phone'
                                  ? Colors.blue
                                  : Colors.grey),
                          color: Colors.white,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.phone,
                            size: 40,
                          ),
                          color: activeIcon == 'phone'
                              ? Colors.blue
                              : Colors.black,
                          onPressed: () {
                            setState(() {
                              useEmail = false;
                              activeIcon = 'phone';
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: activeIcon == 'email'
                                  ? Colors.blue
                                  : Colors.grey),
                          color: Colors.white,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.email,
                            size: 40,
                          ),
                          color: activeIcon == 'email'
                              ? Colors.blue
                              : Colors.black,
                          onPressed: () {
                            setState(() {
                              useEmail = true;
                              activeIcon = 'email';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
