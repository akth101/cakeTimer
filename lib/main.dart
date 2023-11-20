import 'package:flutter/material.dart';

import 'cakeTimerUI.dart';
import 'settingUI.dart';
import 'pieceCake.dart';
import 'wholeCake.dart';

void main() async {
  runApp(
    MaterialApp(
      title: 'Navigator',
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "caker",
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('해동을 부탁해'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (_) => settingUI()),
                );
                // settingUI();
              },
            ),
          ]
        ),
        body: PageView(
          children: [
            wholeCake(),
            pieceCake(),
          ]
        )
        ),
    );
  }
}

class tmpWidget extends StatelessWidget {
  final int value;
  final int hours;
  final int minutes;

  const tmpWidget({super.key, required this.value, required this.hours, required this.minutes});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    return Container(
      width: screenWidth / 4 - screenWidth * 0.01,
      height: screenHeight / 2 - screenWidth * 0.01,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.lightGreen,
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
