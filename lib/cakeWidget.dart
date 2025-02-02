import 'package:flutter/material.dart';
import 'caketimerUI.dart';

class cakeWidget extends StatefulWidget {
  final String cakeKey;

  const cakeWidget({
    super.key,
    required this.cakeKey,
  });

  @override
  State<cakeWidget> createState() => _cakeWidgetState();
}

class _cakeWidgetState extends State<cakeWidget> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    return Container(
      width: (screenWidth - 80) / 4 - screenWidth * 0.02,
      height: screenHeight / 2 - screenHeight * 0.03,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(224, 224, 224, 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CakeTimerUI(cakeKey: widget.cakeKey),
        ],
      ),
    );
  }
}
