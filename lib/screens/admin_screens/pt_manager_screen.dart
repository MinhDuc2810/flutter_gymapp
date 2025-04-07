import 'package:flutter/material.dart';
import '../../services/adminapi_service.dart';

class PTManagementScreen extends StatefulWidget {
  const PTManagementScreen({Key? key}) : super(key: key);

  @override
  _PTManagementScreenState createState() => _PTManagementScreenState();
}

class _PTManagementScreenState extends State<PTManagementScreen> {
  List<Map<String, dynamic>> ptList = [];
  List<Map<String, dynamic>> filteredPtList = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPTList(); // Gọi API khi khởi tạo
    searchController.addListener(() {
      filterPTList();
    });
  }

  // Hàm gọi API từ AdminApiService
  Future<void> fetchPTList() async {
    try {
      setState(() {
        isLoading = true;
      });
      final data = await AdminapiService.getAllPt();
      setState(() {
        ptList = data;
        filteredPtList = List.from(ptList);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void filterPTList() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredPtList = ptList.where((pt) {
        String ptName = pt["user"]["username"].toLowerCase();
        return ptName.contains(query);
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
          'PT Management',
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
            onPressed: fetchPTList,
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
                hintText: 'Tìm kiếm PT theo tên...',
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
                : filteredPtList.isEmpty
                    ? const Center(
                        child: Text(
                          'Không tìm thấy PT nào',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredPtList.length,
                        itemBuilder: (context, index) {
                          final pt = filteredPtList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  'http://192.168.1.9:3000${pt["user"]["avatarUrl"]}',
                                ),
                              ),
                              title: Text(
                                pt["user"]["username"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ID: ${pt["user"]["_id"]}'),
                                  Text('Gender: ${pt["profile"]["gender"]}'),
                                ],
                              ),
                              onTap: () async {
                                // Điều hướng đến PTDetailScreen và chờ kết quả
                                final result = await Navigator.pushNamed(
                                  context,
                                  '/ptdetail',
                                  arguments: pt,
                                );

                                // Nếu xóa thành công, gọi lại API và hiển thị thông báo
                                if (result == true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Xóa PT thành công'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  await fetchPTList();
                                }
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          // Điều hướng đến AddPTScreen và chờ kết quả
          final result = await Navigator.pushNamed(context, '/addpt');

          // Nếu thêm thành công, gọi lại API và hiển thị thông báo
          if (result == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Thêm PT thành công'),
                backgroundColor: Colors.green,
              ),
            );
            await fetchPTList();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Thêm PT mới',
      ),
    );
  }
}