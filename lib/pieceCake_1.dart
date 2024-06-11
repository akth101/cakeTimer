import 'package:flutter/material.dart';
import 'main.dart';
import 'cakeWidget.dart';

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
                  cakeWidget(value: 9),
                  cakeWidget(value: 10),
                  cakeWidget(value: 11),
                  cakeWidget(value: 12),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  cakeWidget(value: 13),
                  cakeWidget(value: 14),
                  cakeWidget(value: 15),
                  cakeWidget(value: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
