import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoomJoinedScreen extends StatelessWidget {
  final String roomName; // Room Name Passed from Previous Screen

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
                "You've joined the **$roomName** room!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // 🎥 Animated GIF
              Image.asset(
                "assets/gifs/congrats.gif", // Replace with actual asset path
                height: 200,
                width: 200,
              ),
              SizedBox(height: 20),

              // ✅ OK Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("OK", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}