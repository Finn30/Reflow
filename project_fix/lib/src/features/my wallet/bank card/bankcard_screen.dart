import 'package:flutter/material.dart';
import 'package:project_fix/src/features/my%20wallet/bank%20card/add%20payment%20method/addpaymentmethod_screen.dart';

class BankCardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To pay'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddPaymentMethodScreen()));
              // Add your onPressed code here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Button color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0), // Rounded corners
              ),
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            ),
            child: Text(
              'ADD PAYMENT METHOD',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white, // Text color
              ),
            ),
          ),
        ),
      ),
    );
  }
}
