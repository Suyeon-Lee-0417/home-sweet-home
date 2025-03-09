class UserModel {
  final String id;
  final String firebaseUid;
  final String email;
  final String displayName;
  final String firstName;
  final String lastName;
  final int points;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.firebaseUid,
    required this.email,
    required this.displayName,
    required this.firstName,
    required this.lastName,
    required this.points,
    required this.createdAt,
    required this.updatedAt,
  });

  // ✅ Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json["user"] ?? {}; // Make sure "user" exists before parsing

    return UserModel(
      id: user["_id"] ?? "",  // Use empty string as fallback
      firebaseUid: user["firebaseUid"] ?? "",
      email: user["email"] ?? "",
      displayName: user["displayName"] ?? "",
      firstName: user["firstName"] ?? "Guest", // Default name if null
      lastName: user["lastName"] ?? "",
      points: user["points"] ?? 0, // Default to 0
      createdAt: DateTime.tryParse(user["createdAt"] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(user["updatedAt"] ?? "") ?? DateTime.now(),
    );
  }

  // ✅ Convert UserModel to JSON for storing locally
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "firebaseUid": firebaseUid,
      "email": email,
      "displayName": displayName,
      "firstName": firstName,
      "lastName": lastName,
      "points": points,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}