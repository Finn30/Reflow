import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenuScreen(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        children: [
          _buildProfileSection(),
          Divider(),
          _buildMenuItem(Icons.person_outline, "My Profile"),
          _buildMenuItem(Icons.directions_car, "My Trip"),
          _buildMenuItem(Icons.account_balance_wallet_outlined, "My Wallet"),
          _buildMenuItem(Icons.menu_book_outlined, "User Manual"),
          _buildMenuItem(Icons.directions_car_outlined, "Car Guide"),
          _buildMenuItem(Icons.group_outlined, "Invite Friends"),
          Divider(),
          _buildMenuItem(Icons.feedback_outlined, "Feedback"),
          _buildMenuItem(Icons.info_outline, "About Us"),
          _buildMenuItem(Icons.language_outlined, "Language Switch"),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Gridwiz",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.directions_bike_outlined),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage:
              AssetImage('assets/profile.jpg'), // Ganti dengan gambar Anda
          radius: 30.0,
        ),
        SizedBox(width: 10.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ajem",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "14.03", // Sesuaikan data sesuai kebutuhan
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Tambahkan aksi untuk masing-masing item
      },
    );
  }
}
