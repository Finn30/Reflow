import 'package:flutter/material.dart';

class RefundScreen extends StatelessWidget {
  const RefundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refund'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Refund Screen'),
      ),
    );
  }
}
