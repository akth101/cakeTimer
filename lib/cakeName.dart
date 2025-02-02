import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class cakeNameSetting extends StatefulWidget {
  final String cakeKey;

  const cakeNameSetting({super.key, required this.cakeKey});

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cakeName = prefs.getString('cakename_${widget.cakeKey}');
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
              ? Text(
                  cakeName!,
                  style: const TextStyle(fontSize: 19),
                )
              : const Text('None');
        },
      ),
    );
  }
}
