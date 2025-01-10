import 'package:flutter/material.dart';

class MyTripScreen extends StatefulWidget {
  @override
  _MyTripScreenState createState() => _MyTripScreenState();
}

class _MyTripScreenState extends State<MyTripScreen> {
  // State variables to track selected buttons
  String selectedChoice = 'shared';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Trip'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      'Active days: 0 day',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Text('0',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 4.0),
                              Text('km',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.grey)),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Icon(Icons.flash_on, color: Colors.green),
                              SizedBox(width: 5.0),
                              Text('Mileage',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Text('0',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 4.0),
                              Text('kcal',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.grey)),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Icon(Icons.local_fire_department,
                                  color: Colors.orange),
                              SizedBox(width: 5.0),
                              Text('Calories',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('0',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Icon(Icons.cloud, color: Colors.amber),
                              SizedBox(width: 5.0),
                              Text('Emission',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ChoiceButton(
                  text: 'shared',
                  isSelected: selectedChoice == 'shared',
                  onTap: () {
                    setState(() {
                      selectedChoice = 'shared';
                    });
                  },
                ),
                ChoiceButton(
                  text: 'lease',
                  isSelected: selectedChoice == 'lease',
                  onTap: () {
                    setState(() {
                      selectedChoice = 'lease';
                    });
                  },
                ),
                ChoiceButton(
                  text: 'personal',
                  isSelected: selectedChoice == 'personal',
                  onTap: () {
                    setState(() {
                      selectedChoice = 'personal';
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChoiceButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  ChoiceButton(
      {required this.text, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Colors.blue),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}