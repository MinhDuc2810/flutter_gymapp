import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../custometext.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Login',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )
            ),
      ),
      body: 
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/icon1.jpg',
              width: 100,
              height: 100,
            ),
            Text(
              'Fitness Gym',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )
            ),
            SizedBox(height: 40),
            CustomTextField(
              controller: _emailController,
              labelText: 'Email',
              height: 40,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email không được để trống';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: _passwordController, 
              height: 40,
              labelText: 'Password',
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mật khâu không được để trống';
                }
                return null;
              } 
            ),

           Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/forgotpassword');
                },
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),



            SizedBox(height: 20),

          
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            if (_isLoading)
              CircularProgressIndicator()
            else
              ElevatedButton(
              onPressed: _login,
              child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 40), 
                 // Chiều rộng full, chiều cao là 50
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Sign up', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 40), 
                 // Chiều rộng full, chiều cao là 50
              ),
            ),
            

          ],
        ),
      ),
    );
  }

  void _login() async {
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    setState(() {
      _errorMessage = 'Please enter both email and password.';
    });
    return;
  }

  setState(() {
    _isLoading = true;
    _errorMessage = '';
  });

  try {
    // Gọi login từ Provider
    final user = await Provider.of<AuthProvider>(context, listen: false)
        .login(email, password); // login trả về user object chứa role

    if (user != null) {
      final role = user.role;

      // Điều hướng theo vai trò
      switch (role) {
        case 'admin':
          Navigator.pushReplacementNamed(context, '/adminhome');
          break;
        case 'pt':
          Navigator.pushReplacementNamed(context, '/pthome');
          break;
        case 'user':
          Navigator.pushReplacementNamed(context, '/home');
          break;
        default:
          setState(() {
            _errorMessage = 'Unknown role: $role';
          });
      }
    } else {
      setState(() {
        _errorMessage = 'Login failed. Please check your credentials.';
      });
    }
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
