import 'package:flutter/material.dart';
import 'package:project_fix/src/function/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_fix/src/features/my%20profile/myprofile_screen.dart';


class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  final FirestoreService fs = FirestoreService();
  String email = FirebaseAuth.instance.currentUser!.email!;

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Phone Number'),
        actions: [
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try{
                  await fs.updatePhone(email, _phoneNumberController.text);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyProfileScreen()));
                } catch (e) {
                  print("Error updating user data: $e");
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: TextFormField(
            controller: _phoneNumberController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
              prefixText: '+62 ',
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (!RegExp(r'^\d{9,13}$').hasMatch(value)) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}