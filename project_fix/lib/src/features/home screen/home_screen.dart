import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_fix/src/constant/image_string.dart';
import 'package:project_fix/src/constant/text_string.dart';
import 'package:project_fix/src/features/home%20screen/qr%20code%20scanner/qrcodescanner_screen.dart';
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

  Widget _buildScanQRCodeButton() {
    return Positioned(
      bottom: 16,
      left: 100,
      right: 100,
      child: GestureDetector(
        onTap: () async {
          final qrCodeResult = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRCodeScannerScreen()),
          );

          if (qrCodeResult != null) {
            // Tampilkan hasil QR code
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('QR Code: $qrCodeResult')),
            );
          }
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue, // Warna tombol
            borderRadius: BorderRadius.circular(30), // Sudut melengkung
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Warna bayangan
                blurRadius: 6,
                offset: Offset(0, 3), // Arah bayangan
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_scanner, // Ikon QR code
                color: Colors.white,
              ),
              SizedBox(width: 12), // Jarak antara ikon dan teks
              Column(
                children: [
                  Text(
                    'Scan QR code', // Teks tombol
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'to ride', // Teks tombol
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildVehicleMenu(VehicleNumberProvider provider) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              // padding: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    style: TextStyle(color: Colors.white),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "Rp",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      TextSpan(
                                        text: "0",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.currency_yen_rounded,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Total ride cost",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "00:00:08",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Duration",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: provider.vehicleNumbers.map((number) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedVehicle =
                                            number; // Simpan kendaraan yang dipilih
                                        showRideMenu =
                                            true; // Tampilkan Ride Menu
                                      });
                                    },
                                    child: Card(
                                      // elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Container(
                                        width: 100, // Ukuran setiap Card
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.directions_bike,
                                              size: 46,
                                              color: Colors.black,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              number,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                            // SizedBox(height: 8),
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text.rich(
                          TextSpan(
                            style: TextStyle(fontSize: 18),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'A total of ',
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text:
                                      provider.vehicleNumbers.length.toString(),
                                  style: TextStyle(color: Colors.blue)),
                              TextSpan(
                                  text: ' bicycles',
                                  style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QRCodeScannerScreen(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.blue,
                            ),
                            label: Text(
                              "Scan code to add",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: BorderSide(color: Colors.blue),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width * 0.675,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                "End ride",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRideMenu(String selectedVehicle) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Informasi kendaraan yang dipilih
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedVehicle,
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.battery_full,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "100%",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(width: 16),
                            Icon(
                              Icons.speed,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "0.00",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " km/h",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Image(
                        image: AssetImage("assets/img/bicycle.png"), width: 80),
                  ],
                ),
                Divider(thickness: 1, color: Colors.grey[300]),
                // Biaya dan Durasi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Rp",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              TextSpan(
                                text: "0",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "Cost",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "00:00:16",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "Duration",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.lightbulb, color: Colors.grey[400]),
                        Text(
                          "Light",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Divider(thickness: 1, color: Colors.grey[300]),
                // Tombol Parking dan End Ride
                Row(
                  children: [
                    Icon(Icons.access_time_filled, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      "2025/09/12",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "00:00:00 PM",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "83126, Universitas Mataram Selaparang Mataram West Nusa Tenggara",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle Parking Action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: Size(0, 50),
                        ),
                        child: Text(
                          "Parking",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle End Ride Action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: Size(0, 50),
                        ),
                        child: Text(
                          "End ride",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tombol Close di Pojok Kanan Atas
          Positioned(
            top: -8,
            right: -8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  showRideMenu = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.close, color: Colors.black, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
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
                      ? buildRideMenu(selectedVehicle!)
                      : buildVehicleMenu(vehicleProvider))
                  : _buildScanQRCodeButton(),
            ],
          );
        },
      ),
    );
  }
}
