import 'package:flutter/material.dart';
import 'package:project_fix/src/function/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_fix/src/features/my%20profile/myprofile_screen.dart';

class FirstNameScreen extends StatefulWidget {
  const FirstNameScreen({super.key});

  @override
  State<FirstNameScreen> createState() => _FirstNameScreenState();
}

class _FirstNameScreenState extends State<FirstNameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final FirestoreService fs = FirestoreService();
  String email = FirebaseAuth.instance.currentUser!.email!;


  @override
  void dispose() {
    _firstNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit First Name'),
        actions: [
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            onPressed: () async{
              if (_formKey.currentState!.validate()) {
                try{
                  await fs.updateFirstname(email, _firstNameController.text);
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
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}