import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:pineapple/api/api_service.dart';
import 'package:pineapple/firebase/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser; // Get logged-in user

    void logout() async {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login'); // Redirect to login
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "logout") {
                logout();
                print("User logged out");
              } else if (value == "Create Room") {
                Navigator.pushNamed(context, '/create-room');
               // showCreateRoomModal(context);
                print("Navigate to Create Room");
              } else if (value == "Join Room") {
               // _showJoinRoomModal(context);
                 Navigator.pushNamed(context, '/join-room');
                print("Navigate to Join Room");
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: "Create Room",
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.black54),
                    SizedBox(width: 10),
                    Text("Create Room"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "Join Room",
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.black54),
                    SizedBox(width: 10),
                    Text("Join Room"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "logout",
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 10),
                    Text("Logout"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade300,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),

            // Display User Email
            Text(
              user?.email ?? "No Email Found",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Display User UID
            Text(
              "User ID: ${user?.uid ?? 'No UID'}",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            // Spacer to push Logout Button to the Bottom
            Expanded(child: SizedBox()),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: logout,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Logout",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }





     void _showJoinRoomModal(BuildContext context) {
      final TextEditingController _roomIdController = TextEditingController();

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Join Room",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // Room ID Field
                TextField(
                  controller: _roomIdController,
                  decoration: InputDecoration(
                    labelText: "Enter Room ID",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),

                // Join Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_roomIdController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter a valid Room ID")),
                        );
                      } else {
                        print("Joining Room: ${_roomIdController.text}");
                        Navigator.pop(context); // Close modal after entering
                      }
                    },
                    child: Text("Join Room"),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      );
    }
  
}