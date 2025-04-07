import 'package:flutter/material.dart';
import 'package:flutter_application_1/custometext.dart';
import 'package:flutter_application_1/providers/auth_provider.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

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
        title: Text(
          'Change Password',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              controller: _oldPasswordController,
              labelText: 'Old Password',
              keyboardType: TextInputType.visiblePassword,
              isPassword: true,
              height: 50,
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: _newPasswordController,
              labelText: 'New Password',
              keyboardType: TextInputType.visiblePassword,
              isPassword: true,
              height: 50,
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: _confirmPasswordController,
              labelText: 'Confirm Password',
              keyboardType: TextInputType.visiblePassword,
              isPassword: true,
              height: 50,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : changePassword,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Save Changes',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> changePassword() async {
    String oldPassword = _oldPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final id = authProvider.user?.id;

    if (id == null) {
      setState(() {
        _errorMessage = 'User ID not found.';
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        _errorMessage = 'New password and confirm password do not match.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      String resultMessage = await ApiService.changePassword(id, oldPassword, newPassword);

      setState(() {
        _isLoading = false;
      });

      if (resultMessage.toLowerCase().contains('success')) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resultMessage)));
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = resultMessage;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred. Please try again.';
      });
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
