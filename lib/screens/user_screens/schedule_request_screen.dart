import 'package:flutter/material.dart';

class PersonalTrainer {
  final String id;
  final String name;
  bool isSelected;

  PersonalTrainer({
    required this.id,
    required this.name,
    this.isSelected = false,
  });
}

class TimeSlot {
  final String time;
  bool isAvailable;

  TimeSlot({required this.time, this.isAvailable = true});
}

class PTScheduleScreen extends StatefulWidget {
  @override
  _PTScheduleScreenState createState() => _PTScheduleScreenState();
}

class _PTScheduleScreenState extends State<PTScheduleScreen> {
  List<PersonalTrainer> ptList = [
    PersonalTrainer(id: "1", name: "PT An"),
    PersonalTrainer(id: "2", name: "PT Bình"),
    PersonalTrainer(id: "3", name: "PT Cường"),
  ];

  List<TimeSlot> timeSlots = [
    TimeSlot(time: "08:00 - 09:00"),
    TimeSlot(time: "10:00 - 11:00"),
    TimeSlot(time: "14:00 - 15:00"),
    TimeSlot(time: "18:00 - 19:00"),
  ];

  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  final TextEditingController _scheduleController = TextEditingController();

  void togglePTSelection(int index) {
    setState(() {
      ptList[index].isSelected = !ptList[index].isSelected;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedTimeSlot = null;
      });
    }
  }

  void _selectTimeSlot(String timeSlot) {
    setState(() {
      _selectedTimeSlot = timeSlot;
      _scheduleController.text =
          "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} - $timeSlot";
    });
  }

  void submitRequest() {
    List<PersonalTrainer> selectedPTs = ptList.where((pt) => pt.isSelected).toList();
    if (selectedPTs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng chọn ít nhất 1 PT")),
      );
      return;
    }
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng chọn ngày")),
      );
      return;
    }
    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng chọn khung giờ")),
      );
      return;
    }

    String requestMessage =
        "Yêu cầu lịch tập: ${_scheduleController.text}\nPT đã chọn:\n";
    for (var pt in selectedPTs) {
      requestMessage += "- ${pt.name}\n";
    }

    print(requestMessage);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Đã gửi yêu cầu thành công!")),
    );

    setState(() {
      for (var pt in ptList) {
        pt.isSelected = false;
      }
      _selectedDate = null;
      _selectedTimeSlot = null;
      _scheduleController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Yêu cầu lịch tập',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chọn PT",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Danh sách PT chạy ngang
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ptList.length,
                  itemBuilder: (context, index) {
                    final pt = ptList[index];
                    return SizedBox(
                      width: 150,
                      child: Card(
                        elevation: 2,
                        child: CheckboxListTile(
                          title: Text(pt.name, style: TextStyle(fontSize: 14)),
                          value: pt.isSelected,
                          onChanged: (bool? value) {
                            togglePTSelection(index);
                          },
                          activeColor: Colors.teal,
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              // Chọn ngày
              Text(
                "Chọn ngày",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  _selectedDate == null
                      ? "Chọn ngày"
                      : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
              SizedBox(height: 20),
              // Chọn khung giờ (chỉ hiển thị khi đã chọn ngày)
              if (_selectedDate != null) ...[
                Text(
                  "Chọn khung giờ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: timeSlots.length,
                    itemBuilder: (context, index) {
                      final slot = timeSlots[index];
                      return SizedBox(
                        width: 120,
                        child: Card(
                          elevation: 2,
                          color: _selectedTimeSlot == slot.time
                              ? Colors.blue.withOpacity(0.2)
                              : null,
                          child: ListTile(
                            title: Text(slot.time, style: TextStyle(fontSize: 14)),
                            onTap: slot.isAvailable ? () => _selectTimeSlot(slot.time) : null,
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            trailing: slot.isAvailable
                                ? null
                                : Icon(Icons.lock, size: 18, color: Colors.grey),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              SizedBox(height: 20),
              // Hiển thị lịch tập yêu cầu
              Text(
                "Lịch tập yêu cầu",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _scheduleController,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Chọn ngày và khung giờ",
                  labelText: "Lịch tập mong muốn",
                ),
              ),
              SizedBox(height: 20),
              // Nút gửi yêu cầu
              Center(
                child: ElevatedButton(
                  onPressed: submitRequest,
                  child: Text("Gửi yêu cầu", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scheduleController.dispose();
    super.dispose();
  }
}