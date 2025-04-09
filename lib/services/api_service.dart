import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static String apiUrl = "http://192.168.1.4:3000"; // URL gốc của API

  // Phương thức để xây dựng URL đầy đủ từ apiUrl và endpoint
  static String _getFullUrl(String endpoint) {
    return '$apiUrl$endpoint';
  }

  // Hàm đăng nhập và lấy JWT token
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final endpoint = "/auth/login"; // Endpoint cho login
    final url = _getFullUrl(endpoint); // Xây dựng URL

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    print('Request body: ${json.encode({'email': email, 'password': password})}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Nếu đăng nhập thành công, trả về dữ liệu response dưới dạng map
      return json.decode(response.body);
    } else {
      throw Exception('Thông tin đăng nhập không đúng');
    }
  }

  

 static Future<Map<String, dynamic>> register(String username, String email, String password, String phoneNumber, String birthday) async {
  final endpoint = "/auth/register"; // Endpoint cho register
  final url = _getFullUrl(endpoint); // Xây dựng URL

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'username': username,
      'email': email,
      'phonenumber': phoneNumber,
      'birthday': birthday,
      'password': password,
    }),
  );

  // In ra thông tin yêu cầu và phản hồi
  print('Request body: ${json.encode({
    'username': username,
    'email': email,
    'password': password,
    'phonenumber': phoneNumber,
    'birthday': birthday,
  })}');
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    // Nếu đăng ký thành công, trả về dữ liệu response dưới dạng map
    return json.decode(response.body);
  } else {
    throw Exception('Đăng ký không thành công');
  }
}


//Hàm thay đổi thông tin người dùng
static Future<Map<String, dynamic>> updateUser(String id, String username, String email, String phoneNumber, String birthday) async {
  final endpoint = "/auth/updateuser/$id"; // Endpoint cho update user
  final url = _getFullUrl(endpoint); // Xây dựng URL

  final response = await http.put(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'username': username,
      'email': email,
      'phonenumber': phoneNumber,
      'birthday': birthday,
    }),
  );

  // In ra thông tin yêu cầu và phản hồi
  print('Request body: ${json.encode({
    'username': username,
    'email': email,
    'phonenumber': phoneNumber,
    'birthday': birthday,
  })}');
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    // Nếu đăng ký thành công, trả về dữ liệu response dưới dạng map    
    return json.decode(response.body);
  } else {
    throw Exception('Đăng ký không thành công');
  }
}

//Hàm đổi mật khẩu người dùng
static Future<String> changePassword(String id, String oldPassword, String newPassword) async {
  final endpoint = "/auth/changepassword/$id";
  final url = _getFullUrl(endpoint);

  final response = await http.put(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    }),
  );

  print('Request body: ${json.encode({
    'oldPassword': oldPassword,
    'newPassword': newPassword,
  })}');
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  final responseData = json.decode(response.body);

  if (response.statusCode == 200) {
    return responseData['message'] ?? 'Password changed successfully';
  } else {
    // Trả về thông báo lỗi từ server nếu có
    return responseData['message'] ?? 'Đổi mật khẩu thất bại';
  }
}


static Future<Map<String, dynamic>> getUserData(String token) async {
  final endpoint = "/auth/getuser";
  final url = _getFullUrl(endpoint);

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print('Request headers: ${{
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  }}');
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  final responseData = json.decode(response.body);

  if (response.statusCode == 200) {
    return responseData;
  } else {
    throw Exception(responseData['message'] ?? 'Failed to fetch user data');
  }
}

//Hàm lấy thông tin card
static Future<Map<String, dynamic>> getCardMember(String userId) async {
    final endpoint = "/user/getCardMember?userId=$userId"; // Endpoint cho getCardMember
    final url = _getFullUrl(endpoint); // Xây dựng URL

    // Kiểm tra userId hợp lệ (ObjectId trong MongoDB là 24 ký tự)
    if (userId.isEmpty || userId.length != 24) {
      return {
        'success': false,
        'message': 'Invalid userId',
      };
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Nếu thành công, trả về dữ liệu response
        return responseData; // { success: true, cardMember: {...} }
      } else if (response.statusCode == 404) {
        // Trường hợp không tìm thấy
        return {
          'success': false,
          'message': responseData['message'] ?? 'No active card member found for this user',
        };
      } else {
        // Các lỗi khác
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to load card member',
        };
      }
    } catch (err) {
      // Xử lý lỗi
      print('Error in getCardMember: $err');
      return {
        'success': false,
        'message': err.toString(),
      };
    }
  }


    
}
