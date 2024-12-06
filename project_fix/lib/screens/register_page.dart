import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Vehicle number',
                hintText: 'Please enter the vehicle number',
                suffixIcon: Icon(Icons.qr_code_scanner),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Invitation code (optional)',
                suffixIcon: ElevatedButton(
                  onPressed: () {},
                  child: Text('Check'),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'If you download this APP through a friend\'s invitation...',
              style: TextStyle(fontSize: 12),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                // Handle next step
              },
              child: Text('Next step'),
            ),
          ],
        ),
      ),
    );
  }
}
