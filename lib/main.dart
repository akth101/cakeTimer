import 'package:flutter/material.dart';
import 'package:timer/pieceCake_2.dart';

import 'cakeTimerUI.dart';
import 'settingUI.dart';
import 'pieceCake_1.dart';
import 'wholeCake.dart';

void main() async {
  runApp(
    const MaterialApp(
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
        primaryColor: const Color.fromARGB(255, 0, 0, 0),
        canvasColor: Colors.white,
        fontFamily: 'Sans',
      ),
      home: Scaffold(
          // appBar: AppBar(title: const Text('해동을 부탁해'), actions: <Widget>[
          //   IconButton(
          //     icon: const Icon(Icons.settings),
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (_) => const settingUI()),
          //       );
          //       // settingUI();
          //     },
          //   ),
          // ]),
          // extendBodyBehindAppBar: true,
          body: PageView(children: const [
        wholeCake(),
        pieceCake_1(),
        pieceCake_2(),
      ])),
    );
  }
}

class tmpWidget extends StatelessWidget {
  final int value;
  final int hours;
  final int minutes;

  const tmpWidget(
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
        // color: const Color.fromARGB(255, 244, 244, 244),
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
