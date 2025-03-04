import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_fix/src/function/services.dart';

void agePopUp(BuildContext context, String value) {
  final FirestoreService fs = FirestoreService();
  final String email = FirebaseAuth.instance.currentUser!.email!;
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController(text: value);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Enter Age"),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _textController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Age",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your age';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await fs.updateAge(email, _textController.text);
                print("Age updated successfully to ${_textController.text}");
                Navigator.pop(
                    context, _textController.text); // Return the new age value
              }
            },
            child: const Text("Save", style: TextStyle(color: Colors.blue)),
          ),
        ],
      );
    },
  );
}
