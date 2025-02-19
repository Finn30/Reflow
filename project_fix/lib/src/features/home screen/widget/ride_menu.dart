import 'package:flutter/material.dart';

class RideMenu extends StatelessWidget {
  final String selectedVehicle;
  final VoidCallback onClose;

  const RideMenu({
    Key? key,
    required this.selectedVehicle,
    required this.onClose,
  }) : super(key: key);

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
              onTap: onClose,
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
