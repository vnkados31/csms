import 'package:csm_system/features/generate_qr/screens/generate_qr_screen.dart';
import 'package:csm_system/features/menu/screens/menu_screen.dart';
import 'package:csm_system/features/notification/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

import '../../constants/global_variables.dart';
import '../../features/profile/screens/profile_screen.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 1;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const MenuScreen(),
    const GenerateQrScreen(),
    const NotificationScreen()
  ];

  List<String> pageNames = ["Menu", "Generate Qr", "Notifications"];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  void handleClick(String value) {
    switch (value) {
      case 'Profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
      case 'Settings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
      case 'QrScanner':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
      case 'LogOut':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(pageNames[_page]),
        ),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {
                  'Profile',
                  'Settings',
                  // 'Analytics',
                  'QrScanner',
                  'Log Out'
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              })
        ],
      ),
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        onTap: updatePage,
        items: [
          // Home Page
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: _page == 0
                            ? GlobalVariables.selectedNavBarColor
                            : GlobalVariables.backgroundColor,
                        width: bottomBarBorderWidth)),
              ),
              child: const Icon(Icons.home_outlined),
            ),
            label: '',
          ),
          //Account
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: _page == 1
                            ? GlobalVariables.selectedNavBarColor
                            : GlobalVariables.backgroundColor,
                        width: bottomBarBorderWidth)),
              ),
              child: const Icon(Icons.person_outline_outlined),
            ),
            label: '',
          ),
          // Cart
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: _page == 2
                            ? GlobalVariables.selectedNavBarColor
                            : GlobalVariables.backgroundColor,
                        width: bottomBarBorderWidth)),
              ),
              child: badges.Badge(
                child: const Icon(Icons.home_outlined),
                elevation: 0,
                badgeContent: const Text('2'),
                badgeColor: Colors.white,
              ),
            ),
            label: '',
          ),
        ],
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
      ),
    );
  }
}
