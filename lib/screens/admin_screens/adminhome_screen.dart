import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import './dashboard_screen.dart';

class AdminhomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

   

    final userData = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Admin Home',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                // Sử dụng Builder context để truy cập Scaffold
                Scaffold.of(context).openDrawer();  // Mở Drawer khi nhấn vào biểu tượng
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            
            ListTile(
              title: Text('Package Management'),
              onTap: () {
                Navigator.pushNamed(context, '/packagemanagement');
              },
            ),
            ListTile(
              title: Text('PT Management'),
              onTap: () {
                Navigator.pushNamed(context, '/ptmanagement');
              },
            ),
            ListTile(
              title: Text('User Management'),
              onTap: () {
                Navigator.pushNamed(context, '/usermanagement');
              },
            ),
            ListTile(
              title: Text('Card Management'),
              onTap: () {
                Navigator.pushNamed(context, '/cardmanagement');
              },
            ),
            
          ],
        ),
      ),
      body: RevenueDashboardScreen(),
    );
  }
}
