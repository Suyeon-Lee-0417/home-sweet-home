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
  AuthService authService = AuthService();
  late Future<UserModel?> _userFuture;
  Future<List<Map<String, dynamic>>?>? _teamMembersFuture;
  String? teamId;
   String? userFullName;
  Future<List<Map<String, dynamic>>?>? _tasksFuture;

  @override
  void initState() {
    super.initState();
    _fetchUserAndTeam();
    apiService.fetchTasks(authService.getCurrentUser()!.uid);
    
  }

  // ✅ Fetch User and Team Data
  void _fetchUserAndTeam() {
    _userFuture = apiService.fetchUserData2(authService.getCurrentUser()!.uid);
    
    _userFuture.then((user) {
      if (user != null && user.teamId.isNotEmpty) {
        setState(() {
          teamId = user.teamId;
          userFullName = user.firstName + " " + user.lastName;
          _teamMembersFuture = apiService.fetchUsersInRoom(teamId!);
          _tasksFuture = apiService.fetchTasks(authService.getCurrentUser()!.uid);
        });
      }
    });
  }

  final List<Color> tileColors = [
    Color(0xffF2FDBA), Color(0xffDEF0EA), Color(0xffB3CAF4),
    Color(0xffFFCCB6), Color(0xffC1E1C1), Color(0xffFFD6E0),
    Color(0xffE2C2FF), Color(0xffA0E7E5), Color(0xffFFAEBC),
    Color(0xffD4A5A5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Pineapple'), backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<UserModel?>(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return buildUserCard("Loading...", "Loading...");
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return buildUserCard("Guest", "0 XP");
                } else {
                  final user = snapshot.data!;
                  return buildUserCard("${user.firstName} ${user.lastName}", "${user.points} XP");
                }
              },
            ),
            SizedBox(height: 20),
            Text("Your tasks for Today :)", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),

           Expanded(
  child: FutureBuilder<List<Map<String, dynamic>>?>(
    future: _tasksFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator()); // Loading indicator
      } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
        return Center(child: Text("No tasks available."));
      } else {
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final task = snapshot.data![index];
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
                        value: task["isCompleted"] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            task["isCompleted"] = value!;
                          });
                        },
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task["title"],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: (task["isCompleted"] ?? false)
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            Text(
                              "Due: ${task["dueDate"].toString().split('T')[0]}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                decoration: (task["isCompleted"] ?? false)
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            Text(
                              "Assigned to:  $userFullName",
                              style: TextStyle(fontSize: 12, color: Colors.black54),
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
        );
      }
    },
  ),
),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (teamId != null) {
            _showBottomSheet(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ You are not in a team!")));
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // ✅ Build User Info Card
  Widget buildUserCard(String userName, String points) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(radius: 30, backgroundImage: AssetImage('assets/imgs/pic.jpeg')),
            SizedBox(width: 16),
            Text('Hey, $userName!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Spacer(),
            Text('Points: $points', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  // ✅ Show Bottom Sheet for Adding Tasks
  void _showBottomSheet(BuildContext context) {
    String _selectedCategory = "Chore";
    String _selectedPriority = "Medium";
    DateTime? _dueDate;
    String? _selectedUser;
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descriptionController = TextEditingController();
    final TextEditingController _pointsController = TextEditingController();

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: EdgeInsets.all(16),
                height: 650,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("New Task", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),

                    TextField(controller: _titleController, decoration: InputDecoration(labelText: "Task Title", border: OutlineInputBorder())),
                    SizedBox(height: 10),

                    TextField(controller: _descriptionController, maxLines: 2, decoration: InputDecoration(labelText: "Task Description", border: OutlineInputBorder())),
                    SizedBox(height: 10),

                    Row(
                      children: [
                        Text(_dueDate == null ? "Select Due Date" : "Due Date: ${_dueDate!.toLocal()}".split(' ')[0], style: TextStyle(fontSize: 16)),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.calendar_today, color: Colors.blue),
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2100));
                            if (pickedDate != null) setModalState(() { _dueDate = pickedDate; });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      items: ["Chore", "Grocery"].map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
                      onChanged: (value) { setModalState(() { _selectedCategory = value!; }); },
                      decoration: InputDecoration(labelText: "Category", border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: _selectedPriority,
                      items: ["High", "Medium", "Low"].map((priority) => DropdownMenuItem(value: priority, child: Text(priority))).toList(),
                      onChanged: (value) { setModalState(() { _selectedPriority = value!; }); },
                      decoration: InputDecoration(labelText: "Priority", border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 10),

                    FutureBuilder<List<Map<String, dynamic>>?>(
                      future: _teamMembersFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                          return Text("No team members found.");
                        } else {
                          return DropdownButtonFormField<Object>(
                            value: _selectedUser,
                            items: snapshot.data!.map((user) {
                              return DropdownMenuItem(value: user['_id'], child: Text("${user['firstName']} ${user['lastName']}"));
                            }).toList(),
                            onChanged: (value) { setModalState(() { _selectedUser = value! as String?; }); },
                            decoration: InputDecoration(labelText: "Assign To", border: OutlineInputBorder()),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 10),

                    TextField(controller: _pointsController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Points", border: OutlineInputBorder())),
                    SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
         child: ElevatedButton(
  onPressed: () async {
    // Validate Required Fields
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _dueDate == null ||
        _selectedUser == null ||
        _pointsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ All fields are required!")),
      );
      return;
    }

    // Convert Points Safely
    int? points = int.tryParse(_pointsController.text);
    if (points == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Points must be a valid number!")),
      );
      return;
    }

    // Call API to Add Task
    bool success = await apiService.addTask(
      teamId: teamId!, // Ensure teamId is not null
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _dueDate!,
      category: _selectedCategory,
      priority: _selectedPriority,
      assignedTo: _selectedUser!,
      createdByUid: authService.getCurrentUser()!.uid, // Pass the logged-in user ID
      points: points,
    );

    // Handle Response
    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🎉 Task Added Successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to add task.")),
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