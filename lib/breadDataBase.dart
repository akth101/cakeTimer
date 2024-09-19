
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BreadDataBase extends ChangeNotifier {

    static final BreadDataBase _instance = BreadDataBase._internal();

  factory BreadDataBase() {
    return _instance;
  }

  static BreadDataBase get instance => _instance;

  final Map<String, String> _makalongNameDateConnector = {};
  final List<String> _makalongName = [];
  final List<String> _makalongDate = [];
  final List<bool> _makalongDisplay = [];
  final Map<String, String> _sconeNameDateConnector = {};
  final List<String> _sconeName = [];
  late List<String> _sconeDate = [];
  List<bool> _sconeDisplay = [];

  Map<String, String> get makalongNameDateConnector => _makalongNameDateConnector;
  List<String> get makalongName => _makalongName;
  List<String> get makalongDate => _makalongDate;
  List<bool> get makalongDisplay => _makalongDisplay;
  Map<String, String> get sconeNameDateConnector => _sconeNameDateConnector;
  List<String> get sconeName => _sconeName;
  List<String> get sconeDate => _sconeDate;
  List<bool> get sconeDisplay => _sconeDisplay;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

    BreadDataBase._internal() {
    _initialize();
  }

  Future<void> _initialize() async {
    await buildBreadDB();
  }

  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      print("breadDatabase is prepared.");
      await _initialize();
    }
  }

  Future<String?> loadBreadName(String breadKey, String kind) async {
    final prefs = await SharedPreferences.getInstance();
    String? breadName;

    if (kind == "scone") {
      breadName = prefs.getString("sconeName_$breadKey");
    }
    else if (kind == "makalong") {
      breadName = prefs.getString("makalongName_$breadKey");
    }
    notifyListeners();
    return (breadName);
  }

  Future<String?> loadBreadDate(String breadKey, String kind) async {
    final prefs = await SharedPreferences.getInstance();
    String? breadDate;

    if (kind == "scone") {
      breadDate = prefs.getString("sconeDate_$breadKey");
    }
    else if (kind == "makalong") {
      breadDate = prefs.getString("makalongName_$breadKey");
    }
    notifyListeners();
    return (breadDate);
  }

  Future<bool> loadBreadDisplay(String breadKey, String kind) async {
    final prefs = await SharedPreferences.getInstance();
    int display = 0;

    if (kind == "scone") {
      display = prefs.getInt("sconeDisplayOnList_$breadKey")!;
    }
    else if (kind == "makalong") {
      display = prefs.getInt("makalongDisplayOnList_$breadKey")!;
    }
    notifyListeners();
    if (display == 1) {
      return (true);
    } else {
      return (false);
    }
  }

    Future<void> buildBreadDB() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    //NameList & <Name : uuid> Map 먼저 초기화
    for (String key in keys) {
      if (key.startsWith('sconeName_')) {
        String sconeKey = key.split('_').last;
        String? sconeName = await loadBreadName(sconeKey, "scone");
        _sconeNameDateConnector[sconeName!] = sconeKey;
        _sconeName.add(sconeName);
      }
      if (key.startsWith('makalongName_')) {
        String makalongKey = key.split('_').last;
        String? makalongName = await loadBreadName(makalongKey, "makalong");
        _makalongNameDateConnector[makalongName!] = makalongKey;
        _makalongName.add(makalongName);
      }
    }

      //NameList 가나다순 정렬
      _sconeName.sort();
      _makalongName.sort();

 
      _sconeDate = List<String>.filled(_sconeName.length, '');
      _sconeDisplay = List<bool>.filled(_sconeName.length, false);

      //scone [Namelist & Datelist & Display] index 일치화 작업
      for (int i = 0; i < _sconeName.length; i++) {
        String sconeKey = _sconeNameDateConnector[_sconeName[i]]!;
        _sconeDate[i] = (await loadBreadDate(sconeKey, "scone"))!;
        _sconeDisplay[i] = (await loadBreadDisplay(sconeKey, "scone"));
      }

      //makalong [Namelist & Datelist & Display] index 일치화 작업
      for (int i = 0; i < _makalongName.length; i++) {
        String makalongKey = _makalongNameDateConnector[_makalongName[i]]!;
        _sconeDate[i] = (await loadBreadDate(makalongKey, "makalong"))!;
        _sconeDisplay[i] = (await loadBreadDisplay(makalongKey, "makalong"));
      }
  }

    Future<void> updateBreadDisplay(String kind, String name, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    String id = "";
    if (kind == "scone") {
      id = sconeNameDateConnector[name]!;
      await prefs.setInt("sconeDisplayOnList_$id", value ? 1 : 0);
    } else {
      id = makalongNameDateConnector[name]!;
      await prefs.setInt("makalongDisplayOnList_$id", value ? 1 : 0);
    }
    notifyListeners();
  }
}