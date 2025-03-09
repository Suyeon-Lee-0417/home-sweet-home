class TaskModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String assignedTo;
  final String createdByUid;
  final String teamId;
  final String category;
  final DateTime dueDate;
  final int points;
  final String priority;
  final Recurrence? recurrence;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.assignedTo,
    required this.createdByUid,
    required this.teamId,
    required this.category,
    required this.dueDate,
    required this.points,
    required this.priority,
    this.recurrence,
  });

  // ✅ Factory constructor to create TaskModel from JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json["_id"] ?? "", // Use empty string as fallback
      title: json["title"] ?? "Untitled",
      description: json["description"] ?? "",
      isCompleted: json["isCompleted"] ?? false,
      assignedTo: json["assignedTo"] ?? "",
      createdByUid: json["createdByUid"] ?? "",
      teamId: json["teamId"] ?? "",
      category: json["category"] ?? "General",
      dueDate: DateTime.parse(json["dueDate"]),
      points: json["points"] ?? 0,
      priority: json["priority"] ?? "low",
      recurrence: json["recurrence"] != null
          ? Recurrence.fromJson(json["recurrence"])
          : null,
    );
  }

  // ✅ Convert TaskModel to JSON
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "title": title,
      "description": description,
      "isCompleted": isCompleted,
      "assignedTo": assignedTo,
      "createdByUid": createdByUid,
      "teamId": teamId,
      "category": category,
      "dueDate": dueDate.toIso8601String(),
      "points": points,
      "priority": priority,
      "recurrence": recurrence?.toJson(),
    };
  }
}

// ✅ Recurrence Model for Handling Repeated Tasks
class Recurrence {
  final String frequency; // daily, weekly, etc.
  final int interval; // Example: every 1 day
  final List<int>? weekdays; // Only for weekly recurrence (1 = Monday, 2 = Tuesday, etc.)
  final DateTime? endDate;

  Recurrence({
    required this.frequency,
    required this.interval,
    this.weekdays,
    this.endDate,
  });

  // ✅ Convert JSON to Recurrence Model
  factory Recurrence.fromJson(Map<String, dynamic> json) {
    return Recurrence(
      frequency: json["frequency"] ?? "daily",
      interval: json["interval"] ?? 1,
      weekdays: json["weekdays"] != null
          ? List<int>.from(json["weekdays"])
          : null,
      endDate: json["endDate"] != null ? DateTime.parse(json["endDate"]) : null,
    );
  }

  // ✅ Convert Recurrence Model to JSON
  Map<String, dynamic> toJson() {
    return {
      "frequency": frequency,
      "interval": interval,
      "weekdays": weekdays,
      "endDate": endDate?.toIso8601String(),
    };
  }
}