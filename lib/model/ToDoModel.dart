class Todo {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String priority; // Low, Medium, High
  final String assignedTo;
  bool isCompleted; // Task status

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.assignedTo,
    this.isCompleted = false,
  });

  // Convert Todo to a Map (for databases like Firebase or SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'assignedTo': assignedTo,
      'isCompleted': isCompleted ? 1 : 0, // Store as an integer (0 = false, 1 = true)
    };
  }

  // Convert a Map back into a Todo object
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      priority: map['priority'],
      assignedTo: map['assignedTo'],
      isCompleted: map['isCompleted'] == 1, // Convert integer to boolean
    );
  }
}