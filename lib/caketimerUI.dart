// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:timer/timer.dart';

class CakeTimerUI extends StatefulWidget {

  final int value2;

  //const CakeTimerUI({super.key, required this.value2});

  const CakeTimerUI({Key? key, required this.value2}) : super(key: key);

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
            TimerFunction(value3: widget.value2),
          ],
        ),
      ),
    );
  }
}
