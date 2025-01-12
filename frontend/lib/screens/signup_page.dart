import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pncController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView( // Wrap the body in a SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // PocketDocs Logo and Name at the top
            wrapTheText(),
            const SizedBox(height: 40),

            // Full Name Field
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 16),

            // Personal Numeric Code Field
            const TextField(
              decoration: InputDecoration(labelText: 'Personal Numeric Code'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Password Field
            const TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),

            // Confirm Password Field
            const TextField(
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            const SizedBox(height: 32),

            // Sign Up Button
            ElevatedButton(
              onPressed: () {
                // Pass the name to the ProfilePage when navigating to home
                Navigator.pushReplacementNamed(context, '/home', arguments: _nameController.text);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white, // Set the text color to white
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Redirect to Sign In
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signin');
              },
              child: const Text(
                "Already have an account? Sign In",
                style: TextStyle(color: Colors.purple),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
