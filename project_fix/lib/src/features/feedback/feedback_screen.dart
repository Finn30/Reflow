import 'package:flutter/material.dart';
import 'package:project_fix/src/features/feedback/category%20screen/bike_screen.dart';
import 'package:project_fix/src/features/feedback/category%20screen/parking_screen.dart';
import 'package:project_fix/src/features/feedback/category%20screen/payment_screen.dart';
import 'package:project_fix/src/features/feedback/qr%20view/qrview_screen.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController _vehicleNumberController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  FocusNode _vehicleFocus = FocusNode();
  FocusNode _descriptionFocus = FocusNode();

  void _scanQRCode(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRViewScreen()),
    );
    if (result != null) {
      setState(() {
        _vehicleNumberController.text = result;
      });
    }
  }

  void _navigateToPage(BuildContext context, Widget page) {
    if (_vehicleNumberController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please enter or scan the vehicle number first')),
      );
    }
  }

  bool get isFormValid =>
      _vehicleNumberController.text.isNotEmpty ||
      _descriptionController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vehicle number',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: _vehicleNumberController,
              focusNode: _vehicleFocus,
              decoration: InputDecoration(
                hintText: 'Please enter the vehicle number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.qr_code_scanner),
                  onPressed: () => _scanQRCode(context),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildCategoryButton(
                    Icons.currency_yen,
                    'Payment',
                    () => _navigateToPage(context, PaymentScreen()),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildCategoryButton(
                    Icons.pedal_bike,
                    'Bike',
                    () => _navigateToPage(context, BikeScreen()),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: _buildCategoryButton(
                Icons.local_parking,
                'Parking/Illegal Damage',
                () => _navigateToPage(context, ParkingScreen()),
                isWide: true,
              ),
            ),
            SizedBox(height: 16),
            Text('A detailed description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              focusNode: _descriptionFocus,
              maxLines: 4,
              maxLength: 200,
              decoration: InputDecoration(
                hintText:
                    'On which page did you encounter the problem? A detailed description will help solve the problem quickly.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 16),
            Text('Upload picture (0/3)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.add, size: 40, color: Colors.grey),
              ),
            ),
            SizedBox(height: 24),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: isFormValid ? () => print("Submit") : null,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: isFormValid ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        color: isFormValid ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(
      IconData icon, String label, VoidCallback onPressed,
      {bool isWide = false}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: isWide ? double.infinity : null,
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32),
            SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
