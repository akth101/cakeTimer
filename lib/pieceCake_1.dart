import 'package:flutter/material.dart';
import 'main.dart';

class pieceCake_1 extends StatefulWidget {
  const pieceCake_1({super.key});
  // const settingUI({Key? key}) : super(key: key);

  @override
  State<pieceCake_1> createState() => _pieceCake_1State();
}

class _pieceCake_1State extends State<pieceCake_1> {
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
                  tmpWidget(value: 9, hours: 1, minutes: 0),
                  tmpWidget(value: 10, hours: 1, minutes: 0),
                  tmpWidget(value: 11, hours: 1, minutes: 0),
                  tmpWidget(value: 12, hours: 1, minutes: 0),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  tmpWidget(value: 13, hours: 1, minutes: 0),
                  tmpWidget(value: 14, hours: 1, minutes: 0),
                  tmpWidget(value: 15, hours: 1, minutes: 0),
                  tmpWidget(value: 16, hours: 1, minutes: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
