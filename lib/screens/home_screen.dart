import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/user_screens/shop_tab_content.dart';
import '../screens/user_screens/package_tab_content.dart';
import '../screens/user_screens/pt_tab_content.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  OverlayEntry? _overlayEntry;
  bool _isNotificationOpen = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _toggleNotificationDropdown(BuildContext context) {
    if (_isNotificationOpen) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isNotificationOpen = false;
    } else {
      _overlayEntry = _createOverlayEntry(context);
      Overlay.of(context).insert(_overlayEntry!);
      _isNotificationOpen = true;
    }
    setState(() {});
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          _toggleNotificationDropdown(context); // Đóng khi nhấn ra ngoài
        },
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              top: offset.dy + 56.0, // Đặt ngay dưới AppBar (56 là chiều cao mặc định của AppBar)
              right: 10.0, // Căn lề phải để khớp với nút thông báo
              width: 250, // Chiều rộng của dropdown
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Divider(),
                      // Ví dụ danh sách thông báo
                      ListTile(
                        title: Text('New message received'),
                        subtitle: Text('5 minutes ago'),
                        leading: Icon(Icons.message, color: Colors.blue),
                      ),
                      ListTile(
                        title: Text('Workout reminder'),
                        subtitle: Text('10 minutes ago'),
                        leading: Icon(Icons.fitness_center, color: Colors.blue),
                      ),
                      ListTile(
                        title: Text('Payment successful'),
                        subtitle: Text('1 hour ago'),
                        leading: Icon(Icons.payment, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userData = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Fitness Gym',
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
                Scaffold.of(context).openDrawer();
              },
              splashColor: Colors.white30,
              highlightColor: Colors.white10,
            );
          },
        ),
        actions: [
          // Nút thông báo với dropdown
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications, color: Colors.white),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '3', // Số lượng thông báo (có thể thay bằng biến động)
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              _toggleNotificationDropdown(context); // Hiển thị/ẩn dropdown
            },
            splashColor: Colors.white30,
            highlightColor: Colors.white10,
            tooltip: 'Notifications',
          ),
          // Nút giỏ hàng
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
            splashColor: Colors.white30,
            highlightColor: Colors.white10,
            tooltip: 'Cart',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3.0,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.white,
                width: 3.0,
              ),
            ),
          ),
          tabs: [
            _buildTabIcon(Icons.store, 0),
            _buildTabIcon(Icons.card_giftcard, 1),
            _buildTabIcon(Icons.fitness_center, 2),
          ],
        ),
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
            _buildDrawerItem(
              context: context,
              icon: Icons.person,
              title: 'Profile',
              route: '/profile',
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.history,
              title: 'History',
              route: '/history',
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.schedule,
              title: 'Schedule Request',
              route: '/schedulerequest',
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.work,
              title: 'Workout Tracker',
              route: '/workouttracker',
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                authProvider.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              splashColor: Colors.blue.withOpacity(0.2),
              hoverColor: Colors.blue.withOpacity(0.1),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: BouncingScrollPhysics(),
        children: [
          ShopTabContent(),
          PackageTabContent(),
          PTTabContent(),
        ],
      ),
    );
  }

  Widget _buildTabIcon(IconData icon, int index) {
    final isSelected = _tabController.index == index;
    return Tab(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: AnimatedScale(
          scale: isSelected ? 1.3 : 1.0,
          duration: Duration(milliseconds: 300),
          child: AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            top: isSelected ? -2.0 : 0.0,
            child: Icon(
              icon,
              size: isSelected ? 28.0 : 24.0,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
      splashColor: Colors.blue.withOpacity(0.2),
      hoverColor: Colors.blue.withOpacity(0.1),
    );
  }
}