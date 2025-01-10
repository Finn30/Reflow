import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_fix/src/features/register/password/password_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool useEmail = false;
  TextEditingController inputController = TextEditingController();
  TextEditingController verificationCodeController = TextEditingController();
  bool isChecked = false;
  String? verificationId;
  String? errorMessage; // Menyimpan pesan error untuk ditampilkan
  Timer? _timer;

  void toggleRegisterMethod() {
    setState(() {
      useEmail = !useEmail; // Toggle method
      inputController.clear(); // Clear input
      errorMessage = null; // Reset error message
    });
  }

  Future<void> sendOTP() async {
    setState(() {
      errorMessage = null; // Reset pesan error setiap kali tombol diklik
    });

    if (inputController.text.isEmpty) {
      setState(() {
        errorMessage = 'Harap isi email terlebih dahulu.';
      });
      return;
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(inputController.text)) {
      setState(() {
        errorMessage = 'Format email tidak valid.';
      });
      return;
    }

    if (useEmail) {
      try {
        // Periksa apakah email sudah terdaftar
        final signInMethods = await FirebaseAuth.instance
            .fetchSignInMethodsForEmail(inputController.text);
        if (signInMethods.isNotEmpty) {
          setState(() {
            errorMessage = 'Email sudah terdaftar. Silakan gunakan email lain.';
          });
          return;
        }

        // Lanjutkan dengan pembuatan akun baru
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: inputController.text,
          password: "tempPassword123", // Password sementara
        );
        await FirebaseAuth.instance.currentUser!.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verifikasi email telah dikirim')),
        );

        // Mulai pengaturan timer
        _timer = Timer(Duration(seconds: 30), () async {
          await FirebaseAuth.instance.currentUser!.reload();
          if (!FirebaseAuth.instance.currentUser!.emailVerified) {
            await FirebaseAuth.instance.currentUser!.delete();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Email tidak diverifikasi, akun dihapus')),
            );
          }
        });
      } catch (e) {
        setState(() {
          errorMessage = 'Gagal mengirim verifikasi email: $e';
        });
      }
    }
  }

  Future<void> verifyEmail() async {
    if (useEmail) {
      try {
        await FirebaseAuth.instance.currentUser!.reload();
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verifikasi email berhasil!')),
          );
          _timer?.cancel(); // Hentikan timer jika email diverifikasi
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PasswordScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email belum diverifikasi')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal verifikasi email: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hentikan timer saat widget dihancurkan
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(useEmail ? 'Pendaftaran Email' : 'Pendaftaran Seluler'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!useEmail) buildPhoneInput() else buildEmailInput(),
            const SizedBox(height: 16),
            if (!useEmail) buildOTPInput(),
            if (!useEmail) const SizedBox(height: 16),
            buildAgreement(),
            const SizedBox(height: 16),
            buildSendOtpButton(),
            const SizedBox(height: 16),
            buildNextButton(),
            const Spacer(),
            Center(
              child: TextButton(
                onPressed: toggleRegisterMethod,
                child: Text(
                  useEmail ? 'Pendaftaran Seluler' : 'Pendaftaran Email',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPhoneInput() {
    return Container(
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
                hintText: 'Masukkan nomor telepon',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => inputController.clear(),
          ),
        ],
      ),
    );
  }

  Widget buildEmailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    hintText: 'Masukkan email',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => inputController.clear(),
              ),
            ],
          ),
        ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorMessage!,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget buildOTPInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: verificationCodeController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Masukkan kode verifikasi',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => verificationCodeController.clear(),
          ),
        ],
      ),
    );
  }

  Widget buildAgreement() {
    return Row(
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
              if (isChecked)
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
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
                TextSpan(text: 'Saya setuju dengan '),
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
    );
  }

  Widget buildSendOtpButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: sendOTP,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(useEmail ? 'Verifikasi Email' : 'Kirim OTP'),
      ),
    );
  }

  Widget buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isChecked ? verifyEmail : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isChecked ? Colors.blue : Colors.grey.shade300,
          foregroundColor: isChecked ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text('Langkah Berikutnya'),
      ),
    );
  }
}
