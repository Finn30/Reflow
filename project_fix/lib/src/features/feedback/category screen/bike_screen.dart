import 'package:flutter/material.dart';

class BikeScreen extends StatefulWidget {
  @override
  _BikeScreenState createState() => _BikeScreenState();
}

class _BikeScreenState extends State<BikeScreen> {
  Map<String, bool> damagedParts = {
    "Brake": false,
    "QR Code": false,
    "Seat": false,
    "Headlight": false,
    "Smart Lock": false,
    "Tire": false,
    "Pedal": false,
    "Chain": false,
  };

  final TextEditingController descriptionController = TextEditingController();

  bool get isFormValid =>
      damagedParts.containsValue(true) || descriptionController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bicycle Problem'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Please select the damaged part of the vehicle',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Image.asset(
                        'assets/img/bicycle.png',
                        height: 200,
                      ),
                    ),
                    SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 5,
                      children: damagedParts.keys.map((String key) {
                        return _buildCheckbox(key);
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'None of the above',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      controller: descriptionController,
                      maxLength: 200,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Fill in your description',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Please take pictures of the damaged vehicle',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'To help us better deal with your problem please provide at least one photo.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        print("Upload Image");
                      },
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
                    SizedBox(height: 20),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(String part) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: damagedParts[part] ?? false,
          activeColor: Colors.blue,
          onChanged: (bool? value) {
            setState(() {
              damagedParts[part] = value ?? false;
            });
          },
        ),
        Text(part),
      ],
    );
  }
}
