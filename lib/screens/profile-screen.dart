import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pineapple/api/api_service.dart';
import 'package:pineapple/model/UserModel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService apiService = ApiService();
  final User? firebaseUser = FirebaseAuth.instance.currentUser;
  late Future<UserModel?> _userFuture;
  Future<List<Map<String, dynamic>>?>? _usersFuture;

  @override
  void initState() {
    super.initState();
    if (firebaseUser != null) {
      _userFuture = apiService.fetchUserData2(firebaseUser!.uid);
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // Redirect to login
  }

  @override
  Widget build(BuildContext context) {
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
              } else if (value == "Create Room") {
                Navigator.pushNamed(context, '/create-room');
              } else if (value == "Join Room") {
                Navigator.pushNamed(context, '/join-room');
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: "Create Room", child: Text("Create Room")),
              PopupMenuItem(value: "Join Room", child: Text("Join Room")),
              PopupMenuItem(value: "logout", child: Text("Logout")),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: FutureBuilder<UserModel?>(
          future: _userFuture,
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (userSnapshot.hasError || userSnapshot.data == null) {
              return Center(child: Text("❌ Error loading profile"));
            }

            final user = userSnapshot.data!;
            _usersFuture ??= apiService.fetchUsersInRoom(user.teamId);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🔹 Profile Picture
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),

                // 🔹 Display User Name & Email
                Text(
                  "${user.firstName} ${user.lastName}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  user.email,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),

                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 10),

                // 🔹 Team Name
                Text(
                  "Team: ${user.teamName}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // 🔹 Users in Room Section
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>?>(
                    future: _usersFuture,
                    builder: (context, usersSnapshot) {
                      if (usersSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (usersSnapshot.hasError || usersSnapshot.data == null) {
                        return Center(child: Text("❌ Error loading users"));
                      } else if (usersSnapshot.data!.isEmpty) {
                        return Center(child: Text("No users in this team"));
                      }

                      return ListView.builder(
                        itemCount: usersSnapshot.data!.length,
                        itemBuilder: (context, index) {
                          final teamUser = usersSnapshot.data![index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey.shade300,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(teamUser["firstName"] ?? "Unknown User"),
                            subtitle: Text(teamUser["email"] ?? "No Email"),
                          );
                        },
                      );
                    },
                  ),
                ),

                // 🔹 Logout Button
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
                    child: Text("Logout", style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}