import 'package:flutter/material.dart';
import 'cakeWidget.dart';

class wholeCakeElapsed extends StatefulWidget {
  const wholeCakeElapsed({super.key});

  @override
  State<wholeCakeElapsed> createState() => _wholeCakeElapsingState();
}

class _wholeCakeElapsingState extends State<wholeCakeElapsed> {
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
                  cakeWidget(value: 1),
                  cakeWidget(value: 2),
                  cakeWidget(value: 3),
                  cakeWidget(value: 4),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  cakeWidget(value: 5),
                  cakeWidget(value: 6),
                  cakeWidget(value: 7),
                  cakeWidget(value: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
