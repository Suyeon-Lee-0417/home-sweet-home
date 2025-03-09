import 'package:flutter/material.dart';

class GroceriesScreen extends StatefulWidget {
  const GroceriesScreen({super.key});

  @override
  State<GroceriesScreen> createState() => _GroceriesScreenState();
}

class _GroceriesScreenState extends State<GroceriesScreen> {
  // Dummy Grocery List Data
  final List<Map<String, dynamic>> _groceries = [
    {"name": "Milk", "description": "2L of Whole Milk", "amount": "1", "bought": false, "checkedBy": null},
    {"name": "Eggs", "description": "Dozen Eggs", "amount": "1", "bought": false, "checkedBy": null},
    {"name": "Bread", "description": "Whole Wheat Bread", "amount": "2", "bought": false, "checkedBy": null},
  ];

  // Dummy User Data
  final Map<String, dynamic> _currentUser = {
    "name": "Sydney",
    "profilePic": "assets/imgs/img-3.png",
  };

  // Function to Toggle Checkbox
  void _toggleBought(int index) {
    setState(() {
      _groceries[index]["bought"] = !_groceries[index]["bought"];
      _groceries[index]["checkedBy"] = _groceries[index]["bought"] ? _currentUser : null;
    });
  }

  // Function to Show Modal Sheet for Adding a Grocery Item
  void _showAddGroceryModal(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _descriptionController = TextEditingController();
    final TextEditingController _amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add Grocery Item", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),

              // Item Name Field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Item Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 10),

              // Description Field
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 10),

              // Amount Field
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Quantity",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 20),

              // Add Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.trim().isEmpty || _amountController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please fill in all fields")),
                      );
                      return;
                    }

                    setState(() {
                      _groceries.add({
                        "name": _nameController.text.trim(),
                        "description": _descriptionController.text.trim(),
                        "amount": _amountController.text.trim(),
                        "bought": false,
                        "checkedBy": null,
                      });
                    });

                    Navigator.pop(context);
                  },
                  child: Text("Add Grocery"),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Grocery List', style: TextStyle(color: Color(0xffFE6C23), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color.fromARGB(255, 195, 189, 121),
              ),
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              itemCount: _groceries.length,
              itemBuilder: (context, index) {
                final item = _groceries[index];
                final bool isChecked = item["bought"];
                final Map<String, dynamic>? checkedBy = item["checkedBy"];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: Card(
                    color: Color.fromARGB(255, 255, 255, 255),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // Checkbox
                          Checkbox(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            value: isChecked,
                            onChanged: (bool? value) {
                              _toggleBought(index);
                            },
                          ),
                          SizedBox(width: 10),

                          // Item Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["name"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    decoration: isChecked ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                                Text(
                                  item["description"],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    decoration: isChecked ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Quantity
                          Text(
                            "x${item["amount"]}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: isChecked ? TextDecoration.lineThrough : null,
                            ),
                          ),

                          // Show User Image & Name if Checked Off
                          if (checkedBy != null) ...[
                            SizedBox(width: 10),
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage: AssetImage(checkedBy["profilePic"]),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  checkedBy["name"],
                                  style: TextStyle(fontSize: 10, color: Colors.black),
                                ),
                              ],
                            ),
                          ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddGroceryModal(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}