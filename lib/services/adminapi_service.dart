import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AdminapiService {
  static String apiUrl = "http://192.168.1.9:3000"; // URL gốc của API

  // Phương thức để xây dựng URL đầy đủ từ apiUrl và endpoint
  static String _getFullUrl(String endpoint) {
    return '$apiUrl$endpoint';
  }
  //API lấy danh sách gói tập
  static Future<List<Map<String, dynamic>>> getPackages() async {
    final url = _getFullUrl('/admin/getPackages');
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load packages');
    }
  }

  // API thêm gói tập
  static Future<bool> addPackage(String name, String description, int durationInDays, double price) async {
    final url = _getFullUrl('/admin/addPackage');
    
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,  // Tên gói tập
        'description': description,  // Mô tả gói tập
        'durationInDays': durationInDays,  // Thời gian gói tập (ngày)
        'price': price,  // Giá của gói tập
      }),
    );

    if (response.statusCode == 201) {
      return true;  // Thành công
    } else {
      return false;  // Lỗi
    }
  }

  // API sửa gói tập
  static Future<bool> editPackage(String id, String name, String description, int durationInDays, double price) async {
    final url = _getFullUrl('/admin/modifyPackage/$id');
    
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,  // Tên gói tập
        'description': description,  // Mô tả gói tập
        'durationInDays': durationInDays,  // Thời gian gói tập (ngày)
        'price': price,  // Giá của gói tập
      }),
    );

    if (response.statusCode == 200) {
      return true;  // Thành công
    } else {
      return false;  // Lỗi
    }
  }

  // API xóa gói tập
  static Future<bool> deletePackage(String id) async {
    final url = _getFullUrl('/admin/deletePackage/$id');
    
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;  // Thành công
    } else {
      return false;  // Lỗi
    }
  }




  //API thêm PT
  Future<Map<String, dynamic>> addPT({
    required String username,
    required String email,
    required String phonenumber,
    required String birthday,
    required String password,
    String? gender,
    String? experience,
    List<String>? certifications,
    List<String>? specialties,
    File? avatar,
  }) async {
    final url = _getFullUrl('/admin/addPt');
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Thêm các trường dữ liệu
    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['phonenumber'] = phonenumber;
    request.fields['birthday'] = birthday;
    request.fields['password'] = password;
    request.fields['gender'] = gender ?? '';
    request.fields['experience'] = experience ?? '';
    request.fields['certifications'] = certifications?.join(',') ?? '';
    request.fields['specialties'] = specialties?.join(',') ?? '';

    // Thêm file ảnh nếu có
    if (avatar != null) {
      request.files.add(await http.MultipartFile.fromPath('avatar', avatar.path));
    }

    // Gửi request và xử lý phản hồi
    final response = await request.send();
    final responseData = await http.Response.fromStream(response);

    if (response.statusCode == 201) {
      return {
        'success': true,
        'message': 'PT đã được thêm thành công',
        'data': responseData.body,
      };
    } else {
      return {
        'success': false,
        'message': 'Lỗi: ${response.statusCode}',
        'data': responseData.body,
      };
    }
  }


  //API lấy thông tin PT
  static Future<List<Map<String, dynamic>>> getAllPt() async {
  final url = _getFullUrl('/admin/getAllPT');
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception('Failed to load PT list: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Server connection error: $e');
  }
}

// API xóa PT
static Future<Map<String, dynamic>> deletePt(String ptId) async {
    final url = _getFullUrl('/admin/deletePT/$ptId');
    try {
      final response = await http.delete(Uri.parse(url));
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        return {
          'success': data['success'] ?? true,
          'message': data['message'] ?? 'Xóa PT thành công',
        };
      } else {
        throw Exception(data['message'] ?? 'Failed to delete PT');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối server: $e');
    }
  }


}
