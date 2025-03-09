class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String profilePicUrl;
  int xpPoints; // Gamification feature
  List<String> tasksAssigned; // List of task IDs

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePicUrl,
    this.xpPoints = 0,
    this.tasksAssigned = const [],
  });

  // Convert UserModel to a Map (for Firebase/SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profilePicUrl': profilePicUrl,
      'xpPoints': xpPoints,
      'tasksAssigned': tasksAssigned,
    };
  }

  // Convert a Map back into a UserModel object
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      profilePicUrl: map['profilePicUrl'],
      xpPoints: map['xpPoints'] ?? 0,
      tasksAssigned: List<String>.from(map['tasksAssigned'] ?? []),
    );
  }
}