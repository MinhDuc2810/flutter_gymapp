import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/adminapi_service.dart';

class PackageTabContent extends StatefulWidget {
  @override
  _PackageTabContentState createState() => _PackageTabContentState();
}

class _PackageTabContentState extends State<PackageTabContent> {
  late Future<List<Map<String, dynamic>>> _packagesFuture;

  @override
  void initState() {
    super.initState();
    _packagesFuture = AdminapiService.getPackages();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _packagesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Không có gói tập nào'));
        }

        final packages = snapshot.data!;

        return ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Text(
              'Gói tập luyện',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ...packages.map((package) {
              final price = int.tryParse(package['price']?.toString() ?? '0') ?? 0;
              final durationInDays = int.tryParse(package['durationInDays']?.toString() ?? '0') ?? 0;

              return _buildPackageItem(
                title: package['name'] ?? 'Gói không tên',
                price: price,
                description: package['description'] ?? 'Không có mô tả',
                durationInDays: durationInDays,
                onAddToCart: () {
                  // Hàm xử lý khi nhấn nút "Thêm vào giỏ hàng"
                  _addToCart(
                    context,
                    package['name'] ?? 'Gói không tên',
                    price,
                  );
                },
              );
            }).toList(),
          ],
        );
      },
    );
  }

  // Hàm xử lý thêm vào giỏ hàng
  void _addToCart(BuildContext context, String packageName, int price) {
    // Hiển thị thông báo xác nhận
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$packageName đã được thêm vào giỏ hàng! Giá: $price VNĐ'),
        duration: Duration(seconds: 2),
      ),
    );

    // Nếu bạn có hệ thống giỏ hàng, bạn có thể thêm logic ở đây
    // Ví dụ: gọi một hàm để thêm package vào giỏ hàng
    // cartProvider.addToCart(packageName, price);
  }

  Widget _buildPackageItem({
    required String title,
    required int price,
    required String description,
    required int durationInDays,
    required VoidCallback onAddToCart, // Thêm callback để xử lý nút "Thêm vào giỏ hàng"
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(description),
            SizedBox(height: 8),
            Text(
              durationInDays != 0
                  ? 'Thời gian: $durationInDays ngày'
                  : 'Thời gian: Không xác định',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            SizedBox(height: 8),
            Text(
              '$price VNĐ',
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(height: 8),
            // Thêm nút "Thêm vào giỏ hàng"
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onAddToCart, // Gọi hàm xử lý khi nhấn nút
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Màu nền của nút
                  foregroundColor: Colors.white, // Màu chữ/icon
                ),
                child: Text('Thêm vào giỏ hàng'),

              ),
            ),
          ],
        ),
      ),
    );
  }
}