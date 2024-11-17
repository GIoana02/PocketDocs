import 'package:flutter/material.dart';
import 'screens/signin_page.dart';
import 'screens/signup_page.dart'; 
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/signup', // Default route to Sign Up page
      routes: {
        '/signup': (context) => SignUpPage(), // Sign Up Page route
        '/signin': (context) => SignInPage(), // Sign In Page route
        '/home': (context) => HomePage(), // Home Page route
      },
    );
  }
}
