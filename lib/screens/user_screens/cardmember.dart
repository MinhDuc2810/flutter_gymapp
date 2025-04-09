import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thêm gói intl để format ngày

class CardDialog extends StatelessWidget {
  final Map<String, dynamic> cardData;
  final String username;

  const CardDialog({required this.cardData, required this.username});

  // Hàm để lấy màu dựa trên trạng thái
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey; // Màu mặc định nếu trạng thái không xác định
    }
  }

  // Hàm format ngày sang dd/mm/yyyy
  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'Không có';
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return date; // Trả về nguyên bản nếu không parse được
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardMember = cardData['cardMember'];

    return AlertDialog(
      title: Text(
        'My Card',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.credit_card, size: 50, color: Colors.black),
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Card ID: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold, // In đậm
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: cardMember['_id'] ?? 'Không có',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5), // Khoảng cách giữa các dòng
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Start Date: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold, // In đậm
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: _formatDate(cardMember['startDate']),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'End Date: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold, // In đậm
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: _formatDate(cardMember['endDate']),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Owner: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold, // In đậm
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: username,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Status: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold, // In đậm
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: cardMember['status'] ?? 'Không có',
                      style: TextStyle(
                        fontSize: 16,
                        color: _getStatusColor(cardMember['status']),
                        fontWeight: FontWeight.bold, // Giữ đậm cho trạng thái
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Đóng'),
        ),
      ],
    );
  }
}