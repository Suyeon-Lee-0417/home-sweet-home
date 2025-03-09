import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pineapple/api/api_service.dart';
import 'package:pineapple/firebase/auth_service.dart';


class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  _CreateRoomScreenState createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _roomNameController = TextEditingController();
  String _roomId = '';
  bool _isLoading = false;
  String? _errorText; // Error message for validation
  ApiService apiService = ApiService(); // ✅ Initialize API Service
  AuthService authService = AuthService(); // ✅ Initialize Auth Service

  // Function to Call Backend & Generate Room ID
// Function to Call Backend & Generate Room ID
Future<void> _generateRoomId() async {
  if (_roomNameController.text.trim().isEmpty) {
    setState(() {
      _errorText = "Room name cannot be empty";
    });
    return;
  }

  setState(() {
    _isLoading = true;
    _errorText = null;
  });

  try {
    String? roomId = await apiService.getRoomId(authService.getCurrentUser()!.uid, _roomNameController.text);
    
    if (roomId != null) {
      setState(() {
        _roomId = roomId;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to generate Room ID")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}
  // Function to Copy Room ID
  void _copyRoomId() {
    Clipboard.setData(ClipboardData(text: _roomId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Room ID copied!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Create Room'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room Name Field
            Text(
              "Room Name",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _roomNameController,
              decoration: InputDecoration(
                hintText: "Enter room name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                errorText: _errorText, // Show error text if validation fails
              ),
              onChanged: (value) {
                if (_errorText != null && value.trim().isNotEmpty) {
                  setState(() {
                    _errorText = null; // Remove error when user types
                  });
                }
              },
            ),
            SizedBox(height: 20),

            // Generate Room ID Button
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _generateRoomId,
                child: _isLoading
                    ? SizedBox(
                        width: 20, height: 20, 
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text("Generate Room ID"),
              ),
            ),
            SizedBox(height: 20),

            // Display Room ID (if available)
            if (_roomId.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Room ID: $_roomId",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  SizedBox(height: 10),

                  // Copy Room ID Button
                  ElevatedButton.icon(
                    onPressed: _copyRoomId,
                    icon: Icon(Icons.copy),
                    label: Text("Copy Room ID"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
