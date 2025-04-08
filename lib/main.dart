import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/admin_screens/addpt_screen.dart';
import 'package:flutter_application_1/screens/admin_screens/pt_detail_screens.dart';
import 'package:flutter_application_1/screens/admin_screens/user_manager_screen.dart';
import 'package:flutter_application_1/screens/changepassword_screen.dart';
import 'package:flutter_application_1/screens/profile_screen.dart';
import 'package:flutter_application_1/screens/user_screens/cart_screen.dart';
import 'package:flutter_application_1/screens/user_screens/history_screen.dart';
import 'package:flutter_application_1/screens/user_screens/myworkout_screen.dart';
import 'package:flutter_application_1/screens/user_screens/schedule_request_screen.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';
import 'screens/editprofile_screen.dart';
import 'screens/admin_screens/adminhome_screen.dart';
import 'screens/pt_screens/pthome_screen.dart';
import 'screens/admin_screens/package_manager_screen.dart';
import 'screens/admin_screens/pt_manager_screen.dart';
import 'screens/admin_screens/card_manager_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
          initialRoute: '/login',
          routes: {
            '/login': (context) => LoginScreen(),
            '/home': (context) => HomeScreen(),
            '/register': (context) => RegisterScreen(),
            '/profile': (context) => ProfileScreen(),
            '/editprofile': (context) => EditProfileScreen(),
            '/changepassword': (context) => ChangePasswordScreen(),
            '/forgotpassword': (context) => ChangePasswordScreen(),
            '/adminhome': (context) => AdminhomeScreen(),
            '/pthome': (context) => PTHomeScreen(),
            '/packagemanagement': (context) => PackageManagementScreen(),
            '/ptmanagement': (context) => PTManagementScreen(),
            '/addpt': (context) => AddPTScreen(),
            '/ptdetail': (context) => const PTDetailScreen(),
            '/cart': (context) => CartScreen(),
            '/schedulerequest': (context) => PTScheduleScreen(),
            '/workouttracker': (context) => WorkoutTrackerScreen(),
            '/history': (context) => TransactionHistoryScreen(),
            '/usermanagement': (context) => UserManagementScreen(),
            '/cardmanagement': (context) => CardManagementScreen(),
          },
      ),
    );
  }
}
