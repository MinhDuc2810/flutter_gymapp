import 'package:flutter/material.dart';
import '../custometext.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      setState(() {
        _nameController.text = authProvider.user?.username ?? '';
        _emailController.text = authProvider.user?.email ?? '';
        _phoneController.text = authProvider.user?.phoneNumber ?? '';
        _dateController.text = authProvider.user?.birthday ?? '';
        _selectedDate = DateTime.tryParse(authProvider.user?.birthday ?? '');
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate = DateTime.now();
    final DateTime firstDate = DateTime(1900);
    final DateTime lastDate = DateTime(2101);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = '${_selectedDate!.toLocal()}'.split(' ')[0];
      });
    }
  }

  Future<void> _updatePUser() async {
    String username = _nameController.text;
    String email = _emailController.text;
    String phoneNumber = _phoneController.text;
    String birthday = _dateController.text;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String? userId = authProvider.user?.id;
      String? token = authProvider.token;

      Map<String, dynamic> response = await ApiService.updateUser(userId!, username, email, phoneNumber, birthday);
      final responseMessage = response['message'];

      if (responseMessage == "User updated successfully") {
        // Cập nhật lại dữ liệu trong AuthProvider
        await authProvider.loadUserData();             
        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );

        // Quay về trang trước
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = responseMessage ?? 'Failed to update profile';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'An error occurred: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
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
            Navigator.pop(context);
          },
        ),
        title: Text('Edit Profile', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(controller: _nameController, labelText: 'Name', keyboardType: TextInputType.text, isPassword: false, height: 50),
            SizedBox(height: 20),
            CustomTextField(controller: _emailController, labelText: 'Email', keyboardType: TextInputType.emailAddress, isPassword: false, height: 50),
            SizedBox(height: 20),
            CustomTextField(controller: _phoneController, labelText: 'Phone', keyboardType: TextInputType.phone, isPassword: false, height: 50),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
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
            ElevatedButton(
              onPressed: _isLoading ? null : _updatePUser,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}