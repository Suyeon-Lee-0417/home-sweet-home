import 'package:flutter/material.dart';
import 'package:pineapple/screens/game-screen.dart';
import 'package:pineapple/screens/groceries-screen.dart';
import 'package:pineapple/screens/home-screen.dart';
import 'package:pineapple/screens/profile-screen.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 2; // Tracks selected tab index

  // List of screens for navigation
  static final List<Widget> _screens = [
    GroceriesScreen(),
    GameScreen(),
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
        backgroundColor: Colors.white, // Bottom bar background
        elevation: 5, // Shadow effect
        selectedItemColor: Color.fromARGB(255, 195, 189, 121), // Color for selected item
        unselectedItemColor: Colors.grey, // Inactive tab color
        showSelectedLabels: true, // ✅ Show text when selected
        showUnselectedLabels: true, // ✅ Show text when unselected
        items: [
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.shopping_cart, 0),
            label: 'Groceries',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.gamepad, 1),
            label: 'Game',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.home, 2),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.person, 3),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ✅ Custom method to wrap selected icon in a green circle
  Widget _buildNavIcon(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.all(isSelected ? 10 : 0), // Add padding for selected
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Color.fromARGB(255, 195, 189, 121) : Colors.transparent, // Selected color
          ),
          child: Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 28),
        ),
      ],
    );
  }
}