import 'package:flutter/material.dart';
import 'package:timer/timer.dart';

class CakeTimerUI extends StatefulWidget {
  const CakeTimerUI({super.key});

  @override
  CakeTimerState createState() => CakeTimerState();
}

class CakeTimerState extends State<CakeTimerUI> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimerFunction(),
          ],
        ),
      ),
    );
  }
}
