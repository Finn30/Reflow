import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_fix/src/features/register/password_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool useEmail = false;
  TextEditingController inputController = TextEditingController();
  TextEditingController verificationCodeController = TextEditingController();
  bool isChecked = false;

  void toogleRegisterMethod() {
    setState(() {
      useEmail = !useEmail; // Toggle nilai useEmail
      inputController.clear(); // Bersihkan input
    });
  }

  void sendVerificationCode() {
    // Tambahkan logika pengiriman kode verifikasi di sini
    print('Kode verifikasi dikirim ke ${inputController.text}');
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
        title: Text(useEmail ? 'Pendaftaraan Email' : 'Pendaftaran Seluler'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: verificationCodeController,
                      decoration: InputDecoration(
                        hintText: 'Silakan masukkan kode verifikasi...',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      sendVerificationCode();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('Mengirim'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
                        TextSpan(text: 'Saya telah membaca dan setuju dengan '),
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
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PasswordScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Langkah Berikutnya'),
              ),
            ),
            const Spacer(),
            Center(
              child: TextButton(
                onPressed: () {
                  toogleRegisterMethod();
                },
                child:
                    Text(useEmail ? 'Pendaftaan Seluler' : 'Pendaftaran Email'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
