import 'package:flutter/material.dart';
import 'package:timer/cakeWidget.dart';
import 'package:timer/pieceCakeElapsed.dart';
import 'pieceCakeElapsing.dart';
import 'wholeCakeElapsing.dart';
import 'wholeCakeElapsed.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  int? isElapseCompleted;
  Map<String, cakeWidget> _cakes = {};
  List<cakeWidget> _elapsedCakes = [];
  List<cakeWidget> _elapsingCakes = [];

  //Elapsing & Elapsed 프라이빗 변수에 대한 외부에서의 읽기 전용 접근을 제공
  List<cakeWidget> get elapsedCakes => _elapsedCakes;
  List<cakeWidget> get elapsingCakes => _elapsingCakes;

  CakeDataBase() {
    _loadFromPreferences();
    _makeElapsedAndElapsingCakeList();
  }


  Future<void> _loadIsElapseCompleted(int value) async {
    final prefs = await SharedPreferences.getInstance();
      isElapseCompleted = prefs.getInt('isElapseCompleted-$value');
      notifyListeners();
  }

  Future<void> _loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    String cakeKeyValue;
    int? intKeyValue;

    //shared에서 케익 정보를 불러와 map을 만드는 for문.
    //map에는 아래와 같이 데이터가 저장된다
    //key: cakeKey.isElapseCompleted, value: ckaeWidget
    for (String key in keys) {
      if (key.startsWith('cakename-')) {
        cakeKeyValue = key.split('-').last;
        intKeyValue = int.tryParse(cakeKeyValue);
        if (intKeyValue != null) {
          //_loadisElapseCompleted는 비동기이기 때문에 작업이 완료되길 기다린 후에 아래 코드로 넘어간다.
          //안 그러면 isElapseCompleted에는 null값이 들어가게 된다. 
          await _loadIsElapseCompleted(intKeyValue);
          String mapKey = "$intKeyValue.$isElapseCompleted";
          print(mapKey);
          _cakes[mapKey] = cakeWidget(value: intKeyValue);
          print('Map after adding $mapKey: $_cakes');

        }
      }
    }
  }



  void _makeElapsedAndElapsingCakeList() {

    if (_cakes.isEmpty) {
      print("The map is empty");
    return;
  }

    _cakes.forEach((key, value) {
      String? _isElapseCompleted = key.split(".").last;
      print("test");
      print(_isElapseCompleted);
    });
    print("test");


  }

  //   void reorderCakes(int oldIndex, int newIndex) {
  //   if (newIndex > oldIndex) {
  //     newIndex -= 1;
  //   }
  //   final item = _cakes.removeAt(oldIndex);
  //   _cakes.insert(newIndex, item);
  //   notifyListeners();
  // }
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
              // child: _buildSelectedScreen(_selectedIndex),
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildSelectedScreen(int selectedIndex) {
  //   switch (selectedIndex) {
  //     case 0:
  //       return const wholeCakeElapsing();
  //     case 1:
  //       return const wholeCakeElapsed();
  //     case 2:
  //       return const pieceCakeElapsing();
  //     default:
  //       return const pieceCakeElapsed();
  //   }
  // }
}
