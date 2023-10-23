import 'package:flutter/material.dart';

class GenerateQrScreen extends StatefulWidget {
  static const String routeName = '/generateqr';
  const GenerateQrScreen({super.key});

  @override
  State<GenerateQrScreen> createState() => _GenerateQrScreenState();
}

class _GenerateQrScreenState extends State<GenerateQrScreen> {
  @override
  Widget build(BuildContext context) {
    return const Text('Generate qr screen');
  }
}
