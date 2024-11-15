import 'package:flutter/material.dart';
import 'add_docs.dart'; 
import 'profile_page.dart';
import 'documents.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Track the selected index of the BottomNavigationBar

  // Pages for navigation
  final List<Widget> _pages = [
    const HomeScreen(), // HomeScreen widget for Home page
    const AddDocs(),    // AddDocs widget for Add Document page
    const ProfilePage(),
    const MyPocketPage(),
  ];

  // Function to handle BottomNavigationBar item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex], // Display the currently selected page

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Set the selected index to highlight the active tab
        onTap: _onItemTapped, // Call the function to handle item taps
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Document',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'My Pocket',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                // Top Logo and App Name
                wrapTheText(),
                const SizedBox(height: 40),
                
                // Welcome Text
                const Text(
                  "Welcome to\nPocketDocs!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Subtitle Text
                const Text(
                  "Your Documents,\nAnytime, Anywhere.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 40),
                
                // Document Icon
                Image.asset(
                    'assets/logo.jpg', // Make sure the asset path is correct
                    width: 200, 
                    height: 200,
                  ),
                const SizedBox(height: 20),
                
                // Instruction Text
                const Text(
                  "Let's get started!\nAdd here a new document:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Upload Icon
                const Icon(
                  Icons.upload,
                  size: 50,
                  color: Colors.purple,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
