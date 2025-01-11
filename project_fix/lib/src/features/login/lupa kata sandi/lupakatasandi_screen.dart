import 'package:flutter/material.dart';
import 'package:project_fix/src/features/login/lupa%20kata%20sandi/reset%20password/resetpassword_screen.dart';

class LupaKataSandiScreen extends StatelessWidget {
  LupaKataSandiScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lupa Kata Sandi'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Masukkan alamat email Anda untuk mengatur ulang kata sandi.',
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity, // Make the button full width
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: Size(300, 50),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResetPasswordScreen()));
                },
                child: Text('Kirim'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
