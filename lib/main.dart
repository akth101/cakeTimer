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

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "caker",
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  tmpWidget(value1: 1),
                  tmpWidget(value1: 2),
                  tmpWidget(value1: 3),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  tmpWidget(value1 : 4),
                  tmpWidget(value1 : 5),
                  tmpWidget(value1 : 6),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class tmpWidget extends StatelessWidget {

  final int value1;

  const tmpWidget({super.key, required this.value1});


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
      CakeTimerUI(value2: value1),
      ],
    ),
    );
  }
}
