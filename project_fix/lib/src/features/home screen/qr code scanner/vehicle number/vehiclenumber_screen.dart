import 'package:flutter/material.dart';
import 'package:project_fix/src/features/home%20screen/home_screen.dart';
import 'package:project_fix/src/features/home%20screen/qr%20code%20scanner/qrcodescanner_screen.dart';
import 'package:project_fix/src/provider/vehicle_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:carousel_slider/carousel_slider.dart';

class VehicleNumberScreen extends StatefulWidget {
  @override
  _VehicleNumberScreenState createState() => _VehicleNumberScreenState();
}

class _VehicleNumberScreenState extends State<VehicleNumberScreen> {
  final List<String> imgList = [
    'assets/img/bicycle.png',
    'assets/img/bicycle.png',
    'assets/img/bicycle.png',
    // Add more image paths as needed
  ];

  int _currentIndex = 0;
  QRViewController? controller;
  TextEditingController _vehicleNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vehicleNumberController.addListener(() {
      setState(() {}); // Update the UI when the text input changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QRCodeScannerScreen()),
        );
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.discount),
              color: Colors.black,
              onPressed: () {
                // Define the action when the button is pressed
              },
            ),
          ],
          title: Text('Vehicle Number'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    // Carousel for images
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 150,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                      items: imgList
                          .map((item) => Container(
                                width: 150,
                                height: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    item,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    // Indicators
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imgList.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => setState(() {
                            _currentIndex = entry.key;
                          }),
                          child: Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).primaryColorLight)
                                  .withOpacity(
                                _currentIndex == entry.key ? 0.9 : 0.4,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _vehicleNumberController,
                          decoration: InputDecoration(
                            hintText: 'Please enter the vehicle number',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _vehicleNumberController.clear();
                          // Define the action when the button is pressed
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      String vehicleNumber = _vehicleNumberController.text;
                      if (vehicleNumber.isNotEmpty) {
                        // Set nomor kendaraan menggunakan Provider
                        Provider.of<VehicleNumberProvider>(context,
                                listen: false)
                            .addLockedVehicle(vehicleNumber);

                        // Navigasi ke HomeScreen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Please enter a vehicle number")),
                        );
                      }
                      // Define the action when the button is pressed
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: _vehicleNumberController.text.isNotEmpty
                          ? Colors.blue
                          : Colors.grey[200], // Change color based on input
                    ),
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                          color: _vehicleNumberController.text.isNotEmpty
                              ? Colors.white
                              : Colors.grey[
                                  700]), // Change text color based on input
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QRCodeScannerScreen(),
                              ),
                            );
                            // Handle vehicle number display
                          },
                          child: Icon(
                            Icons.qr_code_scanner,
                            color: Colors.white,
                            size: 25,
                          ), // Example vehicle number
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(20),
                            backgroundColor: Colors.blue,
                          ),
                        ),
                        Text(
                          'Scan code to unlock',
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
