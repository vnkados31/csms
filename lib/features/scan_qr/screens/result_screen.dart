import 'dart:async';

import 'package:beep_player/beep_player.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final String code;
  final Function() closeScreen;

  const ResultScreen(
      {super.key, required this.closeScreen, required this.code});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
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
    List<String> parts = widget.code.split(" ");

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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Total: ${parts[5]}",
                style:
                    const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10), // Add some space between text fields
              Text("Veg: ${parts[2]}",
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("NonVeg: ${parts[3]}",
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("Diet: ${parts[4]}",
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold)),
            ],
          ),
        ));
  }

  void _onPressed() {
    BeepPlayer.play(_beepFile);
  }
}
