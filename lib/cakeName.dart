import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class cakeNameSetting extends StatefulWidget {

  final int value;

  const cakeNameSetting({Key? key, required this.value}) : super(key: key);

  @override
  State<cakeNameSetting> createState() => _cakeNameSettingState();
}

class _cakeNameSettingState extends State<cakeNameSetting> {

  String? cakeName;
  late SharedPreferences _prefs;

  Future<void> _loadCakeName() async {
    cakeName = await _prefs.getString('cakename-${widget.value}');
  }

  @override
  Widget build(BuildContext context) {
    return (cakeName != null)
      ? Text(cakeName!)
      : Text('');
  }
}
