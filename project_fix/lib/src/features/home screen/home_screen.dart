import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_fix/src/constant/image_string.dart';
import 'package:project_fix/src/constant/text_string.dart';
import 'package:project_fix/src/features/home%20screen/qr%20code%20scanner/qrcodescanner_screen.dart';
import 'package:project_fix/src/features/home%20screen/widget/ride_menu.dart';
import 'package:project_fix/src/features/home%20screen/widget/scan_qr_button.dart';
import 'package:project_fix/src/features/home%20screen/widget/vehicle_menu.dart';
import 'package:project_fix/src/function/services.dart';
import 'package:project_fix/src/features/about us/aboutus_screen.dart';
import 'package:project_fix/src/features/car guide/carguide_screen.dart';
import 'package:project_fix/src/features/feedback/feedback_screen.dart';
import 'package:project_fix/src/features/invite friends/invitefriends_screen.dart';
import 'package:project_fix/src/features/language switch/languageswitch_screen.dart';
import 'package:project_fix/src/features/my profile/myprofile_screen.dart';
import 'package:project_fix/src/features/my trip/mytrip_screen.dart';
import 'package:project_fix/src/features/my wallet/mywallet_screen.dart';
import 'package:project_fix/src/features/user manual/usermanual_screen.dart';
import 'package:project_fix/src/provider/vehicle_provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirestoreService fs = FirestoreService();

  String email = '';
  bool showRideMenu = false;
  String? selectedVehicle;

  final LatLng initialPosition =
      const LatLng(-8.586705728515044, 116.09220835292544); // Default location
  late GoogleMapController mapController;

  LatLng currentPosition =
      const LatLng(-8.586705728515044, 116.09220835292544); // Default
  bool isLocationEnabled = false;
  Set<Marker> markers = {};

  @override
  void initState() {
    _getUserLocation();
    super.initState();
    email = auth.currentUser!.email!;
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          isLocationEnabled = false;
          currentPosition = initialPosition; // Use default location
          _addMarker(currentPosition, "Your Location");
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          setState(() {
            isLocationEnabled = false;
            currentPosition = initialPosition; // Use default location
            _addMarker(currentPosition, "Your Location");
          });
          return;
        }
      }

      // Get current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        isLocationEnabled = true;
        currentPosition = LatLng(position.latitude, position.longitude);
        _addMarker(currentPosition, "Your Location");
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLocationEnabled = false;
        currentPosition = initialPosition; // Use default location
        _addMarker(currentPosition, "Your Location");
      });
    }
  }

  void _addMarker(LatLng position, String title) {
    setState(() {
      markers.add(Marker(
        markerId: MarkerId(title),
        position: position,
        infoWindow: InfoWindow(title: title),
      ));
    });
  }

  void _selectVehicle(String vehicle) {
    setState(() {
      selectedVehicle = vehicle;
      showRideMenu = true;
    });
  }

  void _closeRideMenu() {
    setState(() {
      showRideMenu = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.black,
            onPressed: () {
              _getUserLocation();
            },
          ),
        ],
        title: Text("Start your ride"),
        centerTitle: true,
      ),
      drawer: FutureBuilder<Map<String, dynamic>>(
        future: fs.loadUser(email).then((value) => value ?? {}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Drawer(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Drawer(
              child: Center(
                child: Text('Error loading user data'),
              ),
            );
          } else if (!snapshot.hasData) {
            return Drawer(
              child: Center(
                child: Text('User not found'),
              ),
            );
          } else {
            var userData = snapshot.data!;
            return Drawer(
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
                                backgroundImage: FileImage(
                                    File(userData['pictUrl'] ?? logoApp)),
                                radius: 30.0,
                              ),
                              SizedBox(width: 16.0),
                              Text(
                                '${userData['firstName'] ?? null} ${userData['lastName'] ?? null}',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                    builder: (context) =>
                                        InviteFriendsScreen()));
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
                                    builder: (context) =>
                                        LanguageSwitchScreen()));
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
                        Image(
                            image: AssetImage(logoApp), width: 40, height: 40),
                        SizedBox(width: 10),
                        Text(
                          tAppName,
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
            );
          }
        },
      ),
      body: Consumer<VehicleNumberProvider>(
        builder: (context, vehicleProvider, child) {
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentPosition,
                  zoom: 14,
                ),
                markers: markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
              ),
              vehicleProvider.isVehicleNumberValid
                  ? (showRideMenu && selectedVehicle != null
                      ? RideMenu(
                          selectedVehicle: selectedVehicle!,
                          onClose: _closeRideMenu,
                        )
                      : VehicleMenu(onVehicleSelected: _selectVehicle))
                  : ScanQRButton(),
            ],
          );
        },
      ),
    );
  }
}
