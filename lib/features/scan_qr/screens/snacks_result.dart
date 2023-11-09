import 'dart:async';

import 'package:beep_player/beep_player.dart';
import 'package:flutter/material.dart';

class SnacksResult extends StatefulWidget {
  final String code;
  final Function() closeScreen;

  const SnacksResult(
      {super.key, required this.closeScreen, required this.code});

  @override
  State<SnacksResult> createState() => _SnacksResultState();
}

class _SnacksResultState extends State<SnacksResult> {
  static const BeepFile _beepFile = BeepFile('asset/success_beep.wav');

  @override
  void initState() {
    super.initState();
    BeepPlayer.load(_beepFile);
  }

  @override
  void dispose() {
    BeepPlayer.unload(_beepFile);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      _onPressed();
      Navigator.of(context).pop();
      widget.closeScreen();
    });

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              widget.closeScreen();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          centerTitle: true,
          title: const Text(
            "QR Scanner",
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                letterSpacing: 1),
          ),
        ),
        body: Container(
          color: Colors.green,
        ));
  }

  void _onPressed() {
    BeepPlayer.play(_beepFile);
  }
}
