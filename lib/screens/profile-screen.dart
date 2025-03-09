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
      backgroundColor: Colors.white, // Soft Yellow Background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
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
            icon: Icon(Icons.more_vert, color: Colors.black87),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: "Create Room", child: Text("Create Room")),
              PopupMenuItem(value: "Join Room", child: Text("Join Room")),
              PopupMenuItem(value: "logout", child: Text("Logout")),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromARGB(255, 195, 189, 121), // Light Orange
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
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
                  children: [
                    // 🌟 Profile Card
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Color(0xffFFAEBC), // Pastel Red
                            backgroundImage: AssetImage('assets/imgs/pic.jpeg'), // Default avatar
                          ),
                          SizedBox(height: 15),
                          Text(
                            "${user.firstName} ${user.lastName}",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(user.email, style: TextStyle(fontSize: 16, color: Colors.grey)),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 5),
                          Text(
                            "Team: ${user.teamName}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // 🌟 Users in Room Section
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
                              return Card(
                                color: Colors.white,
                                elevation: 3,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Color(0xffB3CAF4), // Light Blue
                                    backgroundImage: AssetImage('assets/imgs/pic.jpeg'), // Default avatar
                                  ),
                                  title: Text(
                                    "${teamUser["firstName"] ?? "Unknown User"}",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    teamUser["email"] ?? "No Email",
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    // 🌟 Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffFFAEBC), // Pastel Red
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Logout",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}