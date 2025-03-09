import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pineapple/api/api_service.dart';
import 'package:pineapple/firebase/auth_service.dart';
import 'package:pineapple/model/UserModel.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  late Future<UserModel?> _userFuture;
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _userFuture = apiService.fetchUserData2(authService.getCurrentUser()!.uid); // Fetch user data
  }

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

  final List<Map<String, dynamic>> _tasks = [
    {
      "title": "Finish Flutter API Integration",
      "time": "9:00 AM - 10:30 AM",
      "description": "Complete API integration using Flutter.",
      "isCompleted": false,
    },
    {
      "title": "Design UI for Mobile App",
      "time": "11:00 AM - 12:00 PM",
      "description": "Create wireframes and mockups.",
      "isCompleted": false,
    },
    {
      "title": "Team Stand-up Meeting",
      "time": "12:30 PM - 1:00 PM",
      "description": "Daily progress discussion with the team.",
      "isCompleted": false,
    },
  ];

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
            // ✅ Fetch User Data & Display User Info
            FutureBuilder<UserModel?>(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildUserCard("Loading...", "Loading...");
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return _buildUserCard("Guest", "0 XP");
                } else {
                  final user = snapshot.data!;
                  return _buildUserCard("${user.firstName} ${user.lastName}", "${user.points} XP");
                }
              },
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _tasks[index]["title"],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            decoration: _tasks[index]["isCompleted"]
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                        ),
                                        Text(
                                          _tasks[index]["time"],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            decoration: _tasks[index]["isCompleted"]
                                                ? TextDecoration.lineThrough
                                                : null,
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

  // ✅ Build User Info Card
  Widget _buildUserCard(String userName, String points) {
    return Card(
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
            Text(
              'Hey, $userName!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Text(
              'Points Earned: $points',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

void _showBottomSheet(BuildContext context) {
  String _selectedCategory = "Chore"; // Default Category
  DateTime? _dueDate;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  final TextEditingController _assignedToController = TextEditingController();

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
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: EdgeInsets.all(16),
              height: 550,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "New Task",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  // ✅ Task Title Field
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: "Task Title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),

                  // ✅ Description Field
                  TextField(
                    controller: _descriptionController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: "Task Description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),

                  // ✅ Due Date Picker
                  Row(
                    children: [
                      Text(
                        _dueDate == null
                            ? "Select Due Date"
                            : "Due Date: ${_dueDate!.toLocal()}".split(' ')[0],
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

                  // ✅ Category Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    items: ["Chore", "Grocery"]
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setModalState(() {
                        _selectedCategory = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),

                  // ✅ Assigned To Field
                  TextField(
                    controller: _assignedToController,
                    decoration: InputDecoration(
                      labelText: "Assign To (User ID or Name)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),

                  // ✅ Points Field
                  TextField(
                    controller: _pointsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Points",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),

                  // ✅ Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_titleController.text.isNotEmpty) {
                          // Handle task creation here

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