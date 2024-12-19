import 'package:flutter/material.dart';
import 'package:project_fix/main.dart';
import 'package:project_fix/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_fix/screens/main_screen.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends StatefulWidget {
  // const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isChecked = false; // Variable to track the checkbox state
  bool _isPasswordVisible = false; // Variable to track the visibility of the password
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key for validation

  // Controllers for the input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event){
      setState(() {
        user = event;
      });
    });
  }

  // Login function
  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      // If the form is valid and checkbox is checked
      if (isChecked) {
        try {
          // Sign in with Firebase Auth
          UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login successful')),
          );

          // Navigate to main screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MenuScreen()),
          );
        } on FirebaseAuthException catch (e) {
          // Handle Firebase login errors
          String errorMessage = 'Email or password is incorrect';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Attach the form key
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
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Input Password
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible, // Toggle password visibility
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
                      });
                    },
                  ),
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
                        isChecked = value ?? false; // Update the checkbox state
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

              Center(
                child: 
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: SignInButton(Buttons.google, text: "Log in with Google", onPressed: handleGoogleLogin),
                  )
              ),

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('or'),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              // Tombol Login
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: _login,
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
  void handleGoogleLogin() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      UserCredential userCredential = await _auth.signInWithProvider(googleProvider);
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MenuScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed. Please try again.')),
      );
      print(e);
    }
  }

}


