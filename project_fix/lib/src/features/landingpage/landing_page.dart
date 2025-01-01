import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Landing Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Kevin'),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/profile.jpg'), // Ganti dengan gambar profil Anda
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('My Profile'),
              onTap: () {
                // Navigasi ke halaman profil
              },
            ),
            ListTile(
              leading: Icon(Icons.trip_origin),
              title: Text('My Trip'),
              onTap: () {
                // Navigasi ke halaman trip
              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('My Wallet'),
              onTap: () {
                // Navigasi ke halaman wallet
              },
            ),
            ListTile(
              leading: Icon(Icons.menu_book),
              title: Text('User Manual'),
              onTap: () {
                // Navigasi ke halaman user manual
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text('Car Guide'),
              onTap: () {
                // Navigasi ke halaman car guide
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Invite Friends'),
              onTap: () {
                // Navigasi ke halaman invite friends
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedback'),
              onTap: () {
                // Navigasi ke halaman feedback
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About Us'),
              onTap: () {
                // Navigasi ke halaman about us
              },
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Language Switch'),
              onTap: () {
                // Navigasi ke halaman language switch
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Welcome to Landing Page'),
      ),
    );
  }
}
