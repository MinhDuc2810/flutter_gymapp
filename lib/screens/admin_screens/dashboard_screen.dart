import 'package:flutter/material.dart';

// Model giao dịch
class Transaction {
  final String date;
  final String description;
  final double amount;
  final String status;

  Transaction({
    required this.date,
    required this.description,
    required this.amount,
    required this.status,
  });
}

class RevenueDashboardScreen extends StatefulWidget {
  @override
  _RevenueDashboardScreenState createState() => _RevenueDashboardScreenState();
}

class _RevenueDashboardScreenState extends State<RevenueDashboardScreen> {
  // Dữ liệu mẫu
  DateTime? selectedDate;
  String? selectedMonth;
  List<String> months = [
    "Tháng 1", "Tháng 2", "Tháng 3", "Tháng 4", "Tháng 5", "Tháng 6",
    "Tháng 7", "Tháng 8", "Tháng 9", "Tháng 10", "Tháng 11", "Tháng 12"
  ];

  // Dữ liệu doanh thu mẫu (có thể thay bằng API)
  Map<String, double> dailyRevenue = {
    "01/04/2025": 2000000,
    "02/04/2025": 1500000,
    "03/04/2025": 3000000,
    "04/04/2025": 2500000,
    "05/04/2025": 4000000,
    "06/04/2025": 3500000,
    "07/04/2025": 3000000,
    "08/04/2025": 3500000,
  };

  List<Transaction> transactions = [
    Transaction(date: "08/04/2025", description: "Thanh toán gói tập 1 tháng", amount: 1500000, status: "success"),
    Transaction(date: "07/04/2025", description: "Mua dụng cụ tập gym", amount: 500000, status: "success"),
    Transaction(date: "06/04/2025", description: "Thanh toán gói PT 5 buổi", amount: 2500000, status: "pending"),
  ];

  // Hàm chọn ngày
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025, 1, 1),
      lastDate: DateTime(2025, 12, 31),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedMonth = null; // Reset tháng khi chọn ngày
      });
    }
  }

  // Hàm tính doanh thu theo ngày/tháng
  double _calculateRevenue() {
    if (selectedDate != null) {
      String dateKey = "${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}";
      return dailyRevenue[dateKey] ?? 0.0;
    } else if (selectedMonth != null) {
      int monthIndex = months.indexOf(selectedMonth!) + 1;
      return dailyRevenue.entries
          .where((entry) => int.parse(entry.key.split('/')[1]) == monthIndex)
          .fold(0.0, (sum, entry) => sum + entry.value);
    }
    return dailyRevenue.values.fold(0.0, (sum, value) => sum + value); // Tổng doanh thu nếu không chọn
  }

  @override
  Widget build(BuildContext context) {
    double totalRevenue = _calculateRevenue();

    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bộ chọn ngày/tháng
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text(selectedDate == null
                      ? "Chọn ngày"
                      : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,foregroundColor: Colors.white),
                ),
                DropdownButton<String>(
                  value: selectedMonth,
                  hint: Text("Chọn tháng"),
                  items: months.map((String month) {
                    return DropdownMenuItem<String>(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMonth = newValue;
                      selectedDate = null; // Reset ngày khi chọn tháng
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // Tổng quan doanh thu
            Text(
              "Tổng doanh thu",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
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
                          selectedDate != null
                              ? "Doanh thu ngày ${selectedDate!.day}/${selectedDate!.month}"
                              : selectedMonth != null
                                  ? "Doanh thu $selectedMonth"
                                  : "Tổng doanh thu",
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${_formatAmount(totalRevenue)} VNĐ",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Biểu đồ doanh thu
            Text(
              "Doanh thu theo ngày",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: _buildRevenueChart(),
            ),
            SizedBox(height: 20),
            // Giao dịch gần đây
            Text(
              "Giao dịch gần đây",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
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
                        _buildStatusIcon(transaction.status),
                        SizedBox(width: 12),
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
          ],
        ),
      ),
    );
  }

  // Widget giả lập biểu đồ doanh thu
  Widget _buildRevenueChart() {
    Map<String, double> filteredRevenue = selectedMonth != null
        ? dailyRevenue.entries
            .where((entry) => int.parse(entry.key.split('/')[1]) == months.indexOf(selectedMonth!) + 1)
            .fold<Map<String, double>>({}, (map, entry) => map..[entry.key] = entry.value)
        : selectedDate != null
            ? {
                "${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}":
                    dailyRevenue["${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}"] ?? 0.0
              }
            : dailyRevenue;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: filteredRevenue.entries.map((entry) {
          double maxRevenue = filteredRevenue.values.reduce((a, b) => a > b ? a : b);
          double barHeight = (entry.value / (maxRevenue == 0 ? 1 : maxRevenue)) * 150; // Tránh chia cho 0
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 30,
                height: barHeight,
                color: Colors.teal,
              ),
              SizedBox(height: 4),
              Text(
                entry.key.split('/')[0], // Chỉ hiển thị ngày
                style: TextStyle(fontSize: 12),
              ),
            ],
          );
        }).toList(),
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