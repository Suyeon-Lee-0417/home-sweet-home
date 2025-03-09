import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoomJoinedScreen extends StatelessWidget {
  final Future<String?> roomName; // Room Name Passed from Previous Screen

  const RoomJoinedScreen({super.key, required this.roomName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Room Joined"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🎉 Congrats Message
              Text(
                "🎉 Congrats! 🎉",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),

              // 📢 Room Name Message
              Text(
                "You've joined the room!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}