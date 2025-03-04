import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_fix/src/function/services.dart';

void agePopUp(BuildContext context) {
  final FirestoreService fs = FirestoreService();
  final String email = FirebaseAuth.instance.currentUser!.email!;

  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;

  List<int> years = List.generate(100, (index) => DateTime.now().year - index);
  List<int> months = List.generate(12, (index) => index + 1);
  List<int> days = List.generate(31, (index) => index + 1);

  void updateDays() {
    int maxDays = DateTime(selectedYear, selectedMonth + 1, 0).day;
    days = List.generate(maxDays, (index) => index + 1);
    if (selectedDay > maxDays) {
      selectedDay = maxDays;
    }
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      "Select your birthday",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CupertinoPicker(
                                looping: true,
                                selectionOverlay: Container(),
                                backgroundColor: Colors.white,
                                itemExtent: 40,
                                scrollController: FixedExtentScrollController(
                                  initialItem: years.indexOf(selectedYear),
                                ),
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    selectedYear = years[index];
                                    updateDays();
                                  });
                                },
                                children: years.map((year) {
                                  return Center(
                                    child: Text(
                                      "$year Year",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: year == selectedYear
                                            ? Colors.blue[700]
                                            : Colors.grey,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            Expanded(
                              child: CupertinoPicker(
                                looping: true,
                                selectionOverlay: Container(),
                                backgroundColor: Colors.white,
                                itemExtent: 40,
                                scrollController: FixedExtentScrollController(
                                  initialItem: selectedMonth - 1,
                                ),
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    selectedMonth = months[index];
                                    updateDays();
                                  });
                                },
                                children: months.map((month) {
                                  return Center(
                                    child: Text(
                                      "${month.toString().padLeft(2, '0')} Month",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: month == selectedMonth
                                            ? Colors.blue[700]
                                            : Colors.grey,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            Expanded(
                              child: CupertinoPicker(
                                looping: true,
                                selectionOverlay: Container(),
                                backgroundColor: Colors.white,
                                itemExtent: 40,
                                scrollController: FixedExtentScrollController(
                                  initialItem: selectedDay - 1,
                                ),
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    selectedDay = days[index];
                                  });
                                },
                                children: days.map((day) {
                                  return Center(
                                    child: Text(
                                      "${day.toString().padLeft(2, '0')} Day",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: day == selectedDay
                                            ? Colors.blue[700]
                                            : Colors.grey,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            DateTime birthDate = DateTime(
                                selectedYear, selectedMonth, selectedDay);
                            int age = DateTime.now().year - birthDate.year;
                            if (DateTime.now().isBefore(DateTime(
                                birthDate.year + age,
                                birthDate.month,
                                birthDate.day))) {
                              age--;
                            }

                            await fs.updateAge(email, age.toString());
                            print("Age updated successfully to $age");

                            Navigator.pop(context, age.toString());
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text("Confirm",
                              style: TextStyle(fontSize: 18)),
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
