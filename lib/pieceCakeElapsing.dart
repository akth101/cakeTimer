import 'package:flutter/material.dart';
import 'main.dart';
import 'cakeWidget.dart';

class pieceCakeElapsing extends StatefulWidget {
  const pieceCakeElapsing({super.key});
  // const settingUI({Key? key}) : super(key: key);

  @override
  State<pieceCakeElapsing> createState() => _pieceCakeElapsingState();
}

class _pieceCakeElapsingState extends State<pieceCakeElapsing> {
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
