import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/adminapi_service.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<Map<String, dynamic>> userList = [];
  List<Map<String, dynamic>> filteredUserList = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Gọi API khi khởi tạo
    searchController.addListener(() {
      filterUserList();
    });
  }

  // Hàm lấy dữ liệu từ API qua AdminApiService
  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    // Lấy token từ AuthProvider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    if (token == null) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đăng nhập để tiếp tục'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final users = await AdminapiService.getAllUsers(token);
      setState(() {
        userList = users;
        filteredUserList = List.from(userList);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tải danh sách người dùng: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Hàm lọc danh sách theo tìm kiếm
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
                                backgroundImage: 
                                AssetImage('assets/info.png'),
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
                                  Text('Phone Number: ${user["phonenumber"] ?? "Chưa có"}'),
                                  Text('Ngày sinh: ${user["birthday"] != null ? DateFormat('dd/MM/yyyy').format(DateTime.parse(user["birthday"])) : "Không có"}'),
                                ],
                              ),
                              onTap: () async {
                                final result = await Navigator.pushNamed(
                                  context,
                                  '/userdetail',
                                  arguments: user,
                                );

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