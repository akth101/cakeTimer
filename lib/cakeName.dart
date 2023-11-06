import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class cakeNameSetting extends StatefulWidget {

  final int value;

  const cakeNameSetting({Key? key, required this.value}) : super(key: key);

  @override
  State<cakeNameSetting> createState() => _cakeNameSettingState();
}

class _cakeNameSettingState extends State<cakeNameSetting> {

  // SharedPreferences _prefs = await SharedPreferences.getInstance();
  // final SharedPreferences _prefs = await SharedPreferences.getInstance();
  // late SharedPreferences _prefs = await SharedPreferences.getInstance();


  String? cakeName;

  @override
  void initState() {
    super.initState();
    _loadCakeName();
  }

  Future<void> _loadCakeName() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      cakeName = _prefs.getString('cakename-${widget.value}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
          // FutureBuilder를 사용하여 데이터를 가져와 표시
          child: FutureBuilder<void>(
            future: _loadCakeName(), // 비동기 함수를 호출하여 Future 반환
            builder: (context, snapshot) {
              return (cakeName != null)
              ? Text(cakeName!)
              : Text('error');
            },
          ),
        );
  }
}

