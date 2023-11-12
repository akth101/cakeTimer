import 'package:flutter/material.dart';

import 'cakeTimerUI.dart';
import 'settingUI.dart';
import 'pieceCake.dart';

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


  // Widget pieceCake() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         Expanded(
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               tmpWidget(value: 9, hours: 1, minutes: 0),
  //               tmpWidget(value: 10, hours: 1, minutes: 0),
  //               tmpWidget(value: 11, hours: 1, minutes: 0),
  //               tmpWidget(value: 12, hours: 1, minutes: 0),
  //             ],
  //           ),
  //         ),
  //         Expanded(
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               tmpWidget(value: 13, hours: 1, minutes: 0),
  //               tmpWidget(value: 14, hours: 1, minutes: 0),
  //               tmpWidget(value: 15, hours: 1, minutes: 0),
  //               tmpWidget(value: 16, hours: 1, minutes: 0),
  //
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  //
  // }


  // void wholeOrPieceCake() {
  //   return (pageView == 0)
  //       ? Navigator.push(
  //     context, MaterialPageRoute(builder: (_) => wholeCake()),
  //   )
  //       : Navigator.push(
  //     context, MaterialPageRoute(builder: (_) => pieceCake()),
  //   );
  // }

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
              icon: Icon(Icons.access_alarm),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => pieceCake()),
                );
              },
            ),
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    tmpWidget(value: 1, hours: 6, minutes: 0),
                    tmpWidget(value: 2, hours: 6, minutes: 0),
                    tmpWidget(value: 3, hours: 6, minutes: 0),
                    tmpWidget(value: 4, hours: 6, minutes: 0),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    tmpWidget(value: 5, hours: 6, minutes: 0),
                    tmpWidget(value: 6, hours: 6, minutes: 0),
                    tmpWidget(value: 7, hours: 6, minutes: 0),
                    tmpWidget(value: 8, hours: 6, minutes: 0),
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
