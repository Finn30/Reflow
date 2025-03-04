import 'package:flutter/material.dart';

class AuthorizationSettingsScreen extends StatefulWidget {
  @override
  _AuthorizationSettingsScreenState createState() =>
      _AuthorizationSettingsScreenState();
}

class _AuthorizationSettingsScreenState
    extends State<AuthorizationSettingsScreen> {
  bool _googleAuthEnabled = false;
  bool _facebookAuthEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authorization'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            _buildAuthOption(
              icon: Image.asset('assets/img/google.png', width: 24, height: 24),
              title: 'Google',
              value: _googleAuthEnabled,
              onChanged: (bool value) {
                setState(() {
                  _googleAuthEnabled = value;
                });
              },
            ),
            _buildAuthOption(
              icon:
                  Image.asset('assets/img/facebook.png', width: 24, height: 24),
              title: 'Facebook',
              value: _facebookAuthEnabled,
              onChanged: (bool value) {
                setState(() {
                  _facebookAuthEnabled = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthOption({
    required Widget icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              icon,
              SizedBox(width: 12),
              Text(title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: Colors.blue,
            activeColor: Colors.white,
            inactiveTrackColor: Colors.grey[300],
            inactiveThumbColor: Colors.white,
            trackOutlineColor:
                MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.blue;
              }
              return Colors.grey[300];
            }),
          ),
        ],
      ),
    );
  }
}
