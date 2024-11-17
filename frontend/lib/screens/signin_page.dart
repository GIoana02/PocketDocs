import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pncOrEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorPNCEmail; // To store error message for PNC or Email validation

  // Validate and handle sign in
  void _signIn() {
    setState(() {
      if (_pncOrEmailController.text.isEmpty || _passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all the fields.')),
        );
        return;
      }

      // Validate PNC or Email (PNC should be 13 digits, otherwise treat it as an email)
      if (_pncOrEmailController.text.length == 13 &&
          !RegExp(r'^\d{13}$').hasMatch(_pncOrEmailController.text)) {
        _errorPNCEmail = 'Personal Numeric Code must be exactly 13 digits';
      } else {
        _errorPNCEmail = null;
      }

      if (_formKey.currentState!.validate()) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // PocketDocs Logo and Name at the top
              wrapTheText(),
              const SizedBox(height: 40),

              // PNC or Email Field
              TextFormField(
                controller: _pncOrEmailController,
                decoration: InputDecoration(
                  labelText: 'Personal Numeric Code',
                  border: const OutlineInputBorder(),
                  errorText: _errorPNCEmail, // Show error message if validation fails
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Personal Numeric Code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Sign In Button
              ElevatedButton(
                onPressed: _signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Keep the purple background
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white, // Set the text color to white
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Sign Up Navigation
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/signup');
                },
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to create the top logo and app name
  Row wrapTheText() {
    return Row(
      children: [
        Image.asset(
          'assets/logo.jpg', // Ensure the asset path is correct
          width: 40,
          height: 40,
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            "PocketDocs",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
        ),
      ],
    );
  }
}
