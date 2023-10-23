import 'package:csm_system/features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';

void handleClick(BuildContext context, String value) {
  switch (value) {
    case 'Profile':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
      break;
  }
}
