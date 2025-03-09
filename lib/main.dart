import 'package:flutter/material.dart';
import 'package:pineapple/screens/home-screen.dart';
import 'package:pineapple/screens/login-screen.dart';
import 'package:pineapple/screens/nav-screen.dart';
import 'package:pineapple/screens/sign-up-screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(),
      routes: {
        '/main-screen': (context) => MainScreen(),
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(),
      },
    )
  );
}

