import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//textField에 text를 입력하고 저장 버튼을 누르면 sharedpreference에 저장
//Textfield에 텍스트를 입력하고 변수에 저장

void showIndividualSetting(BuildContext context, String title, String content, int value) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: dialogContent(context, title, content, value),
      );
    },
  );
}

Widget dialogContent(BuildContext context, String title, String content, int value) {
  late SharedPreferences _prefs;
  TextEditingController _textEditingController = TextEditingController();
  String savedText = '';

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
              savedText = _textEditingController.text;
              _prefs = await SharedPreferences.getInstance();
              await _prefs.setString('cakename-$value', savedText);
            // _textEditingController.clear();
            },
          child: Text('저장'),
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
//
// late SharedPreferences _prefs;
// final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
//
//
// Future<void> _saveImagePath(String? imagePath) async {
//   _prefs = await SharedPreferences.getInstance();
//   await _prefs.setString('imagePath${widget.value3}', imagePath!);
// }