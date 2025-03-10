import 'package:flutter/material.dart';
import 'package:project_fix/src/features/my%20profile/vehicle%20ownership/fuel%20type/fueltype_screen.dart';

class VehicleOwnershipScreen extends StatefulWidget {
  @override
  _VehicleOwnershipScreenState createState() => _VehicleOwnershipScreenState();
}

class _VehicleOwnershipScreenState extends State<VehicleOwnershipScreen> {
  String selectedVehicle = ''; // Default selected vehicle

  final List<String> vehicles = [
    'Motorcycle',
    '4-Wheel Car',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Type'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(vehicles[index], style: TextStyle(fontSize: 14)),
                trailing: selectedVehicle == vehicles[index]
                    ? Icon(Icons.check_circle, color: Colors.blue, size: 20)
                    : null,
                onTap: () {
                  setState(() {
                    selectedVehicle = vehicles[index];
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FueltypeScreen(),
                    ),
                  );
                },
              ),
              Divider(
                height: 1,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
            ],
          );
        },
      ),
    );
  }
}
