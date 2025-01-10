import 'package:flutter/material.dart';
import 'pricing rules/pricingrules_screen.dart';
import 'fag/fag_screen.dart';
import 'contact us/contactus_screen.dart';

class UserManualScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              'Pricing Rules',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PricingRulesScreen()),
              );
            },
          ),
          Divider(height: 1),
          ListTile(
            title: Text(
              'Contact Us',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactUsScreen()),
              );
            },
          ),
          Divider(height: 1),
          ListTile(
            title: Text(
              'FAQ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FaqScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
