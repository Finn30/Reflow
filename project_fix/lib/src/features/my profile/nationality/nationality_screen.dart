import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class NationalityScreen extends StatefulWidget {
  @override
  _NationalityScreenState createState() => _NationalityScreenState();
}

class _NationalityScreenState extends State<NationalityScreen> {
  String selectedCountry = "Select Country";
  String countryCode = "";

  void _pickCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          selectedCountry = country.name;
          countryCode = "+${country.phoneCode}";
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Nationality"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$selectedCountry ($countryCode)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickCountry,
              child: Text("Pick a Country"),
            ),
          ],
        ),
      ),
    );
  }
}
