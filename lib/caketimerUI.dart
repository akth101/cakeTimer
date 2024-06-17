// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:timer/timer.dart';
import 'cakeName.dart';

class CakeTimerUI extends StatefulWidget {
  final int value;

  
  const CakeTimerUI({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  CakeTimerState createState() => CakeTimerState();
}

class CakeTimerState extends State<CakeTimerUI> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cakeNameSetting(value: widget.value),
            TimerFunction(
              value: widget.value,
            ),
          ],
        ),
      ),
    );
  }
}
