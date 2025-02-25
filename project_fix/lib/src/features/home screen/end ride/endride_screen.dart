import 'package:flutter/material.dart';
import 'package:project_fix/src/provider/vehicle_provider.dart';
import 'package:provider/provider.dart';

class EndRideScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final endedVehicles =
        Provider.of<VehicleNumberProvider>(context).endedVehicles;

    return Scaffold(
      appBar: AppBar(title: Text("End Ride")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("End Ride Summary",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: endedVehicles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.directions_bike),
                    title: Text("Vehicle Number: ${endedVehicles[index]}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
