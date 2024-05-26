import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import 'package:owpet/src/screens/Pets/my_pets_screen.dart';
import 'package:owpet/src/screens/Profile/profile_user_screen.dart';
import 'package:owpet/src/screens/Home/dashboard_screen.dart';

class MyHomeScreen extends StatefulWidget {
  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> with TickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;

  static List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    MyPetsScreen(userId: 'qUtR4Sp5FAHyOpmxeD9l'),
    ProfileUserScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _motionTabBarController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _motionTabBarController,
        children: _widgetOptions,
      ),
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: "Home",
        labels: const ["Home", "Pets", "Profile"],
        icons: const [Icons.home, Icons.pets, Icons.person],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Colors.white,
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: Color.fromRGBO(252, 147, 64, 1),
        tabIconSelectedColor: Colors.white,
        tabBarColor: Color.fromRGBO(139, 128, 255, 1),
        onTabItemSelected: (int value) {
          setState(() {
            _motionTabBarController!.index = value;
          });
        },
      ),
    );
  }
}
