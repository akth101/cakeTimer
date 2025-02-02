import 'package:flutter/foundation.dart';
import 'package:timer/cakeWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CakeDataBase extends ChangeNotifier {
  static final CakeDataBase _instance = CakeDataBase._internal();

  factory CakeDataBase() {
    return _instance;
  }

  static CakeDataBase get instance => _instance;

  //mapkey를 만들기 위한 재료들
  int? isElapseCompleted;
  int? displayOnList;

  final Map<String, cakeWidget> _cakes = {};
  final Map<String, bool> _cakeDisplay = {};
  final List<cakeWidget> _elapsedCakes = [];
  final List<cakeWidget> _elapsingCakes = [];
  final List<String> _cakeNameList = [];

  //각 맵 or 리스트 프라이빗 변수에 대한 외부에서의 읽기 전용 접근을 제공
  Map<String, cakeWidget> get cakes => _cakes;
  Map<String, bool> get cakeDisplay => _cakeDisplay;
  List<cakeWidget> get elapsedCakes => _elapsedCakes;
  List<cakeWidget> get elapsingCakes => _elapsingCakes;
  List<String> get cakeNameList => _cakeNameList;

  CakeDataBase._internal() {
    _initialize();
  }

  Future<void> _initialize() async {
    await loadFromPreferences();
    await makeCakeNameList();
    await makeCakeDisplay();
    makeElapsedAndElapsingCakeList();
  }

  Future<void> loadIsElapseCompleted(String cakeKey) async {
    final prefs = await SharedPreferences.getInstance();
    isElapseCompleted = prefs.getInt('isElapseCompleted_$cakeKey');
    notifyListeners();
  }

  Future<void> loadDisplayOnList(String cakeKey) async {
    final prefs = await SharedPreferences.getInstance();
    displayOnList = prefs.getInt('displayonlist_$cakeKey');
    notifyListeners();
  }

  Future<void> loadFromPreferences() async {
    _cakes.clear();
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    String cakeKeyValue;

    //shared에서 케익 정보를 불러와 map을 만드는 for문.
    //map에는 아래와 같이 데이터가 저장된다
    //key: cakeKey.isElapseCompleted, value: cakeWidget
    //_loadisElapseCompleted는 비동기이기 때문에 작업이 완료되길 기다린 후에 아래 코드로 넘어간다.
    //안 그러면 isElapseCompleted에는 null값이 들어가게 된다.
    for (String key in keys) {
      if (key.startsWith('cakename_')) {
        cakeKeyValue = key.split('_').last;
        await loadIsElapseCompleted(cakeKeyValue);
        await loadDisplayOnList(cakeKeyValue);
        String mapKey = "$cakeKeyValue.$isElapseCompleted.$displayOnList";
        _cakes[mapKey] = cakeWidget(cakeKey: cakeKeyValue);
      }
    }
  }

  void reBuildCakeList() async {
    await loadFromPreferences();
    await makeCakeNameList();
    await makeCakeDisplay();
    makeElapsedAndElapsingCakeList();
    notifyListeners();
  }

  void makeElapsedAndElapsingCakeList() {
    _elapsingCakes.clear();
    _elapsedCakes.clear();
    _cakes.forEach((key, value) {
      List<String> values = key.split('.');
      String cakeKeyValue = values[0];
      String isElapseCompleted = values[1];
      String displayOnList = values[2];
      // print("cakeValue: $cakeKeyValue");
      // print("isElapseCompleted: $isElapseCompleted");
      // print("displayOnList: $displayOnList");
      if (isElapseCompleted == "0" && displayOnList == "1") {
        _elapsingCakes.add(cakeWidget(cakeKey: cakeKeyValue));
      }
      if (isElapseCompleted == "1" && displayOnList == "1") {
        _elapsedCakes.add(cakeWidget(cakeKey: cakeKeyValue));
      }
    });

    // print("elapsing: ");
    // print(_elapsingCakes);
    // print("elapsed: ");
    // print(_elapsedCakes);
    notifyListeners();
  }

  Future<void> makeCakeNameList() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    cakeNameList.clear();

    for (String key in keys) {
      if (key.startsWith('cakename_')) {
        String? cakeName = prefs.getString(key);
        if (cakeName == null) {
          if (!kReleaseMode) {
          print("Error");
          }
        } else {
          cakeNameList.add(cakeName);
        }
      }
    }
    print("wholeCakeSettingpagelist:");
    print(cakeNameList);
    notifyListeners();
  }

  Future<void> makeCakeDisplay() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (String key in keys) {
      if (key.startsWith('cakename_')) {
        String id = key.split('_').last;
        String? cakeName = prefs.getString(key);
        int? display = prefs.getInt('displayonlist_$id');
        print("cakeName: $cakeName");
        print("display: $display");
        if (cakeName != null && display != null) {
          if (display == 1) {
            _cakeDisplay[cakeName] = true;
          } else {
            _cakeDisplay[cakeName] = false;
          }
        }
      }
    }
    print("makeCakeDisplay:");
    _cakeDisplay.forEach((key, value) {
      print('Key: $key, Value: $value');
    });
    notifyListeners();
  }

  Future<void> updateCakeDisplay(String cakeName, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (String key in keys) {
      if (key.startsWith("cakename_")) {
        String? compareCakeName = prefs.getString(key);
        if (cakeName == compareCakeName) {
          String id = key.split('_').last;
          if (value == true) {
           await prefs.setInt("displayonlist_$id", 1);
            break;
          } else {
            await prefs.setInt("displayonlist_$id", 0);
            break;
          }
        }
      }
    }
    reBuildCakeList();
    notifyListeners();
  }

  void reorderElapsingCakes(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = _elapsingCakes.removeAt(oldIndex);
    _elapsingCakes.insert(newIndex, item);
    notifyListeners();
  }

  void reorderElapsedCakes(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = _elapsedCakes.removeAt(oldIndex);
    _elapsedCakes.insert(newIndex, item);
    notifyListeners();
  }

  Future<void> removeCake(String? id) async {
    if (id == null) {
      // print('Error: id is null');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("cakename_$id");
      await prefs.remove("displayonlist_$id");
      await prefs.remove("isElapseCompleted_$id");
      await prefs.remove("selectedHour_$id");
      await prefs.remove("selectedMinute_$id");
      await prefs.remove("soundSetting_$id");
      await prefs.remove("imagePath_$id");
      await prefs.remove("ringAlarmSoundOnlyOnce_$id");
      await prefs.remove("startTimeBackUp_$id");
      await prefs.remove("startTime_$id");
      
      // Comment out success message
      // print('Cake removed successfully');
      
      // Notify listeners or update state
      notifyListeners();
    } catch (e) {
      print('Error removing cake: $e');
    }
  }
}
