import 'package:flutter/material.dart';
import 'package:project_fix/src/constant/image_string.dart';
import 'package:project_fix/src/features/login/login_screen.dart';
import 'package:project_fix/src/features/register/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan lebar layar perangkat
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade400, Colors.blue.shade900],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Gambar Logo
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Image(image: AssetImage(gambarAppWhite)),
                    ),
                    // SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(right: 140.0),
                      child: Text(
                        'By: Gridwiz E&M',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                // Tombol Login dan Daftar
                Column(
                  children: [
                    // Tombol Login
                    Container(
                      width: screenWidth < 412
                          ? 300
                          : screenWidth *
                              0.8, // Menyesuaikan lebar tombol, minimal 300px
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          minimumSize: Size(
                              screenWidth < 412 ? 300 : screenWidth * 0.8, 50),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text('Login'),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Tombol Daftar
                    Container(
                      width: screenWidth < 412
                          ? 300
                          : screenWidth *
                              0.8, // Menyesuaikan lebar tombol, minimal 300px
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          minimumSize: Size(
                              screenWidth < 412 ? 300 : screenWidth * 0.8, 50),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()));
                        },
                        child: Text('Daftar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
