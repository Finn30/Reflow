import 'package:flutter/material.dart';

class EndRideScreen extends StatelessWidget {
  const EndRideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('End Ride'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('End Ride Screen'),
      ),
    );
  }
}
