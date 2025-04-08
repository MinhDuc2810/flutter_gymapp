import 'package:flutter/material.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  // Dữ liệu người dùng mẫu
  List<Map<String, dynamic>> userList = [
    {
      "_id": "user001",
      "username": "nguyen_van_a",
      "email": "nguyenvana@gmail.com",
      "avatarUrl": "/avatars/user001.jpg",
    },
    {
      "_id": "user002",
      "username": "tran_thi_b",
      "email": "tranthib@gmail.com",
      "avatarUrl": "/avatars/user002.jpg",
    },
    {
      "_id": "user003",
      "username": "le_van_c",
      "email": "levanc@gmail.com",
      "avatarUrl": null, // Không có avatar
    },
    {
      "_id": "user004",
      "username": "pham_thi_d",
      "email": null, // Không có email
      "avatarUrl": "/avatars/user004.jpg",
    },
  ];

  List<Map<String, dynamic>> filteredUserList = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Khởi tạo danh sách ban đầu
    setState(() {
      filteredUserList = List.from(userList);
    });
    searchController.addListener(() {
      filterUserList();
    });
  }

  // Hàm làm mới danh sách
  void refreshUserList() {
    setState(() {
      filteredUserList = List.from(userList);
      searchController.clear();
    });
  }

  void filterUserList() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredUserList = userList.where((user) {
        String userName = user["username"].toLowerCase();
        return userName.contains(query);
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
          'User Management',
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
            onPressed: refreshUserList,
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
                hintText: 'Tìm kiếm người dùng theo tên...',
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
                : filteredUserList.isEmpty
                    ? const Center(
                        child: Text(
                          'Không tìm thấy người dùng nào',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredUserList.length,
                        itemBuilder: (context, index) {
                          final user = filteredUserList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: user["avatarUrl"] != null
                                    ? NetworkImage('http://192.168.1.9:3000${user["avatarUrl"]}')
                                    : const NetworkImage('http://192.168.1.9:3000/avatars/default-avatar.png'),
                              ),
                              title: Text(
                                user["username"],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ID: ${user["_id"]}'),
                                  Text('Email: ${user["email"] ?? "Chưa có"}'),
                                ],
                              ),
                              onTap: () async {
                                // Điều hướng đến UserDetailScreen và chờ kết quả
                                final result = await Navigator.pushNamed(
                                  context,
                                  '/userdetail',
                                  arguments: user,
                                );

                                // Nếu xóa thành công, cập nhật danh sách và hiển thị thông báo
                                if (result == true) {
                                  setState(() {
                                    userList.removeWhere((u) => u["_id"] == user["_id"]);
                                    filteredUserList = List.from(userList);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Xóa người dùng thành công'),
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