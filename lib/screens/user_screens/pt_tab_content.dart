import 'package:flutter/material.dart';

class PTTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        Text(
          'Huấn luyện viên cá nhân',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        _buildPTItem(
          name: 'Nguyễn Văn A',
          specialty: 'Giảm cân',
          rating: 4.8,
        ),
        _buildPTItem(
          name: 'Trần Thị B',
          specialty: 'Tăng cơ',
          rating: 4.9,
        ),
      ],
    );
  }

  Widget _buildPTItem({
    required String name,
    required String specialty,
    required double rating,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(name),
        subtitle: Text('Chuyên môn: $specialty'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: Colors.yellow, size: 20),
            Text('$rating'),
          ],
        ),
      ),
    );
  }
}