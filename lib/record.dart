import 'package:shared_preferences/shared_preferences.dart';

void cakeSold(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? storedValue = prefs.getInt(name) ?? 0;
  prefs.setInt(name, ++storedValue);
}

Future<int> getCakeSoldCount(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int storedValue = prefs.getInt(name) ?? 0;
  return storedValue;
}
