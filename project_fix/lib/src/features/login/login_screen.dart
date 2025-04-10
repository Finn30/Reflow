import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_fix/src/constant/image_string.dart';
import 'package:project_fix/src/features/home%20screen/home_screen.dart';
import 'package:project_fix/src/features/login/lupa%20kata%20sandi/lupakatasandi_screen.dart';
import 'package:project_fix/src/features/my%20profile/real-name%20authentication/real-nameauth_screen.dart';
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

  // void login() async {
  //   try {
  //     final input = inputController.text.trim();
  //     final password = passwordController.text;

  //     if (input.isEmpty || password.isEmpty) {
  //       showError("Email atau Kata Sandi tidak boleh kosong.");
  //       return;
  //     }
  //     final usersCollection = FirebaseFirestore.instance.collection('user');
  //     final querySnapshot =
  //         await usersCollection.where('email', isEqualTo: input).get();

  //     if (querySnapshot.docs.isEmpty) {
  //       showError("Email tidak terdaftar. Silakan daftar terlebih dahulu.");
  //       return;
  //     }
  //     final userDoc = querySnapshot.docs.first;
  //     final userData = userDoc.data();
  //     final hashedCurrPassword =
  //         sha256.convert(utf8.encode(password)).toString();

  //     // Memeriksa kecocokan password
  //     if (userData['password'] == hashedCurrPassword) {
  //       await _auth.signInWithEmailAndPassword(
  //         email: input,
  //         password: password,
  //       );
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => HomeScreen()),
  //       );
  //     } else {
  //       showError("Password salah. Silakan coba lagi.");
  //       return;
  //     }
  //   } catch (e) {
  //     showError("Terjadi kesalahan: $e");
  //   }
  // }

  void login() async {
    try {
      final input = inputController.text.trim();
      final password = passwordController.text;

      if (input.isEmpty || password.isEmpty) {
        showError("Email atau Kata Sandi tidak boleh kosong.");
        return;
      }

      final usersCollection = FirebaseFirestore.instance.collection('user');
      final querySnapshot =
          await usersCollection.where('email', isEqualTo: input).get();

      if (querySnapshot.docs.isEmpty) {
        showError("Email tidak terdaftar. Silakan daftar terlebih dahulu.");
        return;
      }

      final userDoc = querySnapshot.docs.first;
      final userData = userDoc.data();
      final hashedCurrPassword =
          sha256.convert(utf8.encode(password)).toString();

      if (userData['password'] == hashedCurrPassword) {
        await _auth.signInWithEmailAndPassword(
            email: input, password: password);

        // Cek apakah pengguna sudah memilih Student/Public sebelumnya
        if (userData.containsKey('userType')) {
          navigateBasedOnUserType(
              userData['userType'], userData['bindingID'] ?? false);
        } else {
          showUserTypeDialog(userDoc.id);
        }
      } else {
        showError("Password salah. Silakan coba lagi.");
      }
    } catch (e) {
      showError("Terjadi kesalahan: $e");
    }
  }

  void showUserTypeDialog(String userId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          icon: Icon(Icons.person, color: Colors.black, size: 50),
          title: Text("Select User Type"),
          backgroundColor: Colors.white,
          content: Text(
            "Please select whether you are Student or Public.",
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      saveUserTypeAndNavigate(userId, 'student', true);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: Size(0, 50)),
                    child: Text(
                      "Student",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showBindingIDDialog(userId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: Size(0, 50),
                    ),
                    child: Text(
                      "Public",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void showBindingIDDialog(String userId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          icon: Icon(Icons.card_membership, color: Colors.black, size: 50),
          title: Text("Binding ID Card"),
          content:
              Text("Do you want to bind ID card?", textAlign: TextAlign.center),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      saveUserTypeAndNavigate(userId, 'public', true);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: Size(0, 50)),
                    child: Text(
                      "Yes",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      saveUserTypeAndNavigate(userId, 'public', false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: Size(0, 50),
                    ),
                    child: Text(
                      "No",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // TextButton(
            //   onPressed: () {
            //     saveUserTypeAndNavigate(userId, 'public', true);
            //   },
            //   child: Text("Ya"),
            // ),
            // TextButton(
            //   onPressed: () {
            //     saveUserTypeAndNavigate(userId, 'public', false);
            //   },
            //   child: Text("Tidak"),
            // ),
          ],
        );
      },
    );
  }

  void saveUserTypeAndNavigate(
      String userId, String userType, bool bindingID) async {
    await FirebaseFirestore.instance.collection('user').doc(userId).update({
      'userType': userType,
      'bindingID': bindingID,
    });

    navigateBasedOnUserType(userType, bindingID);
  }

  void navigateBasedOnUserType(String userType, bool bindingID) {
    if (userType == 'student' || (userType == 'public' && bindingID)) {
      Navigator.pushReplacement(
          context,
          // MaterialPageRoute(builder: (context) => RealNameAuthScreen()));
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
                            image: AssetImage(welcomeLogoWhite),
                            height: 200,
                            width: 220,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 10),
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
                                            style: TextStyle(fontSize: 12)),
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
                                        hintStyle: TextStyle(
                                          fontSize:
                                              12, // Ukuran font lebih kecil untuk hint text
                                          color: Colors.grey[
                                              650], // Warna hint text lebih lembut
                                        ),
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
                                        hintStyle: TextStyle(
                                          fontSize:
                                              12, // Ukuran font lebih kecil untuk hint text
                                          color: Colors.grey[
                                              650], // Warna hi
                                      ),
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
                          SizedBox(height: 10),
                          // Input Kata Sandi
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: obscurePassword,
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
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
                                hintStyle: TextStyle(
                                          fontSize:
                                              12, // Ukuran font lebih kecil untuk hint text
                                          color: Colors.grey[
                                              650], // Warna hi
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
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
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: isChecked
                                                ? Colors.blue
                                                : Colors.grey),
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      width: 12,
                                      height: 12,
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
                          SizedBox(height: 10),
                          // Tombol Login
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isChecked ? login : null,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 15),
                                // backgroundColor: Colors.grey[400],
                                backgroundColor:
                                    isChecked ? Colors.blue : Colors.grey[400],
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
                                    style: TextStyle(color: Colors.blue, fontSize: 12), ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LupaKataSandiScreen()),
                                  );
                                },
                                child: Text("Lupa kata sandi?",
                                    style: TextStyle(color: Colors.grey[700], fontSize: 12)),
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
                            size: 25,
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
                            size: 25,
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
