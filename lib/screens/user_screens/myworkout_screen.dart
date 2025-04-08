import 'package:flutter/material.dart';

class WorkoutSession {
  final String date;
  final String time;
  final String trainer;
  final String workoutType;
  final bool isCompleted;
  final String dietSuggestion;

  WorkoutSession({
    required this.date,
    required this.time,
    required this.trainer,
    required this.workoutType,
    this.isCompleted = false,
    required this.dietSuggestion,
  });
}

class WorkoutTrackerScreen extends StatefulWidget {
  @override
  _WorkoutTrackerScreenState createState() => _WorkoutTrackerScreenState();
}

class _WorkoutTrackerScreenState extends State<WorkoutTrackerScreen> {
  List<WorkoutSession> workoutSessions = [
    WorkoutSession(
      date: "10/04/2025",
      time: "18:00 - 19:00",
      trainer: "PT An",
      workoutType: "Cardio",
      isCompleted: true,
      dietSuggestion: "200g ức gà, 1 củ khoai lang (400 kcal)",
    ),
    WorkoutSession(
      date: "11/04/2025",
      time: "10:00 - 11:00",
      trainer: "PT Bình",
      workoutType: "Strength",
      isCompleted: false,
      dietSuggestion: "150g cá hồi, 100g gạo lứt (500 kcal)",
    ),
    WorkoutSession(
      date: "12/04/2025",
      time: "14:00 - 15:00",
      trainer: "PT Cường",
      workoutType: "Yoga",
      isCompleted: false,
      dietSuggestion: "Salad rau xanh, 1 quả trứng luộc (200 kcal)",
    ),
  ];

  // Hàm mở chatbot
  void _openChatbot(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _chatController = TextEditingController();
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Chatbot Hỗ trợ"),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tin nhắn mẫu từ chatbot
                        Container(
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.teal[50],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text("Xin chào! Tôi có thể giúp gì cho bạn hôm nay?"),
                        ),
                        // Thêm tin nhắn khác nếu cần
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _chatController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Nhập tin nhắn...",
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.teal),
                      onPressed: () {
                        if (_chatController.text.isNotEmpty) {
                          // Xử lý tin nhắn (ví dụ: in ra console)
                          print("Bạn: ${_chatController.text}");
                          _chatController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int completedSessions = workoutSessions.where((session) => session.isCompleted).length;
    int totalSessions = workoutSessions.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Theo dõi tập luyện", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tiến độ",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Đã hoàn thành: $completedSessions/$totalSessions buổi",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    CircularProgressIndicator(
                      value: totalSessions > 0 ? completedSessions / totalSessions : 0,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Lịch sử tập luyện",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: workoutSessions.length,
                itemBuilder: (context, index) {
                  final session = workoutSessions[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            session.isCompleted ? Icons.check_circle : Icons.pending,
                            color: session.isCompleted ? Colors.green : Colors.orange,
                            size: 30,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${session.date} - ${session.time}",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "PT: ${session.trainer}",
                                  style: TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "Loại: ${session.workoutType}",
                                  style: TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Chế độ ăn: ${session.dietSuggestion}",
                                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.black),
                            onPressed: () {
                              _showEditDialog(context, session, index);
                            },
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ],
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
          _openChatbot(context); // Mở chatbot thay vì thêm buổi tập
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.chat, color: Colors.white), // Thay biểu tượng "add" bằng "chat"
        tooltip: "Mở chatbot",
      ),
    );
  }

  void _showEditDialog(BuildContext context, WorkoutSession session, int index) {
    showDialog(
      context: context,
      builder: (context) {
        bool isCompleted = session.isCompleted;
        return AlertDialog(
          title: Text("Cập nhật buổi tập"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Ngày: ${session.date} - ${session.time}"),
              Text("PT: ${session.trainer}"),
              Text("Chế độ ăn: ${session.dietSuggestion}"),
              SizedBox(height: 10),
              CheckboxListTile(
                title: Text("Hoàn thành"),
                value: isCompleted,
                onChanged: (value) {
                  setState(() {
                    isCompleted = value!;
                  });
                },
                activeColor: Colors.teal,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  workoutSessions[index] = WorkoutSession(
                    date: session.date,
                    time: session.time,
                    trainer: session.trainer,
                    workoutType: session.workoutType,
                    isCompleted: isCompleted,
                    dietSuggestion: session.dietSuggestion,
                  );
                });
                Navigator.pop(context);
              },
              child: Text("Lưu"),
            ),
          ],
        );
      },
    );
  }
}