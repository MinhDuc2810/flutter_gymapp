import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/adminapi_service.dart';
import 'package:intl/intl.dart';

class PTDetailScreen extends StatelessWidget {
  const PTDetailScreen({Key? key}) : super(key: key);

  // Hàm xử lý xóa PT
  Future<void> _deletePt(BuildContext context, String ptId) async {
    try {
      final result = await AdminapiService.deletePt(ptId);
      if (result['success']) {
        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );
        // Quay lại màn hình trước đó và báo hiệu xóa thành công
        Navigator.pop(context, true);
      }
    } catch (e) {
      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> pt =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PT: ${pt["user"]["username"]}',
          style: const TextStyle(
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'http://192.168.1.9:3000${pt["user"]["avatarUrl"]}',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    pt["user"]["username"],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${pt["user"]["email"]}',
                          style: const TextStyle(fontSize: 16)),
                      Text('Phonenumber: ${pt["user"]["phonenumber"]}',
                          style: const TextStyle(fontSize: 16)),
                      Text('Birthday: ${pt["user"]["birthday"] != null ? DateFormat( 'dd/MM/yyyy').format(DateTime.parse(pt["user"]["birthday"])) : ''}',
                          style: const TextStyle(fontSize: 16)),
                      Text('Gender: ${pt["profile"]["gender"]}',
                          style: const TextStyle(fontSize: 16)),
                      Text('Experience: ${pt["profile"]["experience"]}',
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 10),
                      const Text(
                        'Certifications:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(pt["profile"]["certifications"].join(", "),
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 10),
                      const Text(
                        'Chuyên môn:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(pt["profile"]["specialties"].join(", "),
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  _deletePt(context, pt['user']['_id']);
                },
                child: const Text('Xoá', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}