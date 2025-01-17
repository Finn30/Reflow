import 'package:flutter/material.dart';

class AuthorizationSettingsScreen extends StatefulWidget {
  @override
  _AuthorizationSettingsScreenState createState() =>
      _AuthorizationSettingsScreenState();
}

class _AuthorizationSettingsScreenState
    extends State<AuthorizationSettingsScreen> {
  bool _notificationsEnabled = true; // Initial state for notifications
  bool _locationAccessEnabled = false; // Initial state for location access

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authorization Settings'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
              activeColor: Colors.blue,
              // inactiveTrackColor: Colors.grey,
              // inactiveThumbColor: Colors.black,
            ),
            SwitchListTile(
              title: Text('Location Access'),
              value: _locationAccessEnabled,
              onChanged: (bool value) {
                setState(() {
                  _locationAccessEnabled = value;
                });
              },
              activeColor: Colors.blue,
              // inactiveTrackColor: Colors.white,
              // inactiveThumbColor: Colors.white,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle save action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
