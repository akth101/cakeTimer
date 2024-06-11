import 'package:flutter/material.dart';
import 'cakeTimerUI.dart';

class cakeWidget extends StatelessWidget {
  final int value;
  final int hours;
  final int minutes;

  const cakeWidget(
      {super.key,
      required this.value,
      required this.hours,
      required this.minutes});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    return Container(
      width: screenWidth / 4 - screenWidth * 0.02,
      height: screenHeight / 2 - screenWidth * 0.03,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade300,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CakeTimerUI(value: value, hours: hours, minutes: minutes),
        ],
      ),
    );
  }
}