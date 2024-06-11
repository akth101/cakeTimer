import 'package:flutter/material.dart';
import 'cakeWidget.dart';

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
