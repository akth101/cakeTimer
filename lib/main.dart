import 'package:flutter/material.dart';
import 'package:timer/cakeWidget.dart';
import 'package:timer/pieceCakeElapsed.dart';
import 'pieceCakeElapsing.dart';
import 'wholeCakeElapsing.dart';
import 'wholeCakeElapsed.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CakeDataBase(),
      child: const MaterialApp(
        title: 'Navigator',
        home: MyApp(),
      ),
    ),
  );
}

class CakeDataBase extends ChangeNotifier {

  static final CakeDataBase _instance = CakeDataBase._internal();
  
  factory CakeDataBase() {
    return _instance;
  }

  static CakeDataBase get instance => _instance;

  int? isElapseCompleted;
  Map<String, cakeWidget> _cakes = {};
  List<cakeWidget> _elapsedCakes = [];
  List<cakeWidget> _elapsingCakes = [];

  //Elapsing & Elapsed 프라이빗 변수에 대한 외부에서의 읽기 전용 접근을 제공
  List<cakeWidget> get elapsedCakes => _elapsedCakes;
  List<cakeWidget> get elapsingCakes => _elapsingCakes;

  CakeDataBase._internal() {
    _initialize();
  }

  Future<void> _initialize() async {
    await loadFromPreferences();
    makeElapsedAndElapsingCakeList();
  }


  Future<void> loadIsElapseCompleted(int value) async {
    final prefs = await SharedPreferences.getInstance();
      isElapseCompleted = prefs.getInt('isElapseCompleted-$value');
      notifyListeners();
  }

  Future<void> loadFromPreferences() async {

    _cakes.clear();
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    String cakeKeyValue;
    int? intKeyValue;

    //shared에서 케익 정보를 불러와 map을 만드는 for문.
    //map에는 아래와 같이 데이터가 저장된다
    //key: cakeKey.isElapseCompleted, value: cakeWidget
    for (String key in keys) {
      if (key.startsWith('cakename-')) {
        cakeKeyValue = key.split('-').last;
        intKeyValue = int.tryParse(cakeKeyValue);
        if (intKeyValue != null) {
          //_loadisElapseCompleted는 비동기이기 때문에 작업이 완료되길 기다린 후에 아래 코드로 넘어간다.
          //안 그러면 isElapseCompleted에는 null값이 들어가게 된다. 
          await loadIsElapseCompleted(intKeyValue);
          String mapKey = "$intKeyValue.$isElapseCompleted";
          _cakes[mapKey] = cakeWidget(value: intKeyValue);
        }
      }
    }
  }

  void reBuildCakeList() async {
    await loadFromPreferences();
    makeElapsedAndElapsingCakeList();
    notifyListeners();
  }

  void makeElapsedAndElapsingCakeList() {

    _elapsingCakes.clear();
    _elapsedCakes.clear();
    _cakes.forEach((key, value) {
      String? _isElapseCompleted = key.split(".").last;
      String? _cakeValue = key.split(".").first;
      int? _intCakeValue = int.tryParse(_cakeValue);
      int _nonNullCakeValue = _intCakeValue!;
      print("key: $_cakeValue");
      print("isElapseCompleted: $_isElapseCompleted");

      if (_isElapseCompleted == "0") {
        _elapsingCakes.add(cakeWidget(value: _nonNullCakeValue));
      }
      if (_isElapseCompleted == "1") {
        _elapsedCakes.add(cakeWidget(value: _nonNullCakeValue));
      }
    });

    // print("elapsing: ");
    // print(_elapsingCakes);
    // print("elapsed: ");
    // print(_elapsedCakes);
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
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  //annotaiton
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 선택된 인덱스를 업데이트하여 상태를 변경
    });
  }

  @override
  void initState() {
    CakeDataBase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "caker",
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 0, 0, 0),
        canvasColor: Colors.white,
        fontFamily: 'Sans',
      ),
      home: Scaffold(
        body: Row(
          children: <Widget>[
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              groupAlignment: 0,
              labelType: NavigationRailLabelType.selected,
              
              leading: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => 
                    const settings(),
                    ),
                  );

                },
                child: const Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Icon(Icons.settings),
                  ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.cake_outlined),
                  selectedIcon: Icon(Icons.cake_outlined),
                  label: Text('홀 해동 중'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.cake_rounded),
                  selectedIcon: Icon(Icons.cake_rounded),
                  label: Text('홀 해동 완'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.cake),
                  selectedIcon: Icon(Icons.person),
                  label: Text('조각 해동 중'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  selectedIcon: Icon(Icons.person),
                  label: Text('조각 해동 완'),
                ),
              ],
            ),
            Expanded(
              child: _buildSelectedScreen(_selectedIndex),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedScreen(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return const wholeCakeElapsing();
      case 1:
        return const wholeCakeElapsed();
      case 2:
        return const pieceCakeElapsing();
      default:
        return const pieceCakeElapsed();
    }
  }
}
