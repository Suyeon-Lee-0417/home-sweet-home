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
            // User Info Container
            Container(
              height: 90,
              decoration: BoxDecoration(
                color: Color(0xffDEF0EA),
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
                    Text('Hey, User!'),
                    Spacer(),
                    Text('Points Earned: 53 XP'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),
            Text(
              'Ranking',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
/*
            // Avatar Scroll List
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.purple,
                          backgroundImage: AssetImage('assets/imgs/pic.jpeg'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.purple,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
*/
            Text(
              "Let's make it shine!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            Expanded(
              child: Stack(
                children: List.generate(10, (index) {
                  final Color randomColor = tileColors[Random().nextInt(tileColors.length)];
                  return Positioned(
                    top: index * 40,
                    left: 0,
                    right: 0,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        tileColor: randomColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Task ${index + 1}',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text('7:00pm - 8:00pm', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
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

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
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
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Task Added Successfully!")),
                          );
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