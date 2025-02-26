import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:project_fix/src/features/home%20screen/end%20ride/ride%20detail/ridedetail_screen.dart';
import 'package:project_fix/src/provider/vehicle_provider.dart';
import 'package:provider/provider.dart';
import 'package:project_fix/src/features/home screen/end ride/endride_screen.dart';

class ParkingMenu extends StatefulWidget {
  final String selectedVehicle;
  final VoidCallback onClose;
  final VoidCallback onEndRide;
  final VoidCallback onParkingComplete;
  final VoidCallback onKeepRiding;

  const ParkingMenu({
    Key? key,
    required this.selectedVehicle,
    required this.onClose,
    required this.onEndRide,
    required this.onParkingComplete,
    required this.onKeepRiding,
  }) : super(key: key);

  @override
  _ParkingMenuState createState() => _ParkingMenuState();
}

class _ParkingMenuState extends State<ParkingMenu>
    with TickerProviderStateMixin {
  late GifController _gifController;
  bool isCancelled = false;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this);
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }

  void _showParkingPopup(BuildContext context) {
    isCancelled = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          if (!isCancelled) {
            Provider.of<VehicleNumberProvider>(context, listen: false)
                .unparkVehicle(widget.selectedVehicle);
            Navigator.of(context).pop();
            widget.onKeepRiding();
          }
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
                    isCancelled = true;
                    Navigator.of(context)
                        .pop(); // Tutup popup, tetap di ParkingMenu
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

  void _showEndRidePopup(BuildContext context) {
    isCancelled = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          if (!isCancelled) {
            var vehicleProvider =
                Provider.of<VehicleNumberProvider>(context, listen: false);
            vehicleProvider.endRide(widget.selectedVehicle);

            if (vehicleProvider.unlockedVehicles.isEmpty) {
              vehicleProvider.saveCurrentSession();
            }
            Navigator.of(context).pop();
            widget.onEndRide();
            List<String> lastSessionVehicles =
                vehicleProvider.getLastSessionVehicles();

            if (lastSessionVehicles.length > 1) {
              if (Provider.of<VehicleNumberProvider>(context, listen: false)
                  .allVehiclesEnded()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EndRideScreen(),
                  ),
                );
              }
            } else if (lastSessionVehicles.length == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RideDetailScreen(
                      vehicleNumber: lastSessionVehicles.first),
                ),
              );
            }
          }
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
                    isCancelled = true;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.directions_bike,
                      color: Colors.black,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Riding info",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "00:00:15",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
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
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_filled,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Duration",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.currency_yen,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Cost",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.coffee,
                      color: Colors.green,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Parking information",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "00:00:15",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
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
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_filled,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Parking time",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.currency_yen,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Parking fee",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
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
                          "Keep Riding",
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
                          // Navigate to EndRideScreen
                          _showEndRidePopup(context);
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
