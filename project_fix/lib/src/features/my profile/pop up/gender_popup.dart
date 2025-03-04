import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_fix/src/function/services.dart';

void genderPopUp(BuildContext context) async {
  final FirestoreService fs = FirestoreService();
  final String email = FirebaseAuth.instance.currentUser!.email!;
  String? selectedGender = await fs.getGender(email) ?? "";

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Gender",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildGenderOption("Male", selectedGender,
                          (value) => setState(() => selectedGender = value)),
                      _buildGenderOption("Female", selectedGender,
                          (value) => setState(() => selectedGender = value)),
                      // _buildGenderOption("Other", selectedGender,
                      //     (value) => setState(() => selectedGender = value)),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                          ),
                          onPressed: () {
                            fs.updateGender(email, selectedGender!);
                            Navigator.pop(context);
                          },
                          child: Text("Confirm",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 20),
              ],
            );
          },
        ),
      );
    },
  );
}

Widget _buildGenderOption(
    String title, String? selectedGender, Function(String) setState) {
  bool isSelected = selectedGender == title;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: GestureDetector(
      onTap: () => setState(title),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey.shade200, width: 2),
          color:
              isSelected ? Colors.blue.withOpacity(0.1) : Colors.grey.shade50,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.blue : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ),
  );
}
