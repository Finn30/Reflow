import 'package:flutter/material.dart';
import 'package:testing/src/constant/image_string.dart';
import 'package:testing/src/features/about%20us/aboutus_screen.dart';
import 'package:testing/src/features/car%20guide/carguide_screen.dart';
import 'package:testing/src/features/feedback/feedback_screen.dart';
import 'package:testing/src/features/invite%20friends/invitefriends_screen.dart';
import 'package:testing/src/features/language%20switch/languageswitch_screen.dart';
import 'package:testing/src/features/my%20profile/myprofile_screen.dart';
import 'package:testing/src/features/my%20trip/mytrip_screen.dart';
import 'package:testing/src/features/my%20wallet/mywallet_screen.dart';
import 'package:testing/src/features/user%20manual/usermanual_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gridwiz'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.menu),
              ),
              title: Text('Menu'),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(logo_gridwiz),
                          radius: 30.0,
                        ),
                        SizedBox(width: 16.0),
                        Text(
                          'Kevin',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // UserAccountsDrawerHeader(
                  //   decoration: BoxDecoration(
                  //     color: Colors.blue,
                  //   ),
                  //   accountName: Text('Kevin'),
                  //   accountEmail: null,
                  //   currentAccountPicture: CircleAvatar(
                  //     backgroundImage: AssetImage(logo_gridwiz),
                  //   ),
                  // ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('My Profile'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyProfileScreen()));
                    },
                    trailing: Icon(Icons.chevron_right),
                  ),
                  ListTile(
                    leading: Icon(Icons.luggage),
                    title: Text('My Trip'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyTripScreen()));
                    },
                    trailing: Icon(Icons.chevron_right),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.account_balance_wallet),
                    title: Text('My Wallet'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyWalletScreen()));
                    },
                    trailing: Icon(Icons.chevron_right),
                  ),
                  ListTile(
                    leading: Icon(Icons.menu_book),
                    title: Text('User Manual'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserManualScreen()));
                    },
                    trailing: Icon(Icons.chevron_right),
                  ),
                  ListTile(
                    leading: Icon(Icons.directions_car),
                    title: Text('Car Guide'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CarGuideScreen()));
                    },
                    trailing: Icon(Icons.chevron_right),
                  ),
                  ListTile(
                    leading: Icon(Icons.share),
                    title: Text('Invite Friends'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InviteFriendsScreen()));
                    },
                    trailing: Icon(Icons.chevron_right),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.feedback),
                    title: Text('Feedback'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FeedbackScreen()));
                    },
                    trailing: Icon(Icons.chevron_right),
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('About Us'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutUsScreen()));
                    },
                    trailing: Icon(Icons.chevron_right),
                  ),
                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text('Language Switch'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LanguageSwitchScreen()));
                    },
                    trailing: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Row(
                children: [
                  Image(image: AssetImage(logo_gridwiz), width: 40, height: 40),
                  SizedBox(width: 10),
                  Text(
                    'Gridwiz',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
