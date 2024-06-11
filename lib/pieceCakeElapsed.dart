import 'package:flutter/material.dart';
import 'cakeWidget.dart';

class pieceCakeElapsed extends StatefulWidget {
  const pieceCakeElapsed({super.key});
  // const settingUI({Key? key}) : super(key: key);

  @override
  State<pieceCakeElapsed> createState() => _pieceCakeElapsedState();
}

class _pieceCakeElapsedState extends State<pieceCakeElapsed> {
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
                  cakeWidget(value: 17),
                  cakeWidget(value: 18),
                  cakeWidget(value: 19),
                  cakeWidget(value: 20),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  cakeWidget(value: 21),
                  cakeWidget(value: 22),
                  cakeWidget(value: 23),
                  cakeWidget(value: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
