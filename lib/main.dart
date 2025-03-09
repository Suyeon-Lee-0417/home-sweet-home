import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pineapple/api/api_service.dart';
import 'package:pineapple/screens/login-screen.dart';
import 'package:pineapple/screens/nav-screen.dart';
import 'package:pineapple/screens/sign-up-screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService(); // ✅ Initialize API Service

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthCheck(apiService: apiService), // Pass API service
      routes: {
        '/main-screen': (context) => Navigation(),
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}

// ✅ Check authentication and initialize API
class AuthCheck extends StatelessWidget {
  final ApiService apiService; // Accept API service
  AuthCheck({required this.apiService});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator())); // Loading state
        }
        if (snapshot.hasData) {
          return Navigation(); // User is logged in
        } else {
          return LoginScreen(); // User is not logged in
        }
      },
    );
  }
}