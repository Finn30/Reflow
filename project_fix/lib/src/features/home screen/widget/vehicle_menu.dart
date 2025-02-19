import 'package:flutter/material.dart';
import 'package:project_fix/src/features/home%20screen/qr%20code%20scanner/qrcodescanner_screen.dart';
import 'package:project_fix/src/provider/vehicle_provider.dart';
import 'package:provider/provider.dart';

class VehicleMenu extends StatelessWidget {
  final Function(String) onVehicleSelected;

  const VehicleMenu({
    Key? key,
    required this.onVehicleSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<VehicleNumberProvider>(
      builder: (context, provider, child) {
        return Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  // padding: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
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
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        style: TextStyle(color: Colors.white),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: "Rp",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          TextSpan(
                                            text: "0",
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.currency_yen_rounded,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "Total ride cost",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "00:00:08",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.timer,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "Duration",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children:
                                      provider.vehicleNumbers.map((number) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: GestureDetector(
                                        onTap: () => onVehicleSelected(number),
                                        child: Card(
                                          // elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Container(
                                            width: 100, // Ukuran setiap Card
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.directions_bike,
                                                  size: 46,
                                                  color: Colors.black,
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  number,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                // SizedBox(height: 8),
                                                Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text.rich(
                              TextSpan(
                                style: TextStyle(fontSize: 18),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'A total of ',
                                      style: TextStyle(color: Colors.black)),
                                  TextSpan(
                                      text: provider.vehicleNumbers.length
                                          .toString(),
                                      style: TextStyle(color: Colors.blue)),
                                  TextSpan(
                                      text: ' bicycles',
                                      style: TextStyle(color: Colors.black)),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          QRCodeScannerScreen(),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.blue,
                                ),
                                label: Text(
                                  "Scan code to add",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(color: Colors.blue),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.675,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    "End ride",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
