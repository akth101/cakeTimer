import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'timer.dart';

import 'cakeName.dart';

class IndividualSetting extends StatefulWidget {

  final int value;
  final void Function(int) saveIsNeedToRecovered;


  const IndividualSetting({Key? key, required this.value, required this.saveIsNeedToRecovered}) : super(key: key);

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
          ElevatedButton(                                    //복구 버튼
              onPressed: () {
            widget.saveIsNeedToRecovered(1);
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














