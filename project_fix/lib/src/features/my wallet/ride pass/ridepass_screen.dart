import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_fix/src/features/my%20wallet/ride%20pass/choose%20payment/choosepayment_screen.dart';

class RidePassScreen extends StatefulWidget {
  const RidePassScreen({Key? key}) : super(key: key);

  @override
  _RidePassScreenState createState() => _RidePassScreenState();
}

class _RidePassScreenState extends State<RidePassScreen> {
  List<Map<String, dynamic>> ridePasses = [
    {
      'price': 10000,
      'minute': 35,
      'originalPrice': 10500,
      'duration': Duration(days: 4, hours: 8, minutes: 7, seconds: 4),
      'validity': '1 day',
      'remaining': 1000,
      'common': 1000,
    },
    {
      'price': 15000,
      'minute': 35,
      'originalPrice': 16000,
      'duration': Duration(days: 2, hours: 5, minutes: 30, seconds: 10),
      'validity': '1 day',
      'remaining': 500,
      'common': 500,
    },
  ];

  List<Timer?> timers = [];

  @override
  void initState() {
    super.initState();
    startTimers();
  }

  void startTimers() {
    for (var i = 0; i < ridePasses.length; i++) {
      timers.add(Timer.periodic(const Duration(seconds: 1), (timer) {
        if (ridePasses[i]['duration'].inSeconds > 0) {
          setState(() {
            ridePasses[i]['duration'] =
                Duration(seconds: ridePasses[i]['duration'].inSeconds - 1);
          });
        } else {
          timer.cancel();
        }
      }));
    }
  }

  @override
  void dispose() {
    for (var timer in timers) {
      timer?.cancel();
    }
    super.dispose();
  }

  void onRidePassTapped(Map<String, dynamic> pass) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.3,
          minChildSize: 0.3,
          maxChildSize: 0.3,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'hanya Rp. ${pass['price']}\nuntuk ${pass['minute']} menit',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Rp ${pass['price']}.00',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Validity period ${pass['validity']}',
                          style: TextStyle(color: Colors.black54),
                        ),
                        Text(
                          'Original price Rp ${pass['originalPrice']}',
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Remaining ${pass['remaining']} Open  |  Common ${pass['common']} Open',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  (MaterialPageRoute(
                                      builder: (context) => ChoosePaymentScreen(
                                            price: pass['price'],
                                            balance: pass['price'],
                                          ))));
                            },
                            child: Text(
                              'Pay Rp. ${pass['price'].toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy a Ride Pass'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ridePasses.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onRidePassTapped(ridePasses[index]),
            child: buildRidePassCard(ridePasses[index]),
          );
        },
      ),
    );
  }

  Widget buildRidePassCard(Map<String, dynamic> pass) {
    Duration duration = pass['duration'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Limited time',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.orange,
                  ),
                ),
                Row(
                  children: [
                    _buildTimeBox(duration.inDays),
                    const SizedBox(width: 4),
                    const Text('day',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    _buildTimeBox(duration.inHours.remainder(24)),
                    const Text(' : '),
                    _buildTimeBox(duration.inMinutes.remainder(60)),
                    const Text(' : '),
                    _buildTimeBox(duration.inSeconds.remainder(60)),
                    const SizedBox(width: 4),
                    const Text(
                      'expires',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'hanya Rp. ${pass['price']}\nuntuk ${pass['minute']} menit',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Rp ${pass['price']}.00',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Validity period ${pass['validity']}',
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      'Original price Rp ${pass['originalPrice']}',
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Remaining ${pass['remaining']} Open  |  Common ${pass['common']} Open',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTimeBox(int value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        value.toString().padLeft(2, '0'),
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
