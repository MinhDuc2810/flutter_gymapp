
import 'package:flutter/material.dart';
import '/services/adminapi_service.dart'; 
import '../../custometext.dart';

class Package {
  final String id;
  String name;
  String description;
  double price;
  int durationInDays;

  Package({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationInDays,
  });

  // Hàm factory để tạo đối tượng Package từ dữ liệu JSON
  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['_id'], // Giả sử backend trả về trường _id cho ID
      name: json['name'], 
      description: json['description'],
      price:
          json['price'] is int
              ? (json['price'] as int).toDouble()
              : json['price']
                  .toDouble(), // Chuyển giá trị price thành double nếu cần
      durationInDays: json['durationInDays'],
    );
  }
}

class PackageManagementScreen extends StatefulWidget {
  @override
  _PackageManagementScreenState createState() =>
      _PackageManagementScreenState();
}

class _PackageManagementScreenState extends State<PackageManagementScreen> {
  List<Package> packages = [];

  @override
  void initState() {
    super.initState();
    _fetchPackages();
  }

  // Fetch gói tập từ API
  Future<void> _fetchPackages() async {
    try {
      List<dynamic> packageData =
          await AdminapiService.getPackages(); // Gọi API lấy gói tập
      setState(() {
        packages =
            packageData
                .map((data) => Package.fromJson(data))
                .toList(); // Chuyển đổi dữ liệu JSON thành các đối tượng Package
      });
    } catch (e) {
      print('Error fetching packages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
        title: Text(
          'Package Management',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: packages.length,
        itemBuilder: (context, index) {
          final package = packages[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                package.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tô đậm tiêu đề "Description"
                  Text(
                    "Description:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(package.description),

                  // Tô đậm tiêu đề "Price"
                  Text("Price:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("\$${package.price.toStringAsFixed(2)}"),

                  // Tô đậm tiêu đề "Duration"
                  Text(
                    "Duration:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("${package.durationInDays} days"),
                ],
              ),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nút sửa
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _editPackage(context, package);
                    },
                  ),
                  // Nút xóa
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deletePackage(context, package.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // Nút thêm gói tập ở góc dưới bên phải
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addPackage(context); // Khi nhấn vào, mở BottomSheet để thêm gói tập
        },
        child: Icon(Icons.add, color: Colors.white), // Icon "+" để thêm gói tập
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Hàm mở BottomSheet để thêm gói tập
  void _addPackage(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final durationController = TextEditingController();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Thêm Gói Tập Mới",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20), 
              CustomTextField(
                controller: nameController,
                labelText: 'Tên Gói Tập',
                isPassword: false,
                height: 40,
              ),
              SizedBox(height: 20), 
              CustomTextField(
                controller: descriptionController,
                labelText: 'Mô Tả Gói Tập',
                isPassword: false,
                height: 60,
              ),
              SizedBox(height: 20), 
              CustomTextField(
                controller: priceController,
                labelText: 'Giá Gói Tập',
                isPassword: false,
                height: 40,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 20), 
              CustomTextField(
                controller: durationController,
                labelText: 'Thời Gian Gói Tập',
                isPassword: false,
                height: 40,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Đóng BottomSheet
                    },
                    child: Text('Hủy', style: TextStyle(color: Colors.red)),
                  ),
                  TextButton(
                    onPressed: () async {
                      // Lấy giá trị từ các controller
                      String name = nameController.text;
                      String description = descriptionController.text;
                      double price = double.tryParse(priceController.text) ?? 0;
                      int durationInDays = int.tryParse(durationController.text) ?? 0;

                      // Gọi API để thêm gói tập
                      bool success = await AdminapiService.addPackage(
                        name,
                        description,
                        durationInDays,
                        price,
                      );

                      if (success) {
                        // Cập nhật lại danh sách gói tập sau khi thêm thành công
                        _fetchPackages();
                        Navigator.pop(context); // Đóng BottomSheet
                      } else {
                        // Hiển thị lỗi nếu thêm không thành công
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Lỗi'),
                              content: Text('Có lỗi xảy ra trong quá trình thêm gói tập.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Đóng dialog
                                  },
                                  child: Text('Đóng'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text('Thêm', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Hàm sửa gói tập (chỉ là ví dụ)
  void _editPackage(BuildContext context, Package package) {
    // Tạo controller cho các trường nhập liệu
    TextEditingController nameController = TextEditingController(text: package.name);
    TextEditingController descriptionController = TextEditingController(text: package.description);
    TextEditingController priceController = TextEditingController(text: package.price.toString());
    TextEditingController durationController = TextEditingController(text: package.durationInDays.toString());

    // Hiển thị dialog sửa gói tập
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Sửa Gói Tập', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: nameController,
                labelText: 'Tên Gói Tập',
                isPassword: false,
                height: 40,
              ),
              SizedBox(height: 20), 
              CustomTextField(
                controller: descriptionController,
                labelText: 'Mô Tả Gói Tập',
                isPassword: false,
                height: 60,
              ),
              SizedBox(height: 20), 
              CustomTextField(
                controller: priceController,
                labelText: 'Giá Gói Tập',
                isPassword: false,
                height: 40,
              ),
              SizedBox(height: 20), 
              CustomTextField(
                controller: durationController,
                labelText: 'Thời Gian Gói Tập',
                isPassword: false,
                height: 40,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog
              },
              child: Text('Hủy', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                // Lấy dữ liệu từ các controller
                String name = nameController.text;
                String description = descriptionController.text;
                double price = double.tryParse(priceController.text) ?? 0;
                int durationInDays = int.tryParse(durationController.text) ?? 0;

                // Gọi API để sửa gói tập
                bool success = await AdminapiService.editPackage(
                  package.id,
                  name,
                  description,
                  durationInDays,
                  price,
                );

                if (success) {
                  setState(() {
                    // Cập nhật lại danh sách gói tập sau khi sửa
                    package.name = name;
                    package.description = description;
                    package.price = price;
                    package.durationInDays = durationInDays;
                  });
                  Navigator.pop(context); // Đóng dialog
                } else {
                  // Thông báo nếu sửa thất bại
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Lỗi'),
                        content: Text('Có lỗi xảy ra trong quá trình sửa gói tập.'),

                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Đóng'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Lưu', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  // Hàm xóa gói tập (chỉ là ví dụ)
  void _deletePackage(BuildContext context, String packageId) {
  // Hiển thị hộp thoại xác nhận trước khi xóa
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn chắc chắn muốn xóa gói tập này không?'),
        actions: [
          // Nút "Không" để hủy thao tác
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Đóng dialog nếu người dùng không muốn xóa
            },
            child: Text('Không', style: TextStyle(color: Colors.red)),
          ),
          // Nút "Có" để xác nhận xóa
          TextButton(
            onPressed: () async {
              // Gọi API để xóa gói tập
              bool success = await AdminapiService.deletePackage(packageId);

              if (success) {
                // Cập nhật lại danh sách gói tập sau khi xóa
                setState(() {
                  packages.removeWhere((package) => package.id == packageId);
                });
                Navigator.pop(context); // Đóng dialog
              } else {
                // Hiển thị thông báo nếu có lỗi khi xóa
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Lỗi'),
                      content: Text('Có lỗi xảy ra trong quá trình xóa gói tập.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Đóng dialog lỗi
                          },
                          child: Text('Đóng'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: Text('Có', style: TextStyle(color: Colors.blue)),
          ),
        ],
      );
    },
  );
}

}
