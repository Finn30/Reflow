import 'package:flutter/material.dart';

class FueltypeScreen extends StatefulWidget {
  @override
  _FueltypeScreenState createState() => _FueltypeScreenState();
}

class _FueltypeScreenState extends State<FueltypeScreen> {
  String selectedVehicle = ''; // Default selected vehicle

  final List<String> vehicles = [
    'Gasoline',
    'Diesel',
    'LPG',
    'EV',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fuel Type'),
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
