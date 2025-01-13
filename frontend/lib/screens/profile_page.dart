import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isLoading = true;
  String _userName = "";
  String _userEmail = "";
  String _userId = "";
  String _userCNP = "";
  String _userPhoneNo = "";
  String? _token;

  @override
  void initState() {
    super.initState();
    _initializeTokenAndFetchProfile();
  }

  Future<void> _initializeTokenAndFetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      setState(() {
        _token = token;
      });
      _fetchUserProfile();
    } else {
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }

  Future<void> _fetchUserProfile() async {
    final url = Uri.parse('http://192.168.1.149:3005/api/users/me');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _userId = responseData['user_id'];
          _userName = responseData['name'];
          _userEmail = responseData['email'];
          _userPhoneNo = responseData['phone_number'];
          _userCNP = responseData['cnp'];
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch profile.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  Future<void> _deleteAccount() async {
    final url = Uri.parse('http://192.168.1.149:3005/api/users/delete');
    try {
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token'); // Clear the token
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted successfully.')),
        );
        Navigator.pushReplacementNamed(context, '/signin');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete account.')),
        );
      }
    } catch (error) {
      print('Error deleting account: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  Future<void> _updateUserProfile(String field, String value) async {
    final url = Uri.parse('http://192.168.1.149:3005/api/users/updated');
    final body = json.encode({field: value});

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        setState(() {
          if (field == 'name') _userName = value;
          if (field == 'email') _userEmail = value;
          if (field == 'phone_number') _userPhoneNo = value;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  Future<void> _showEditDialog(String title, String field, String initialValue) async {
    final controller = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: title),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _updateUserProfile(field, controller.text);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/signin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Greeting
              Text(
                "Hello, $_userName!",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 30),

              // Display user details
              _buildUserDetailCard('Name', _userName, 'name'),
              _buildUserDetailCard('Email', _userEmail, 'email'),
              _buildUserDetailCard('Phone Number', _userPhoneNo, 'phone_number'),
              _buildUserDetailCard('CNP', _userCNP),

              const SizedBox(height: 20),

              // Change Password Option
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.purple),
                title: const Text('Change Password'),
                onTap: () => _showChangePasswordDialog(),
              ),
              const Divider(),

              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete Account'),
                onTap: _deleteAccount,
              ),
              const Divider(),

              // Logout Option
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text('Logout'),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserDetailCard(String title, String value, [String? field]) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title),
        subtitle: Text(value),
        trailing: field != null
            ? IconButton(
          icon: const Icon(Icons.edit, color: Colors.purple),
          onPressed: () => _showEditDialog(title, field, value),
        )
            : null,
      ),
    );
  }

  Future<void> _showChangePasswordDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _oldPasswordController,
                decoration: const InputDecoration(labelText: 'Current Password'),
                obscureText: true,
              ),
              TextField(
                controller: _newPasswordController,
                decoration: const InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                // Implement the change password logic here
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }
}
