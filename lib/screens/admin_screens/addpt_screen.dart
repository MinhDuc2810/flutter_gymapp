import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/adminapi_service.dart';
import '../../custometext.dart';

class AddPTScreen extends StatefulWidget {
  const AddPTScreen({Key? key}) : super(key: key);

  @override
  _AddPTScreenState createState() => _AddPTScreenState();
}

class _AddPTScreenState extends State<AddPTScreen> {
  File? _image;
  final picker = ImagePicker();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedGender;
  final _experienceController = TextEditingController();
  final _certificationsController = TextEditingController();
  final _specialtiesController = TextEditingController();
  final AdminapiService _ptService = AdminapiService();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _addPT() async {
    print('Nút "Thêm PT" đã được nhấn');
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _birthdayController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin bắt buộc'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ảnh'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final result = await _ptService.addPT(
      username: _usernameController.text,
      email: _emailController.text,
      phonenumber: _phoneController.text,
      birthday: _birthdayController.text,
      password: _passwordController.text,
      gender: _selectedGender!,
      experience: _experienceController.text,
      certifications: _certificationsController.text.split(','),
      specialties: _specialtiesController.text.split(','),
      avatar: _image,
    );

    // Hiển thị thông báo với màu sắc phù hợp
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );

    if (result['success']) {
      // Xóa dữ liệu trong form
      setState(() {
        _image = null;
        _usernameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _birthdayController.clear();
        _passwordController.clear();
        _selectedGender = null;
        _experienceController.clear();
        _certificationsController.clear();
        _specialtiesController.clear();
      });

      // Đợi một chút để người dùng thấy thông báo trước khi quay lại
      await Future.delayed(const Duration(seconds: 2));
      // Quay lại màn hình trước đó và báo hiệu thêm thành công
      Navigator.pop(context, true);
    }
  }

  void _showGenderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Gender'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Male'),
                onTap: () {
                  setState(() {
                    _selectedGender = 'male';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Female'),
                onTap: () {
                  setState(() {
                    _selectedGender = 'female';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add PT',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _image == null
                ? const Text('Chưa chọn ảnh')
                : Image.file(_image!, height: 200),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text(
                'Chọn ảnh',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _usernameController,
              labelText: 'Username',
              keyboardType: TextInputType.text,
              isPassword: false,
              height: 50,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _emailController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
              isPassword: false,
              height: 50,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _phoneController,
              labelText: 'Phone',
              keyboardType: TextInputType.phone,
              isPassword: false,
              height: 50,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: CustomTextField(
                  controller: _birthdayController,
                  labelText: 'Birthday',
                  keyboardType: TextInputType.datetime,
                  isPassword: false,
                  height: 50,
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _passwordController,
              labelText: 'Password',
              keyboardType: TextInputType.text,
              isPassword: true,
              height: 50,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _showGenderDialog,
              child: AbsorbPointer(
                child: CustomTextField(
                  controller:
                      TextEditingController(text: _selectedGender ?? ''),
                  labelText: 'Gender',
                  keyboardType: TextInputType.text,
                  isPassword: false,
                  height: 50,
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _experienceController,
              labelText: 'Experience',
              keyboardType: TextInputType.text,
              isPassword: false,
              height: 50,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _certificationsController,
              labelText: 'Certifications',
              keyboardType: TextInputType.text,
              isPassword: false,
              height: 50,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _specialtiesController,
              labelText: 'Specialties',
              keyboardType: TextInputType.text,
              isPassword: false,
              height: 50,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: _addPT,
              child: const Text(
                'Thêm PT',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthdayController.dispose();
    _passwordController.dispose();
    _experienceController.dispose();
    _certificationsController.dispose();
    _specialtiesController.dispose();
    super.dispose();
  }
}