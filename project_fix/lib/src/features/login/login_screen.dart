import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_fix/src/features/landingpage/landing_page.dart';
import 'package:project_fix/src/features/register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool useEmail = false;
  bool obscurePassword = true;
  TextEditingController inputController = TextEditingController();
  bool isChecked = false;
  String activeIcon = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            // Aksi untuk kembali
          },
        ),
        // title: const Text('Pendaftaran Seluler'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/img/gridwiz.jpg', // Ganti dengan path gambar logo Anda
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
                        items: ['+62', '+1', '+44', '+91', '+81'].map((code) {
                          return DropdownMenuItem(
                            value: code,
                            child: Text(code, style: TextStyle(fontSize: 16)),
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
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Silakan masukkan nomor telepon',
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
                        isChecked = !isChecked; // Toggle nilai isChecked
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Lingkaran luar (selalu putih dengan border)
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black),
                            color: Colors.white,
                          ),
                        ),
                        // Lingkaran dalam (biru jika isChecked true, transparan jika false)
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isChecked ? Colors.blue : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 12),
                        children: [
                          TextSpan(
                              text: 'Saya telah membaca dan setuju dengan '),
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
                      MaterialPageRoute(builder: (context) => LandingPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.grey[400],
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
                    child: Text("Daftar", style: TextStyle(color: Colors.blue)),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text("Lupa kata sandi?",
                        style: TextStyle(color: Colors.grey[700])),
                  ),
                ],
              ),
              Spacer(),
              // Login dengan Ikon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: activeIcon == 'phoneEmail'
                              ? Colors.blue
                              : Colors.grey),
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: Icon(
                        useEmail ? Icons.phone : Icons.email,
                        size: 40,
                      ),
                      color: activeIcon == 'phoneEmail'
                          ? Colors.blue
                          : Colors.black,
                      onPressed: () {
                        setState(() {
                          useEmail = !useEmail;
                          activeIcon = 'phoneEmail';
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: activeIcon == 'apple'
                              ? Colors.blue
                              : Colors.grey),
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.apple, size: 40),
                      color: activeIcon == 'apple' ? Colors.blue : Colors.black,
                      onPressed: () {
                        setState(() {
                          activeIcon = 'apple';
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
