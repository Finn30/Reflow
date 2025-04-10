import 'package:flutter/material.dart';

Future<void> showRideOptionDialog(
    BuildContext context, Function(bool) onSelected) async {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        icon: Image.asset("assets/img/bicycle.png", height: 100),
        title: Text("Choose Ride Type"),
        content: Text(
          "Do you want a Normal Ride or a Package Ride?",
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onSelected(true);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: Size(0, 50)),
                  child: Text(
                    "Normal",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onSelected(false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: Size(0, 50),
                  ),
                  child: Text(
                    "Package",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // TextButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //     onSelected(true); // Normal Ride
          //   },
          //   child: Text("Normal Ride"),
          // ),
          // TextButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //     onSelected(false); // Package Ride
          //   },
          //   child: Text("Package Ride"),
          // ),
        ],
      );
    },
  );
}
