import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/auth_provider.dart';
import 'package:flutter_application_1/screens/user_screens/cardmember.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/api_service.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userData = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/info.png'),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(5),
                    child: Icon(Icons.edit, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text(
            userData?.username ?? 'Khách',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ProfileMenuItem(
            icon: Icons.person,
            text: 'Sửa Hồ Sơ',
            onTap: () {
              print('Nhấn Sửa Hồ Sơ');
              Navigator.pushNamed(context, '/editprofile');
            },
          ),
          ProfileMenuItem(
            icon: Icons.credit_card,
            text: 'Thẻ Của Tôi',
            onTap: () async {
              try {
                final userId = userData?.id ?? '';
                if (userId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Không tìm thấy ID người dùng')),
                  );
                  return;
                }
                final cardData = await ApiService.getCardMember(userId);
                if (cardData['success']) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CardDialog(
                        cardData: cardData,
                        username: userData?.username ?? 'Không rõ',
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(cardData['message'])),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi khi tải thẻ: $e')),
                );
              }
            },
          ),
          ProfileMenuItem(
            icon: Icons.lock,
            text: 'Đổi Mật Khẩu',
            onTap: () {
              print('Nhấn Đổi Mật Khẩu');
              Navigator.pushNamed(context, '/changepassword');
            },
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  ProfileMenuItem({required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(text, style: TextStyle(fontSize: 18)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}