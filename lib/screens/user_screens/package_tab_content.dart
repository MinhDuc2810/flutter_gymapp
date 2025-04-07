import 'package:flutter/material.dart';

class PackageTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        Text(
          'Gói tập luyện',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        _buildPackageItem(
          title: 'Gói cơ bản',
          price: '500.000 VNĐ/tháng',
          description: 'truy cập phòng gym không giới hạn',
        ),
        _buildPackageItem(
          title: 'Gói nâng cao',
          price: '800.000 VNĐ/tháng',
          description: 'Gym + Huấn luyện viên cá nhân',
        ),
      ],
    );
  }

  Widget _buildPackageItem({
    required String title,
    required String price,
    required String description,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(description),
            SizedBox(height: 8),
            Text(price, style: TextStyle(color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}