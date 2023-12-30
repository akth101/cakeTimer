// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:timer/timer.dart';
import 'cakeName.dart';

class CakeTimerUI extends StatefulWidget {
  final int value;
  final int hours;
  final int minutes;

  const CakeTimerUI(
      {Key? key,
      required this.value,
      required this.hours,
      required this.minutes})
      : super(key: key);

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
                hours: widget.hours,
                minutes: widget.minutes),
          ],
        ),
      ),
    );
  }
}
