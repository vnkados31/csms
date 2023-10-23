import 'package:csm_system/features/generate_qr/screens/generate_qr_screen.dart';
import 'package:csm_system/features/notification/screens/notification_screen.dart';
import 'package:csm_system/features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';

import 'common/widgets/bottom_bar.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/menu/screens/menu_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );

    case MenuScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const MenuScreen(),
      );

    case GenerateQrScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const GenerateQrScreen(),
      );

    case NotificationScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const NotificationScreen(),
      );

    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );

    case ProfileScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ProfileScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist'),
          ),
        ),
      );
  }
}