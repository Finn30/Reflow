import 'package:flutter/material.dart';
import 'package:project_fix/src/features/my%20profile/delete%20account/confirmpassword/confirmpassword_screen.dart';

class DeleteAccountScreen extends StatefulWidget {
  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  String? _selectedReason;
  TextEditingController _otherReasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Account'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'If you need to delete an account and you\'re prompted to provide a reason.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListView(
                  children: [
                    RadioListTile(
                      title: Text('No longer using the service/platform'),
                      value: 'no_longer_using',
                      groupValue: _selectedReason,
                      onChanged: (value) {
                        setState(() {
                          _selectedReason = value.toString();
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                    RadioListTile(
                      title: Text('Found a better alternative'),
                      value: 'better_alternative',
                      groupValue: _selectedReason,
                      onChanged: (value) {
                        setState(() {
                          _selectedReason = value.toString();
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                    RadioListTile(
                      title: Text('Privacy concerns'),
                      value: 'privacy_concerns',
                      groupValue: _selectedReason,
                      onChanged: (value) {
                        setState(() {
                          _selectedReason = value.toString();
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                    RadioListTile(
                      title: Text('Too many emails/notifications'),
                      value: 'too_many_notifications',
                      groupValue: _selectedReason,
                      onChanged: (value) {
                        setState(() {
                          _selectedReason = value.toString();
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                    RadioListTile(
                      title: Text('Difficulty navigating the platform'),
                      value: 'difficulty_navigating',
                      groupValue: _selectedReason,
                      onChanged: (value) {
                        setState(() {
                          _selectedReason = value.toString();
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                    RadioListTile(
                      title: Text('Account security concerns'),
                      value: 'security_concerns',
                      groupValue: _selectedReason,
                      onChanged: (value) {
                        setState(() {
                          _selectedReason = value.toString();
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                    RadioListTile(
                      title: Text('Personal reasons'),
                      value: 'personal_reasons',
                      groupValue: _selectedReason,
                      onChanged: (value) {
                        setState(() {
                          _selectedReason = value.toString();
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                    RadioListTile(
                      title: Text('Others'),
                      value: 'others',
                      groupValue: _selectedReason,
                      onChanged: (value) {
                        setState(() {
                          _selectedReason = value.toString();
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                    if (_selectedReason == 'others') ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: _otherReasonController,
                          maxLength: 150,
                          decoration: InputDecoration(
                            hintText: 'Write a message here',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              // borderSide: BorderSide(color: Colors.blue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                            ),
                          ),
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedReason != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmPasswordScreen(),
                      ),
                    );

                    // Implement delete action
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //       content:
                    //           Text('Account deleted for: $_selectedReason')),
                    // );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Please select a reason before deleting.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Delete',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
