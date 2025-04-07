import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../custometext.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController(); // Controller cho DatePicker

  bool _isLoading = false;
  String _errorMessage = '';
  DateTime? _selectedDate;

  // Hàm mở DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate = DateTime.now();  // Ngày khởi tạo mặc định là ngày hiện tại
    final DateTime firstDate = DateTime(1900);    // Ngày bắt đầu chọn
    final DateTime lastDate = DateTime(2101);    // Ngày kết thúc chọn

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = '${_selectedDate!.toLocal()}'.split(' ')[0];  // Định dạng ngày
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,  // Màu nền của AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),  // Đặt màu của nút back là trắng
          onPressed: () {
            Navigator.pop(context);  // Quay lại màn hình trước
          },
        ),
        title: Text('Register', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(controller: _nameController, labelText: 'Name', keyboardType: TextInputType.text, isPassword: false, height: 50,),
            SizedBox(height: 20),
            CustomTextField(controller: _emailController, labelText: 'Email', keyboardType: TextInputType.emailAddress, isPassword: false, height: 50,),
            SizedBox(height: 20),
            CustomTextField(controller: _phoneController, labelText: 'Phone', keyboardType: TextInputType.phone, isPassword: false, height: 50,),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _selectDate(context),  // Mở DatePicker khi nhấn vào trường này
              child: AbsorbPointer(  // Ngăn không cho người dùng sửa ngày trực tiếp
                child: CustomTextField(
                  controller: _dateController,
                  labelText: 'Birthday',
                  keyboardType: TextInputType.datetime,
                  isPassword: false,
                  height: 50,
                ),
              ),
            ),
            SizedBox(height: 20),
            CustomTextField(controller: _passwordController, labelText: 'Password', keyboardType: TextInputType.visiblePassword, isPassword: true, height: 50,),
            SizedBox(height: 20),

            // Nút đăng ký
            ElevatedButton(
              onPressed: _register,
              child: _isLoading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text('Register', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50), // Chiều rộng full, chiều cao 50
              ),
            ),

            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  // Hàm xử lý đăng ký
  void _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final date = _selectedDate != null ? _selectedDate!.toLocal().toString().split(' ')[0] : null;

    if (email.isEmpty || password.isEmpty || name.isEmpty || phone.isEmpty || date == null) {
      setState(() {
        _errorMessage = 'Please fill in all fields.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Gọi hàm đăng ký từ AuthProvider
      await Provider.of<AuthProvider>(context, listen: false).register(name, email, password, phone, date);

      // Chuyển sang màn hình login sau khi đăng ký thành công
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);  // Chuyển đến màn hình login
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
