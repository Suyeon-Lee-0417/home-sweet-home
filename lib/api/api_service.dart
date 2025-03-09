import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pineapple/model/UserModel.dart';

class ApiService {
  final String baseUrl = "https://pineapple-6bdm.onrender.com/pineapple/api"; 

  // ✅ Fetch user data with Debugging Logs
  Future<Map<String, dynamic>?> fetchUserData(String userId, String firstName, String lastName) async {
    try {
      print("🔹 Sending Request to: $baseUrl");
      print("🔹 User ID: $userId");

      final response = await http.post(
        Uri.parse('$baseUrl/auth'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"uid": userId, "firstname": firstName, "lastname": lastName}),
      ).timeout(Duration(seconds: 10)); // Timeout after 10 seconds

      print("🔹 Response Status Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("❌ Error: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return null;
    }
  }


Future<String?> getRoomId(String userId, String teamName) async {
  final String endpoint = "$baseUrl/teams"; // Ensure this is correct

  try {
    print("🚀 Sending request to: $endpoint");
    print("📤 Request Body: ${jsonEncode({"adminUid": userId, "name": teamName})}");

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({"adminUid": userId, "name": teamName}),
    );

    print("📩 Response Status Code: ${response.statusCode}");
    print("📩 Response Body: ${response.body}");

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      
      if (data.containsKey("joinToken")) {
        print("✅ Room ID received: ${data["joinToken"]}");
        return data["joinToken"];
      } else {
        print("⚠️ Response does not contain 'joinToken' key.");
        return null;
      }
    } else {
      print("❌ Failed to fetch Room ID. Status Code: ${response.statusCode}");
      print("❌ Error Response: ${response.body}");
      return null;
    }
  } catch (e) {
    print("🔥 Exception: $e");
    return null;
  }
}



Future<String?> joinRoom(String userId, String joinToken) async {
  final String endpoint = "$baseUrl/teams/join"; // Adjust with actual backend URL

  try {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "uid": userId,        // Pass user ID
        "joinToken": joinToken,  // Pass room join token
      }),
    );

    print("🔹 Response Status Code: ${response.statusCode}");
    print("🔹 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["team"]["name"]; // Assuming the response contains { "roomId": "ROOM12345" }
    } else {
      print("❌ Failed to join room. Status: ${response.statusCode}");
      return response.statusCode.toString();
    }
  } catch (e) {
    print("❌ Error joining room: $e");
    return null;
  }
}

Future<UserModel?> fetchUserData2(String userId) async {
  try {
    final String endpoint = "$baseUrl/users/$userId"; // ✅ Pass userId as a query parameter

    print("🔹 Sending Request to: $endpoint");

    final response = await http.get(
      Uri.parse(endpoint), // ✅ Corrected GET request
      headers: {
        "Content-Type": "application/json",
      },
    ).timeout(Duration(seconds: 10));

    print("🔹 Response Status Code: ${response.statusCode}");
    print("🔹 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = jsonDecode(response.body);
      return UserModel.fromJson(userData); // ✅ Convert JSON response to UserModel
    } else {
      print("❌ Error: ${response.reasonPhrase}");
      return null;
    }
  } catch (e) {
    print("❌ Exception: $e");
    return null;
  }
}

Future<List<Map<String, dynamic>>?> fetchUsersInRoom(String teamId) async {
  final String endpoint = "$baseUrl/teams/$teamId/users"; // Adjust if needed

  try {
    print("🚀 Sending GET request to: $endpoint");

    final response = await http.get(
      Uri.parse(endpoint),
      headers: {"Content-Type": "application/json"},
    ).timeout(Duration(seconds: 10));

    print("📩 Response Status Code: ${response.statusCode}");
    print("📜 Raw Response Body:\n${response.body}");

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> body = jsonDecode(response.body);
        print("🔍 Decoded JSON: $body");

        if (body.containsKey("users") && body["users"] is List) {
          List<dynamic> usersList = body["users"];
          print("✅ Parsed User List Successfully: ${usersList.length} users found.");

          for (var user in usersList) {
            print("👤 User: ${user["_id"]}, Name: ${user["firstName"]} ${user["lastName"]}, Email: ${user["email"]}");
          }

          return usersList.map((user) => user as Map<String, dynamic>).toList();
        } else {
          print("❌ Unexpected response format: Expected a 'users' key with a List, got ${body.runtimeType}");
          return null;
        }
      } catch (e) {
        print("❌ JSON Parsing Error: $e");
        return null;
      }
    } else {
      print("❌ Failed Request: ${response.reasonPhrase}");
      print("🔎 Response Body: ${response.body}");
      return null;
    }
  } catch (e) {
    print("🔥 Network Exception: $e");
    return null;
  }
}


 Future<bool> addTask({
  required String teamId,
  required String title,
  required String description,
  required DateTime dueDate,
  required String category,
  required String assignedTo,
  required String createdByUid,
  required int points,
  String priority = "low",
  Map<String, dynamic>? recurrence,
}) async {
  final String endpoint = "$baseUrl/tasks"; // Ensure this is correct!

  try {
    print("🚀 Sending POST request to: $endpoint");

    final Map<String, dynamic> taskData = {
      "teamId": teamId,
      "title": title,
      "description": description,
      "dueDate": dueDate.toIso8601String(),
      "category": category,
      "assignedTo": assignedTo,
      "createdByUid": createdByUid,
      "points": points,
      "priority": priority,
      if (recurrence != null) "recurrence": recurrence,
    };

    print("📤 Request Body: ${jsonEncode(taskData)}");

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(taskData),
    );

    print("📩 Response Status Code: ${response.statusCode}");
    print("📩 Response Body: ${response.body}");

    if (response.statusCode == 201) {
      print("✅ Task added successfully!");
      return true;
    } else {
      print("❌ Failed to add task. Status Code: ${response.statusCode}");
      print("🔎 Error Details: ${response.body}");
      return false;
    }
  } catch (e) {
    print("🔥 Network Exception: $e");
    return false;
  }
}

}