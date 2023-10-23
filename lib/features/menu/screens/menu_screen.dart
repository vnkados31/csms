import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  static const String routeName = '/menu';
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('Menu Screen'),
    );
  }
}