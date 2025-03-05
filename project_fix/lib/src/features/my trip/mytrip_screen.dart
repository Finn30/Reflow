import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_fix/src/features/home%20screen/end%20ride/endride_screen.dart';
import 'package:provider/provider.dart';
import 'package:project_fix/src/provider/vehicle_provider.dart';

class MyTripScreen extends StatefulWidget {
  @override
  _MyTripScreenState createState() => _MyTripScreenState();
}

class _MyTripScreenState extends State<MyTripScreen> {
  String selectedChoice = 'shared';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Trip'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildSummaryCard(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildChoiceButtons(),
            ),
            SizedBox(height: 16.0),
            Consumer<VehicleNumberProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(8.0),
                  itemCount: provider.endedVehiclesBySession.length,
                  itemBuilder: (context, sessionIndex) {
                    List<String> sessionVehicles =
                        provider.endedVehiclesBySession[sessionIndex];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EndRideScreen(
                              sessionVehicles:
                                  sessionVehicles, // Kirim data kendaraan
                            ),
                          ),
                        );
                      },
                      child: MyTripCard(),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
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
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Text(
              'Active days: 0 day',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn(
                  '0', 'km', Icons.flash_on, 'Mileage', Colors.green),
              _buildStatColumn('0', 'kcal', Icons.local_fire_department,
                  'Calories', Colors.orange),
              _buildStatColumn('0', '', Icons.cloud, 'Emission', Colors.amber),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
      String value, String unit, IconData icon, String label, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Text(value,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            if (unit.isNotEmpty) SizedBox(width: 4.0),
            if (unit.isNotEmpty)
              Text(unit, style: TextStyle(fontSize: 14.0, color: Colors.grey)),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 5.0),
            Text(label, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildChoiceButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: ['shared', 'lease', 'personal']
          .map(
            (choice) => ChoiceButton(
              text: choice,
              isSelected: selectedChoice == choice,
              onTap: () {
                setState(() {
                  selectedChoice = choice;
                });
              },
            ),
          )
          .toList(),
    );
  }
}

class ChoiceButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  ChoiceButton(
      {required this.text, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Colors.blue),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyTripCard extends StatelessWidget {
  final LatLng startLocation = LatLng(-6.200000, 106.816666); // Jakarta
  final LatLng endLocation = LatLng(-6.175110, 106.865036); // Monas

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Google Maps Widget
          Container(
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: startLocation,
                  zoom: 14,
                ),
                markers: {
                  Marker(markerId: MarkerId('start'), position: startLocation),
                  Marker(markerId: MarkerId('end'), position: endLocation),
                },
                zoomControlsEnabled: false,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Waktu Mulai & Selesai
                Row(
                  children: [
                    Column(
                      children: [
                        Icon(Icons.circle_outlined,
                            color: Colors.green, size: 12),
                        Container(
                          height: 15,
                          width: 2,
                          color: Colors.green,
                        ),
                        Icon(Icons.circle_outlined,
                            color: Colors.blue, size: 12),
                      ],
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("2025/03/03 09:16 am",
                            style: TextStyle(fontSize: 14)),
                        SizedBox(height: 8),
                        Text("2025/03/03 09:17 am",
                            style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rp0.00',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        Text(
                          'Paid',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Divider(color: Colors.grey.shade300),
                SizedBox(height: 10),
                // Jarak, Kalori, dan Emisi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(Icons.flash_on, Colors.green, "0", "km"),
                    _buildStatItem(Icons.local_fire_department, Colors.orange,
                        "0", "Kcal"),
                    _buildStatItem(Icons.cloud, Colors.amber, "0", ""),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, Color color, String value, String unit) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(width: 4),
        Text(value,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        if (unit.isNotEmpty) SizedBox(width: 4),
        if (unit.isNotEmpty)
          Text(unit, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
