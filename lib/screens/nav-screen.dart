
import 'package:flutter/material.dart';
import 'package:pineapple/screens/groceries-screen.dart';
import 'package:pineapple/screens/home-screen.dart';
import 'package:pineapple/screens/profile-screen.dart';


class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 1; // Tracks selected tab index

  // List of screens for navigation
  static final List<Widget> _screens = [
    GroceriesScreen(),
    HomeScreen(),
    ProfileScreen()
  ];

  // Function to handle navigation item taps
  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Highlight selected tab
        onTap: _onItemTapped, // Call function when an item is tapped
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple, // Active tab color
        unselectedItemColor: Colors.grey, // Inactive tab color
        backgroundColor: Colors.white, // Bottom bar background
        elevation: 5, // Shadow effect
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Groceries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}