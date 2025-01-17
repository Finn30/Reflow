import 'package:flutter/material.dart';

class LanguageSwitchScreen extends StatefulWidget {
  @override
  _LanguageSwitchScreenState createState() => _LanguageSwitchScreenState();
}

class _LanguageSwitchScreenState extends State<LanguageSwitchScreen> {
  String selectedLanguage = 'English'; // Default selected language

  final List<String> languages = [
    'Simplified Chinese',
    'English',
    'Japanese',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Switch'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(languages[index]),
            trailing: selectedLanguage == languages[index]
                ? Icon(Icons.check_circle, color: Colors.blue)
                : null,
            onTap: () {
              setState(() {
                selectedLanguage = languages[index];
              });
            },
          );
        },
      ),
    );
  }
}
