import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final double height; // Thêm tham số chiều cao

  CustomTextField({
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.height = 50.0,  // Mặc định chiều cao là 50
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,  // Cài đặt chiều cao cho container bao bọc
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,  // Ẩn văn bản nếu là mật khẩu
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.black),  // Màu chữ nhãn
          filled: true,  // Cho phép tô màu nền
          fillColor: Colors.grey[200],  // Màu nền
          contentPadding: EdgeInsets.symmetric(
            vertical: height / 4, // Padding theo chiều dọc
            horizontal: 16.0,     // Padding theo chiều ngang (thêm padding cho chữ)
          ),
          // Đặt kiểu cho các đường viền của TextField
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),  // Đường viền khi chưa focus
            borderRadius: BorderRadius.circular(10),  // Bo tròn góc
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2),  // Đường viền khi focus
            borderRadius: BorderRadius.circular(10),  // Bo tròn góc
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),  // Đường viền khi có lỗi
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),  // Đường viền khi có lỗi và focus
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: validator,  // Xác thực nếu cần
      ),
    );
  }
}
