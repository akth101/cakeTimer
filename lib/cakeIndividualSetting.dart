import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'timer.dart';
import 'globals.dart' as globals;

import 'cakeName.dart';

//textField에 text를 입력하고 저장 버튼을 누르면 sharedpreference에 저장
//Textfield에 텍스트를 입력하고 변수에 저장

class IndividualSetting extends StatefulWidget {

  final int value;

  const IndividualSetting({Key? key, required this.value}) : super(key: key);

  @override
  State<IndividualSetting> createState() => _IndividualSettingState();
}

class _IndividualSettingState extends State<IndividualSetting> {

  final _textEditingController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textEditingController.dispose();
    super.dispose();
  }

  void recoveryTimer() async {

    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      globals.startTime = _prefs.getString('startTimeBackup-${widget.value}')!;
    });

    DateTime startDateTime = DateTime.parse(globals.startTime!);

    // 이전에 활성화된 타이머를 취소
    globals.currentTimer?.cancel();
    globals.sixHoursLaterTimer?.cancel();


    // 1초마다 '해동 완료까지 남은 시간'을 표시하는 타이머를 시작
    globals.sixHoursLaterTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      DateTime currentDateTime = DateTime.now();
      DateTime sixHoursLater = startDateTime.add(const Duration(seconds: 10));
      Duration timeDifference = sixHoursLater.difference(currentDateTime);

      // 시간, 분, 초별 해동 시작 시각과 6시간 후의 시각 차이를 계산
      int hours = timeDifference.inHours;
      int minutes = (timeDifference.inMinutes % 60);
      int seconds = (timeDifference.inSeconds % 60);

      // 시간 차이를 HH:mm:ss 형식으로 포맷팅
      String formattedTimeDifference =
          '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

      setState(() {
        if (globals.remainingTime != '0:00:00') {
          globals.remainingTime = formattedTimeDifference;
        }
        else {
          globals.currentTimer?.cancel();
          globals.sixHoursLaterTimer?.cancel();
        }
      });
    });
  }




  Widget dialogContent(BuildContext context, String title, String content, int value) {
    late SharedPreferences _prefs;

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(                                            //설정 제목
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 10.0),                          //여백
          TextField(controller: _textEditingController),   //텍스트 입력창
          SizedBox(height: 10.0),                          //여백
          ElevatedButton(                                  //텍스트 저장 버튼
            onPressed: () async {
              _prefs = await SharedPreferences.getInstance();
              await _prefs.setString('cakename-$value', _textEditingController.text);
              // cakeNameSetting(value: widget.value);
            },
            child: Text('저장'),
          ),
          SizedBox(height: 20.0),                            //여백
          ElevatedButton(onPressed: () {                     //복구 버튼
              recoveryTimer();
          },
              child: Text('복구')
          ),
          SizedBox(height: 20.0),                           //여백
          ElevatedButton(                                   //창 닫기 버튼
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: dialogContent(context, '설정', 'content', widget.value),
        );
      }
  }















