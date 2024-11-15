import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Logo and App Name (Positioned at the top)
                wrapTheText(),
                const SizedBox(height: 40),
                
                // Greeting Message
                const Text(
                  "Hello, John Doe!", // This can be dynamic based on the logged-in user
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 40),

                // Name Edit Field and Edit Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Name Text Field (Wider and with adjusted height)
                    const SizedBox(
                      width: 300,  // Increased width for the name field
                      height: 40,  // Reduced height for the name field
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "John Doe",
                          border: OutlineInputBorder(),
                        ),
                        enabled: false, // Initially disabled, can be enabled on edit
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Edit Button
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.purple),
                      onPressed: () {
                        // Handle name editing logic here
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 300),

                // Change Password Option
                Container(
                  width: double.infinity,
                  color: Colors.purple,  // Purple background for the container
                  child: ListTile(
                    leading: const Icon(
                      Icons.lock,
                      color: Colors.white,  // White icon
                    ),
                    title: const Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,  // White text
                      ),
                    ),
                    onTap: () {
                      // Handle change password action here
                    },
                  ),
                ),
                const Divider(),

                // Delete Account Option
                Container(
                  width: double.infinity,
                  color: Colors.purple,  // Purple background for the container
                  child: ListTile(
                    leading: const Icon(
                      Icons.delete,
                      color: Colors.white,  // White icon
                    ),
                    title: const Text(
                      'Delete Account',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,  // White text
                      ),
                    ),
                    onTap: () {
                      // Handle delete account action here
                    },
                  ),
                ),
              ],
            ),
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
