import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import 'package:owpet/src/screens/Pets/my_pets_screen.dart';
import 'package:owpet/src/screens/Profile/profile_user_screen.dart';
import 'package:owpet/src/screens/Home/dashboard_screen.dart';
import 'package:owpet/src/services/auth_service.dart';
import 'package:owpet/src/models/user.dart';
import 'package:provider/provider.dart';

class MyHomeScreen extends StatefulWidget {
  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen>
    with TickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;
  User _currentUser = User(
    id: '',
    email: '',
    name: '',
    password: '',
    telephone: '',
    description: '',
    photo: '',
  );

  // List<Widget> _widgetOptions = <Widget>[
  //   DashboardScreen(),
  //   MyPetsScreen(userId: 'jzcaUv48fPgW73VfTkaO6mkzFTd2'),
  //   ProfileUserScreen(user: _currentUser,),
  // ];

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    _fetchCurrentUser();
    print("Current User: $_currentUser");
  }

  @override
  void dispose() {
    _motionTabBarController!.dispose();
    super.dispose();
  }

  void _fetchCurrentUser() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final User user = await authService.getActiveUser();
    setState(() {
      _currentUser.id = user.id;
      _currentUser.email = user.email;
      _currentUser.name = user.name;
      _currentUser.password = user.password;
      _currentUser.telephone = user.telephone;
      _currentUser.description = user.description;
      _currentUser.photo = user.photo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _motionTabBarController,
        children: [
          DashboardScreen(),
          MyPetsScreen(userId: _currentUser.id),
          ProfileUserScreen(
            user: _currentUser,
          ),
        ],
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
