import 'package:flutter/material.dart';
import 'package:project_fix/main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isChecked = false;  // Variable to track the checkbox state
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();  // Form key for validation

  // Controllers for the input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,  // Attach the form key
          child: Column(
            children: [
              // Input Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // You can add more email validation logic here if needed
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Input Password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.visibility),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Checkbox untuk persetujuan
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value ?? false;  // Update the checkbox state
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'I have read and agree to the User Agreement and Privacy Policy',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              Spacer(),

              // Tombol Login
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // If the form is valid and checkbox is checked
                    if (isChecked) {
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login successful')),
                      );

                      // Navigate to main screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );
                    } else {
                      // If checkbox is not checked
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please agree to the User Agreement and Privacy Policy')),
                      );
                    }
                  } else {
                    // Show error message if the form is invalid
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill out all fields')),
                    );
                  }
                },
                child: Text('Login'),
              ),

              // Opsi tambahan
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // Navigate to register
                    },
                    child: Text('Register'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to forget password page
                    },
                    child: Text('Forget the password?'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
