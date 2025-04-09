import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/services/adminapi_service.dart';

class CardManagementScreen extends StatefulWidget {
  const CardManagementScreen({Key? key}) : super(key: key);

  @override
  _CardManagementScreenState createState() => _CardManagementScreenState();
}

class _CardManagementScreenState extends State<CardManagementScreen> {
  List<Map<String, dynamic>> cardList = [];
  List<Map<String, dynamic>> filteredCardList = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  final AdminapiService _cardMemberService = AdminapiService();

  @override
  void initState() {
    super.initState();
    fetchCardMembers();
    searchController.addListener(() {
      filterCardList();
    });
  }

  Future<void> fetchCardMembers() async {
    try {
      setState(() => isLoading = true);
      final cards = await _cardMemberService.getAllCardMembers();
      setState(() {
        cardList = cards;
        filteredCardList = List.from(cardList);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải dữ liệu: $e')),
      );
    }
  }

  void refreshCardList() {
    fetchCardMembers();
    searchController.clear();
  }

  void filterCardList() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredCardList = cardList.where((card) {
        String username = card['user']['username'].toLowerCase();
        String phonenumber = card['user']['phonenumber'].toLowerCase();
        return username.contains(query) || phonenumber.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Hàm để lấy màu dựa trên trạng thái
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.grey;
      case 'expired':
        return Colors.red;
      default:
        return Colors.black; // Màu mặc định nếu trạng thái không khớp
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Card Management',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: refreshCardList,
            tooltip: 'Làm mới danh sách',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm theo tên hoặc số điện thoại...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredCardList.isEmpty
                    ? const Center(
                        child: Text(
                          'Không tìm thấy thẻ nào',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredCardList.length,
                        itemBuilder: (context, index) {
                          final card = filteredCardList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: ListTile(
                              leading: const Icon(
                                Icons.credit_card,
                                color: Colors.blue,
                                size: 30,
                              ),
                              title: Text(
                                card['user']['username'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'ID: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(text: card['cardMember']['id']),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Phonenumber: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                            text: card['user']['phonenumber']),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Status: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: card['cardMember']['status'],
                                          style: TextStyle(
                                            color: _getStatusColor(
                                                card['cardMember']['status']),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Start date: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(
                                                card['cardMember']['startDate']),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'End date: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(
                                                card['cardMember']['endDate']),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                final result = await Navigator.pushNamed(
                                  context,
                                  '/carddetail',
                                  arguments: card,
                                );
                                if (result == true) {
                                  setState(() {
                                    cardList.removeWhere((c) =>
                                        c['cardMember']['id'] ==
                                        card['cardMember']['id']);
                                    filteredCardList = List.from(cardList);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Xóa thẻ thành công'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}