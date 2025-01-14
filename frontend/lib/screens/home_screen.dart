import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_docs.dart';
import 'profile_page.dart';
import 'documents.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const AddDocs(),
    const ProfilePage(),
    const MyPocketPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> expiringDocuments = [];
  String? _token;

  @override
  void initState() {
    super.initState();
    _initializeTokenAndFetchExpiringDocuments();
  }

  Future<void> _initializeTokenAndFetchExpiringDocuments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      setState(() {
        _token = token;
      });
      _fetchExpiringDocuments();
    } else {
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }

  Future<void> _fetchExpiringDocuments() async {
    const url = 'http://192.168.1.149:3005/api/documents/filter?status=expired';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $_token',
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          expiringDocuments =
          List<Map<String, dynamic>>.from(responseData['documents']);
        });
      } else {
        _showMessage('Failed to fetch documents: ${response.statusCode}');
      }
    } catch (error) {
      _showMessage('Error fetching documents: $error');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final hasExpiringDocuments = expiringDocuments.isNotEmpty;

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

                // Notifications Section
                if (hasExpiringDocuments)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Expiring or Expired Documents:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: expiringDocuments.length,
                        itemBuilder: (context, index) {
                          final doc = expiringDocuments[index];
                          return Card(
                            child: ListTile(
                              title: Text(doc['title']),
                              subtitle: Text(
                                  "Type: ${doc['type']}, Expiry Date: ${doc['expiry_date'] ?? 'N/A'}"),
                              trailing: const Icon(Icons.warning,
                                  color: Colors.red),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 40),

                // Content Below Notifications (Conditionally Shown)
                Column(
                  children: [
                    if (!hasExpiringDocuments)
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

                    // Upload Icon with Navigation to AddDocs Page
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddDocs()),
                        );
                      },
                      child: const Icon(
                        Icons.upload,
                        size: 50,
                        color: Colors.purple,
                      ),
                    ),
                  ],
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
