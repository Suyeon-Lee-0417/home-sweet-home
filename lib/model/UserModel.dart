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

  // 🔹 Team Details
  final String teamId;
  final String teamName;
  final List<String> memberIds;
  final List<String> tasksIds;
  final String adminId;
  final DateTime teamCreatedAt;
  final DateTime teamUpdatedAt;

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
    required this.teamId,
    required this.teamName,
    required this.memberIds,
    required this.tasksIds,
    required this.adminId,
    required this.teamCreatedAt,
    required this.teamUpdatedAt,
  });

  // ✅ Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json["user"] ?? {};
    final team = json["team"] ?? {};

    return UserModel(
      // 🔹 User Info
      id: user["_id"] ?? "",
      firebaseUid: user["firebaseUid"] ?? "",
      email: user["email"] ?? "",
      displayName: user["displayName"] ?? "",
      firstName: user["firstName"] ?? "Guest",
      lastName: user["lastName"] ?? "",
      points: user["points"] ?? 0,
      createdAt: DateTime.tryParse(user["createdAt"] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(user["updatedAt"] ?? "") ?? DateTime.now(),

      // 🔹 Team Info
      teamId: team["_id"] ?? "",
      teamName: team["name"] ?? "No Team",
      memberIds: List<String>.from(team["memberIds"] ?? []),
      tasksIds: List<String>.from(team["tasksIds"] ?? []),
      adminId: team["adminId"] ?? "",
      teamCreatedAt: DateTime.tryParse(team["createdAt"] ?? "") ?? DateTime.now(),
      teamUpdatedAt: DateTime.tryParse(team["updatedAt"] ?? "") ?? DateTime.now(),
    );
  }

  // ✅ Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      // 🔹 User Info
      "_id": id,
      "firebaseUid": firebaseUid,
      "email": email,
      "displayName": displayName,
      "firstName": firstName,
      "lastName": lastName,
      "points": points,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),

      // 🔹 Team Info
      "team": {
        "_id": teamId,
        "name": teamName,
        "memberIds": memberIds,
        "tasksIds": tasksIds,
        "adminId": adminId,
        "createdAt": teamCreatedAt.toIso8601String(),
        "updatedAt": teamUpdatedAt.toIso8601String(),
      },
    };
  }
}