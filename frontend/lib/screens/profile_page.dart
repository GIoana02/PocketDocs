import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isEditing = false;
  String _userName = ""; // Initialize with empty string

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the name passed from the SignUpPage
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      setState(() {
        _userName = args as String; // Set the name
        _nameController.text = _userName; // Initialize text field with the name
      });
    }
  }

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
                // Top Logo and App Name
                wrapTheText(),
                const SizedBox(height: 40),

                // Greeting Message
                Text(
                  "Hello, $_userName!", // Dynamic greeting
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                    // Name Text Field (Editable when in edit mode)
                    SizedBox(
                      width: 300,
                      height: 40,
                      child: TextField(
                        controller: _nameController,
                        enabled: _isEditing,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Edit/Save Button
                    IconButton(
                      icon: Icon(
                        _isEditing ? Icons.check : Icons.edit,
                        color: Colors.purple,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_isEditing) {
                            _userName = _nameController.text; // Save the new name
                          }
                          _isEditing = !_isEditing;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 250),

                // Change Password Option
                Container(
                  width: double.infinity,
                  color: Colors.purple,
                  child: ListTile(
                    leading: const Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
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
                  color: Colors.purple,
                  child: ListTile(
                    leading: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Delete Account',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      // Handle delete account action here
                    },
                  ),
                ),
                const Divider(),

                // Logout Option (Matching style with other options)
                Container(
                  width: double.infinity,
                  color: Colors.purple,
                  child: ListTile(
                    leading: const Icon(
                      Icons.exit_to_app,
                      color: Colors.white, // White icon for logout
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white, // White text
                      ),
                    ),
                    onTap: () {
                      // Handle logout action here and navigate to SignInPage
                      Navigator.pushReplacementNamed(context, '/signin');
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
