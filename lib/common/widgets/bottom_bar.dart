import 'package:csm_system/features/generate_qr/screens/generate_qr_screen.dart';
import 'package:csm_system/features/hr_report/screens/hr_report_download.dart';
import 'package:csm_system/features/menu/screens/menu_screen.dart';
import 'package:csm_system/features/notification/screens/notification_screen.dart';
import 'package:csm_system/features/reports/screens/reports_common_screen.dart';
import 'package:csm_system/features/scan_qr/screens/qr_scanner.dart';
import 'package:csm_system/features/settings/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

import '../../constants/global_variables.dart';
import '../../features/auth/services/auth_service.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../providers/user_provider.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 1;
  double bottomBarWidth = 70;
  double bottomBarBorderWidth = 5;

  // final AuthService authService = AuthService();

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
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
        break;
      case 'QrScanner':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QrScanner()),
        );
        break;
      case 'HR Report':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HrReportDownload()),
        );

      case 'Reports':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReportsCommonScreen()),
        );
        break;
      case 'LogOut':
        AuthService().logoutUser(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
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
                  if (user.userType == 'admin' ||
                      user.userType == 'officeBoy' ||
                      user.userType == 'super_admin')
                    'QrScanner',
                  if (user.userType == 'super_admin' || user.userType == 'hr')
                    'HR Report',
                  if (user.userType == 'super_admin' ||
                      user.userType == 'hr' ||
                      user.userType == 'admin')
                    'Reports',
                  'LogOut'
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
              child: const Icon(Icons.restaurant_menu),
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
              child: const Icon(Icons.qr_code),
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
                child: const Icon(Icons.notifications),
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
