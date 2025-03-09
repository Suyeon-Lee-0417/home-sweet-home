import 'dart:math';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Color> tileColors = [
    Color(0xffF2FDBA), // Soft Yellow
    Color(0xffDEF0EA), // Light Teal
    Color(0xffB3CAF4), // Light Blue
    Color(0xffFFCCB6), // Peach
    Color(0xffC1E1C1), // Soft Green
    Color(0xffFFD6E0), // Light Pink
    Color(0xffE2C2FF), // Soft Purple
    Color(0xffA0E7E5), // Cyan
    Color(0xffFFAEBC), // Pastel Red
    Color(0xffD4A5A5), // Muted Rose
  ];


  // ✅ Task List with Completion Status
  final List<Map<String, dynamic>> _tasks = [
    {
      "title": "Finish Flutter API Integration",
      "time": "9:00 AM - 10:30 AM",
      "description": "Complete the integration with our RESTful API using Flutter's http package.",
      "isCompleted": false, // Track completion status
    },
    {
      "title": "Design UI for Mobile App",
      "time": "11:00 AM - 12:00 PM",
      "description": "Create wireframes and mockups in Figma for the new mobile app.",
      "isCompleted": false,
    },
    {
      "title": "Team Stand-up Meeting",
      "time": "12:30 PM - 1:00 PM",
      "description": "Discuss daily progress, blockers, and next steps with the team.",
      "isCompleted": false,
    },
  ];


 

  // Controllers for adding tasks
  DateTime? _dueDate;
  String _selectedPriority = 'Medium';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _assignedToController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pineapple'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/imgs/pic.jpeg'),
                    ),
                    SizedBox(width: 16),
                    Text('Hey, User!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Spacer(),
                    Text('Points Earned: 53 XP',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),
            Text(
              "Your tasks for Today :)",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            Expanded(
              child: _tasks.isEmpty
                  ? Center(child: Text("No tasks yet. Tap + to add a new task!"))
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final Color randomColor = tileColors[index % tileColors.length];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: randomColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  // ✅ Checkbox - Updates taskCompletion in Data
                                  Checkbox(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    value: _tasks[index]["isCompleted"],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _tasks[index]["isCompleted"] = value!;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 8),

                                  // ✅ Task Title & Time
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _tasks[index]["title"],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            decoration: _tasks[index]["isCompleted"] ? TextDecoration.lineThrough : null,
                                          ),
                                        ),
                                        Text(
                                          _tasks[index]["time"],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            decoration: _tasks[index]["isCompleted"] ? TextDecoration.lineThrough : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),   
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // ✅ Function to add a new task to the list
  void _addTask(String title, String time) {
    setState(() {
      _tasks.add({
        "title": title,
        "time": time,
      });
    });
  }

  // ✅ Function to show the Bottom Sheet for Adding Tasks
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                height: 600,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "New Task",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),

                    // Task Title Field
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: "Task Title",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Description Field
                    TextField(
                      controller: _descriptionController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Due Date Picker
                    Row(
                      children: [
                        Text(
                          _dueDate == null ? "Select Due Date" : "Due Date: ${_dueDate!.toLocal()}".split(' ')[0],
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.calendar_today, color: Colors.blue),
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setModalState(() {
                                _dueDate = pickedDate;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Priority Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedPriority,
                      items: ['Low', 'Medium', 'High']
                          .map((priority) => DropdownMenuItem(
                                value: priority,
                                child: Text(priority),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setModalState(() {
                          _selectedPriority = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Priority",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Assigned To Field
                    TextField(
                      controller: _assignedToController,
                      decoration: InputDecoration(
                        labelText: "Assign To",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_titleController.text.isNotEmpty) {
                            _addTask(
                              _titleController.text,
                              _dueDate != null
                                  ? "Due: ${_dueDate!.toLocal()}".split(' ')[0]
                                  : "No Due Date",
                            );

                            _titleController.clear();
                            _descriptionController.clear();
                            _assignedToController.clear();
                            _dueDate = null; // Reset due date
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Task Added Successfully!")),
                            );
                          }
                        },
                        child: Text("Add Task"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}