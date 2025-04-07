import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import '../services/api_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;

  bool get isAuthenticated => _user != null;

 
  

 Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    if (_token != null) {
      // Gọi API để lấy thông tin user dựa trên token
      await _fetchUserData();
    }
    notifyListeners();
  }

  // Hàm phụ để lấy thông tin user từ API /me
        Future<void> _fetchUserData() async {
        try {
          final userData = await ApiService.getUserData(_token!); // Gọi API /me
          _user = User(
            id: userData['id'] ?? '', // Truy cập trực tiếp, không cần userData['user']
            email: userData['email'] ?? '',
            username: userData['username'] ?? '',
            phoneNumber: userData['phonenumber'] ?? '',
            birthday: userData['birthday'] ?? '',
            role: userData['role'] ?? '',
          );
        } catch (e) {
          _user = null;
          throw 'Không thể lấy thông tin người dùng: $e';
        }
      }

  // Đăng nhập
  Future<User?> login(String email, String password) async {
    try {
      final response = await ApiService.login(email, password);
      _token = response['token']; // Lưu token từ API

      // Lưu token vào SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);

      // Gọi API để lấy thông tin user ngay sau khi login
      await _fetchUserData();

      notifyListeners();
      return _user;
    } catch (e) {
      throw 'Thông tin đăng nhập không đúng. Vui lòng thử lại.';
    }
  }

  // Đăng xuất
  Future<void> logout() async {
    _user = null;
    _token = null;

    // Xóa token khỏi SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    notifyListeners();
  }

  // Đăng ký
 Future<void> register(String username, String email, String password, String phoneNumber, String birthday) async {
  try {
    // Gửi yêu cầu đăng ký người dùng mới đến API
    final response = await ApiService.register(username, email, password, phoneNumber, birthday);
    
    if (response['message'] == 'User registered successfully') {
      

    } else {
      throw response['message'];  // Nếu thông báo không phải "User registered successfully"
    }
  } catch (e) {
    throw 'Đăng ký không thành công. Vui lòng thử lại.';
  }
}

}
