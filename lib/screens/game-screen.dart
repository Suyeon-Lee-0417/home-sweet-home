import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Dummy User Data with Rankings
  final List<Map<String, String>> _users = [
    {"name": "Carol", "image": "assets/imgs/img-1.png"},
    {"name": "Alina", "image": "assets/imgs/img-2.png"},
    {"name": "Isabel", "image": "assets/imgs/img-3.png"},
    {"name": "Chaewon", "image": "assets/imgs/img-4.png"},
  ];

  // Dummy Prize Data
  final List<Map<String, String>> _prizes = [
    {"prize": "Free Coffee", "daysLeft": "2 Days Left"},
    {"prize": "Discount Coupon", "daysLeft": "3 Days Left"},
    {"prize": "Bonus XP", "daysLeft": "5 Days Left"},
    {"prize": "Mystery Box", "daysLeft": "7 Days Left"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background Color
      appBar: AppBar(
        title: Text(
          'Game Rankings 🏆',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 🔹 User Info Card
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Color(0xffB3CAF4), // Light Blue
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/imgs/pic.jpeg'),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Hey, Carol!',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      'Points: 53 XP',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🔹 Scrollable Row of User Rankings
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Color(0xFFFFA679), // Warm Peach Background
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_users.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // 🔹 Special Frame for First Place 🏆
                              if (index == 0)
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.yellow, // Outer Yellow Frame
                                      width: 8,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(3), // Inner blue frame
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.blue, // Inner Blue Frame
                                        width: 3,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(_users[index]["image"]!),
                                      radius: 35,
                                    ),
                                  ),
                                )
                              else
                                CircleAvatar(
                                  backgroundImage: AssetImage(_users[index]["image"]!),
                                  radius: 35,
                                ),

                              // 🔹 Rank Indicator (Number Badge)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black, width: 1),
                                  ),
                                  child: Text(
                                    "${index + 1}", // Ranks (1,2,3...)
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          // 🔹 User Name Display
                          Text(
                            _users[index]["name"]!,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          // 🔹 Sweet Treat Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Claim your Sweet Treat!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),

          // 🔹 Prize Grid (2x2)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                itemCount: _prizes.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Prevents scrolling
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // ✅ 2 Columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.2, // Adjusts height of boxes
                ),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFEBD7D7), // Soft Pink
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _prizes[index]["prize"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        SizedBox(height: 5),
                        Text(
                          _prizes[index]["daysLeft"]!,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}