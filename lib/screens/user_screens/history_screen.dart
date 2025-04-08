import 'package:flutter/material.dart';

// Model cho giao dịch
class Transaction {
  final String date;
  final String description;
  final double amount;
  final String status; // "success", "failed", "pending"

  Transaction({
    required this.date,
    required this.description,
    required this.amount,
    required this.status,
  });
}

class TransactionHistoryScreen extends StatefulWidget {
  @override
  _TransactionHistoryScreenState createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  // Danh sách giao dịch mẫu
  List<Transaction> transactions = [
    Transaction(
      date: "08/04/2025",
      description: "Thanh toán gói tập _sidebar: 1 tháng Gym - 1 buổi PT",
      amount: 1500000,
      status: "success",
    ),
    Transaction(
      date: "07/04/2025",
      description: "Mua dụng cụ tập gym",
      amount: 500000,
      status: "success",
    ),
    Transaction(
      date: "06/04/2025",
      description: "Thanh toán gói PT 5 buổi",
      amount: 2500000,
      status: "pending",
    ),
    Transaction(
      date: "05/04/2025",
      description: "Nạp tiền ví điện tử",
      amount: 1000000,
      status: "failed",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Transaction History', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề
            Text(
              "Giao dịch gần đây",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Danh sách giao dịch
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Biểu tượng trạng thái
                          _buildStatusIcon(transaction.status),
                          SizedBox(width: 12),
                          // Thông tin giao dịch
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction.date,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  transaction.description,
                                  style: TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // Số tiền
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${_formatAmount(transaction.amount)} VNĐ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: transaction.status == "failed" ? Colors.red : Colors.teal,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _getStatusText(transaction.status),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _getStatusColor(transaction.status),
                                ),
                              ),
                            ],
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
    );
  }

  // Hàm tạo biểu tượng trạng thái
  Widget _buildStatusIcon(String status) {
    switch (status) {
      case "success":
        return Icon(Icons.check_circle, color: Colors.green, size: 30);
      case "failed":
        return Icon(Icons.cancel, color: Colors.red, size: 30);
      case "pending":
        return Icon(Icons.hourglass_empty, color: Colors.orange, size: 30);
      default:
        return Icon(Icons.help, color: Colors.grey, size: 30);
    }
  }

  // Hàm định dạng số tiền
  String _formatAmount(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  // Hàm lấy văn bản trạng thái
  String _getStatusText(String status) {
    switch (status) {
      case "success":
        return "Thành công";
      case "failed":
        return "Thất bại";
      case "pending":
        return "Đang xử lý";
      default:
        return "Không xác định";
    }
  }

  // Hàm lấy màu trạng thái
  Color _getStatusColor(String status) {
    switch (status) {
      case "success":
        return Colors.green;
      case "failed":
        return Colors.red;
      case "pending":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}