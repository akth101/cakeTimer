import 'package:flutter/material.dart';
import 'cakeWidget.dart';


class pieceCake_2 extends StatefulWidget {
  const pieceCake_2({super.key});
  // const settingUI({Key? key}) : super(key: key);

  @override
  State<pieceCake_2> createState() => _pieceCake_2State();
}

class _pieceCake_2State extends State<pieceCake_2> {
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
                  cakeWidget(value: 17, hours: 1, minutes: 0),
                  cakeWidget(value: 18, hours: 1, minutes: 0),
                  cakeWidget(value: 19, hours: 1, minutes: 0),
                  cakeWidget(value: 20, hours: 1, minutes: 0),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  cakeWidget(value: 21, hours: 1, minutes: 0),
                  cakeWidget(value: 22, hours: 1, minutes: 0),
                  cakeWidget(value: 23, hours: 1, minutes: 0),
                  cakeWidget(value: 24, hours: 1, minutes: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
