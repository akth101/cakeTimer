import 'package:flutter/material.dart';
import 'package:timer/timer.dart';

void main() {
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
                  tmpWidget(),
                  tmpWidget(),
                  tmpWidget(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  tmpWidget(),
                  tmpWidget(),
                  tmpWidget(),
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
  const tmpWidget({super.key});

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
      child: const cakeTimer(),
    );
  }
}
