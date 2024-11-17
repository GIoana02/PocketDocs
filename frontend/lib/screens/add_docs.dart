import 'package:flutter/material.dart';

class AddDocs extends StatelessWidget {
  const AddDocs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView( // Wrap the whole body with SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Logo and App Name (Positioned at the top)
                wrapTheText(),
                const SizedBox(height: 40),
                
                // Upload Instruction Text
                const Text(
                  "Upload here your\ndocument:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 100),
                
                // Upload Icon (Centered in the middle of the screen)
                const Icon(
                  Icons.upload,
                  size: 100,
                  color: Colors.purple,
                ),
              ],
            ),
          ),
        ),
      ),
      
      // Bottom Navigation Bar (Add Document tab highlighted)
      
    );
  }

  // Function to create the top logo and app name
  Row wrapTheText() {
    return Row(
      children: [
        Image.asset(
          'assets/logo.jpg', // Make sure the asset path is correct
          width: 40,
          height: 40,
        ),
        const SizedBox(width: 8),
        const Expanded( // Wrap the Text widget in Expanded to avoid overflow
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
