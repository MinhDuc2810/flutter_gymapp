import 'package:flutter/material.dart';

class CardManagementScreen extends StatefulWidget {
  const CardManagementScreen({Key? key}) : super(key: key);

  @override
  _CardManagementScreenState createState() => _CardManagementScreenState();
}

class _CardManagementScreenState extends State<CardManagementScreen> {
  // Dữ liệu thẻ mẫu
  List<Map<String, dynamic>> cardList = [
    {
      "_id": "card001",
      "cardNumber": "1234 5678 9012 3456",
      "cardHolder": "Nguyen Van A",
      "expiryDate": "12/25",
      "cardType": "Visa",
    },
    {
      "_id": "card002",
      "cardNumber": "9876 5432 1098 7654",
      "cardHolder": "Tran Thi B",
      "expiryDate": "06/26",
      "cardType": "MasterCard",
    },
    {
      "_id": "card003",
      "cardNumber": "4567 8901 2345 6789",
      "cardHolder": "Le Van C",
      "expiryDate": "03/24",
      "cardType": "Visa",
    },
    {
      "_id": "card004",
      "cardNumber": "3210 9876 5432 1098",
      "cardHolder": "Pham Thi D",
      "expiryDate": "09/25",
      "cardType": "MasterCard",
    },
  ];

  List<Map<String, dynamic>> filteredCardList = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Khởi tạo danh sách ban đầu
    setState(() {
      filteredCardList = List.from(cardList);
    });
    searchController.addListener(() {
      filterCardList();
    });
  }

  // Hàm làm mới danh sách
  void refreshCardList() {
    setState(() {
      filteredCardList = List.from(cardList);
      searchController.clear();
    });
  }

  void filterCardList() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredCardList = cardList.where((card) {
        String cardNumber = card["cardNumber"].toLowerCase();
        String cardHolder = card["cardHolder"].toLowerCase();
        return cardNumber.contains(query) || cardHolder.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
          onPressed: () {
            Navigator.pop(context);
          },
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
                hintText: 'Tìm kiếm thẻ theo số hoặc tên chủ thẻ...',
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
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: ListTile(
                              leading: Icon(
                                card["cardType"] == "Visa"
                                    ? Icons.credit_card
                                    : Icons.payment,
                                color: Colors.blue,
                                size: 30,
                              ),
                              title: Text(
                                card["cardNumber"],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Chủ thẻ: ${card["cardHolder"]}'),
                                  Text('Hết hạn: ${card["expiryDate"]}'),
                                  Text('Loại thẻ: ${card["cardType"]}'),
                                ],
                              ),
                              onTap: () async {
                                // Điều hướng đến CardDetailScreen và chờ kết quả
                                final result = await Navigator.pushNamed(
                                  context,
                                  '/carddetail',
                                  arguments: card,
                                );

                                // Nếu xóa thành công, cập nhật danh sách và hiển thị thông báo
                                if (result == true) {
                                  setState(() {
                                    cardList.removeWhere((c) => c["_id"] == card["_id"]);
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