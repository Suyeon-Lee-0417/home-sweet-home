

import 'package:flutter/material.dart';
import 'package:pineapple/api/api_service.dart';
import 'package:pineapple/firebase/auth_service.dart';
import 'package:pineapple/main.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _roomCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ApiService apiService = ApiService();
  AuthService authService = AuthService();

  void _joinRoom() {
    if (_formKey.currentState!.validate()) {
      Future<String?> roomName = apiService.joinRoom(authService.getCurrentUser()!.uid, _roomCodeController.text);

      print("Joining Room: $roomName");

      // TODO: Implement API call to join the room
      Navigator.pushNamed(context, '/room-joined', arguments: roomName);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Joining Room: $roomName")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Join Room'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter Room Code",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Room Code Input Form
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _roomCodeController,
                decoration: InputDecoration(
                  hintText: "Enter Room Code",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a room code";
                  } 
                  return null;
                },
              ),
            ),
            SizedBox(height: 20),

            // Join Room Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _joinRoom,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Join Room",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}