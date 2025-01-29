import 'package:flutter/material.dart';

class CreditCardScannerScreen extends StatefulWidget {
  @override
  _CreditCardScannerScreenState createState() =>
      _CreditCardScannerScreenState();
}

class _CreditCardScannerScreenState extends State<CreditCardScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Credit Card'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Credit Card Scanner'),
      ),
    );
  }
}
