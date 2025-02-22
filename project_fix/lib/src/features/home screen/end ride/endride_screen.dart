import 'package:flutter/material.dart';
import 'package:project_fix/src/provider/vehicle_provider.dart';
import 'package:provider/provider.dart';

class EndRideScreen extends StatelessWidget {
  final String vehicleNumber;

  const EndRideScreen({Key? key, required this.vehicleNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('End Ride'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Menghapus hanya kendaraan yang diakhiri dari daftar
            Provider.of<VehicleNumberProvider>(context, listen: false)
                .removeVehicle(vehicleNumber);

            // Kembali ke layar sebelumnya
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Center(
        child: Text('End Ride for Vehicle: $vehicleNumber'),
      ),
    );
  }
}
