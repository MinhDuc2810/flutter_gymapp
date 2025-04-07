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
    super.dispose();
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
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {},
            splashColor: Colors.white30,
            highlightColor: Colors.white10,
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