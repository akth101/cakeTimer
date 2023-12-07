import 'package:flutter/material.dart';
import 'main.dart';

class wholeCake extends StatefulWidget {
  const wholeCake({super.key});

  @override
  State<wholeCake> createState() => _wholeCakeState();
}

class _wholeCakeState extends State<wholeCake> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  tmpWidget(value: 1, hours: 6, minutes: 0),
                  tmpWidget(value: 2, hours: 6, minutes: 0),
                  tmpWidget(value: 3, hours: 6, minutes: 0),
                  tmpWidget(value: 4, hours: 6, minutes: 0),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  tmpWidget(value: 5, hours: 6, minutes: 0),
                  tmpWidget(value: 6, hours: 6, minutes: 0),
                  tmpWidget(value: 7, hours: 6, minutes: 0),
                  tmpWidget(value: 8, hours: 6, minutes: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
