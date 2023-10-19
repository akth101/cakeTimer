import 'package:flutter/material.dart';

import 'cakeTimerUI.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class tmpWidget extends StatelessWidget {
  final int value;

  const tmpWidget({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    return Container(
      width: screenWidth / 3 - screenWidth * 0.01,
      height: screenHeight / 2 - screenWidth * 0.01,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.lightGreen,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CakeTimerUI(value: value),
        ],
      ),
    );
  }
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
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    tmpWidget(value: 1),
                    tmpWidget(value: 2),
                    tmpWidget(value: 3),
                  ],
                ),
                ),
                Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    tmpWidget(value: 4),
                    tmpWidget(value: 5),
                    tmpWidget(value: 6),
                  ],
                ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
