import 'package:flutter/material.dart';

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
      ),
      body: Center(
        child: Text('End Ride for Vehicle: $vehicleNumber'),
      ),
    );
  }
}
