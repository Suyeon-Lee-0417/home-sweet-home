import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://pineapple-6bdm.onrender.com/pineapple/api/auth"; 

  // ✅ Fetch user data with Debugging Logs
  Future<Map<String, dynamic>?> fetchUserData(String userId) async {
    try {
      print("🔹 Sending Request to: $baseUrl");
      print("🔹 User ID: $userId");

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"uid": userId}),
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
}