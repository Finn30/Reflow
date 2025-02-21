import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:project_fix/src/provider/vehicle_provider.dart';
import 'package:provider/provider.dart';

class RideMenu extends StatefulWidget {
  final String selectedVehicle;
  final VoidCallback onClose;
  final VoidCallback onEndRide;
  final VoidCallback onParkingComplete;

  const RideMenu({
    Key? key,
    required this.selectedVehicle,
    required this.onClose,
    required this.onEndRide,
    required this.onParkingComplete,
  }) : super(key: key);

  @override
  _RideMenuState createState() => _RideMenuState();
}

class _RideMenuState extends State<RideMenu> with TickerProviderStateMixin {
  late GifController _gifController;
  bool isCancelled = false;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this);
  }

  void _showParkingPopup(BuildContext context) {
    isCancelled = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          if (!isCancelled) {
            Navigator.of(context).pop();
            widget.onParkingComplete();
          } // Pindah ke ParkingMenu
        });

        return AlertDialog(
          contentPadding: EdgeInsets.all(20),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  Text(
                    "Lock",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Gif(
                    controller: _gifController,
                    duration: Duration(seconds: 2),
                    autostart: Autostart.loop,
                    image: AssetImage("assets/animation/lock.gif"),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Park bicycles according to regulations",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Manual lock ",
                          style: TextStyle(color: Colors.red),
                        ),
                        TextSpan(text: "Temporary parking available"),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () {
                    // isCancelled = true;
                    Navigator.of(context)
                        .pop(); // Tutup popup, tetap di RideMenu
                  },
                  child: Icon(Icons.close, color: Colors.black),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                          widget.selectedVehicle,
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
                          Provider.of<VehicleNumberProvider>(context,
                                  listen: false)
                              .parkVehicle(widget.selectedVehicle);
                          _showParkingPopup(context);
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
              onTap: widget.onClose,
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
}
