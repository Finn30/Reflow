import 'package:flutter/material.dart';

class CarGuideScreen extends StatelessWidget {
  const CarGuideScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Guide'),
      ),
      body: const Center(
        child: Text('Car Guide Screen'),
      ),
    );
  }
}
