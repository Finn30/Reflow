import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../landingpage/landing_page.dart';
import 'password_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool useEmail = false;
  TextEditingController inputController = TextEditingController();
  TextEditingController passwordController = TextEditingController();  // Password controller
  TextEditingController verificationCodeController = TextEditingController();
  bool isChecked = false;
  String? verificationId;

  void toggleRegisterMethod() {
    setState(() {
      useEmail = !useEmail; // Toggle method
      inputController.clear(); // Clear input
      passwordController.clear(); // Clear password input if switching to email
    });
  }

  Future<void> sendOTP() async {
    if (!useEmail) {
      // Phone number verification logic
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+62${inputController.text}',
          verificationCompleted: (PhoneAuthCredential credential) async {
            await FirebaseAuth.instance.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal verifikasi: ${e.message}')),
            );
          },
          codeSent: (String verificationId, int? resendToken) {
            setState(() {
              this.verificationId = verificationId;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Kode OTP telah dikirim')),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            this.verificationId = verificationId;
          },
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim kode: $e')),
        );
      }
    } else {
      // Email verification logic
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: inputController.text,
          password: passwordController.text,
        );
        await FirebaseAuth.instance.currentUser!.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verifikasi email telah dikirim')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim verifikasi email: $e')),
        );
      }
    }
  }

  Future<void> verifyCode() async {
    if (verificationId != null && !useEmail) {
      // Phone verification
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId!,
          smsCode: verificationCodeController.text,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verifikasi berhasil!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PasswordScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kode salah: $e')),
        );
      }
    } else if (useEmail) {
      try {
        await FirebaseAuth.instance.currentUser!.reload();
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verifikasi email berhasil!')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LandingPage()),
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
            useEmail
                ? buildPasswordInput()  // Show password input when using email
                : TextField(
                    controller: verificationCodeController,
                    decoration: InputDecoration(
                      fillColor: Colors.grey[200],
                      hintText: 'Masukkan kode OTP...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
            const SizedBox(height: 16),
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
              controller: inputController,
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'[^a-zA-Z0-9@._-]')),
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
    );
  }

  Widget buildPasswordInput() {
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
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Masukkan password',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => passwordController.clear(),
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
        onPressed: isChecked ? verifyCode : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text('Langkah Berikutnya'),
      ),
    );
  }
}