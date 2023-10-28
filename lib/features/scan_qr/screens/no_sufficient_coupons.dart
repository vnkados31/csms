import 'dart:async';

import 'package:beep_player/beep_player.dart';
import 'package:flutter/material.dart';



class NoSufficientCoupons extends StatefulWidget {
  final Function() closeScreen;

  const NoSufficientCoupons({super.key,required this.closeScreen});

  @override
  State<NoSufficientCoupons> createState() => _NoSufficientCouponsState();
}

class _NoSufficientCouponsState extends State<NoSufficientCoupons> {

  static const BeepFile _beepFile = BeepFile('asset/failure_beep.wav');

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

    Timer(const Duration(seconds: 2), () {
      _onPressed();
      Navigator.of(context).pop();
      widget.closeScreen();
    });

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            widget.closeScreen();
            Navigator.pop(context);
          },icon: const Icon(Icons.arrow_back_ios),),
          centerTitle: true,
          title: const Text(
            "Error Screen",
            style: TextStyle(
                color: Colors.black87,
                fontWeight:FontWeight.bold,
                letterSpacing: 1
            ),
          ),
        ),
        body: Container(
          color: Colors.deepOrange,
        )
    );
  }

  void _onPressed() {
    BeepPlayer.play(_beepFile);
  }
}
