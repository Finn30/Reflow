import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_fix/src/function/services.dart';

void genderPopUp(BuildContext context) {
  final FirestoreService fs = FirestoreService();
  final String email = FirebaseAuth.instance.currentUser!.email!;
  String? selectedGender;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Select Gender"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Male"),
              leading: Radio(
                value: "Male",
                groupValue: selectedGender,
                onChanged: (value) {
                  selectedGender = value.toString();
                  fs.updateGender(email, selectedGender!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text("Female"),
              leading: Radio(
                value: "Female",
                groupValue: selectedGender,
                onChanged: (value) {
                  selectedGender = value.toString();
                  fs.updateGender(email, selectedGender!);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
