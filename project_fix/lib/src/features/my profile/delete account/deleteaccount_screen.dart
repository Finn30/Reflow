import 'package:flutter/material.dart';

class DeleteAccountScreen extends StatelessWidget {
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
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // White background for the selection box
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Expanded(
                child: ListView(
                  children: [
                    RadioListTile(
                      title: Text('No longer using the service/platform'),
                      value: 'no_longer_using',
                      groupValue: null, // This should be managed with state
                      onChanged: (value) {},
                    ),
                    RadioListTile(
                      title: Text('Found a better alternative'),
                      value: 'better_alternative',
                      groupValue: null,
                      onChanged: (value) {},
                    ),
                    RadioListTile(
                      title: Text('Privacy concerns'),
                      value: 'privacy_concerns',
                      groupValue: null,
                      onChanged: (value) {},
                    ),
                    RadioListTile(
                      title: Text('Too many emails/notifications'),
                      value: 'too_many_notifications',
                      groupValue: null,
                      onChanged: (value) {},
                    ),
                    RadioListTile(
                      title: Text('Difficulty navigating the platform'),
                      value: 'difficulty_navigating',
                      groupValue: null,
                      onChanged: (value) {},
                    ),
                    RadioListTile(
                      title: Text('Account security concerns'),
                      value: 'security_concerns',
                      groupValue: null,
                      onChanged: (value) {},
                    ),
                    RadioListTile(
                      title: Text('Personal reasons'),
                      value: 'personal_reasons',
                      groupValue: null,
                      onChanged: (value) {},
                    ),
                    RadioListTile(
                      title: Text('Others'),
                      value: 'others',
                      groupValue: null,
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement delete action
              },
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
