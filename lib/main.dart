import 'package:flutter/material.dart';
import 'package:timer/cakeWidget.dart';
import 'package:timer/pieceCake_2.dart';
import 'pieceCake_1.dart';
import 'wholeCake.dart';
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
  List <cakeWidget> _cakes = [];

  //_cakes 프라이빗 변수에 대한 외부에서의 읽기 전용 접근을 제공
  List<cakeWidget> get cakes => _cakes;

   CakeDataBase() {
    _loadFromPreferences();
  }

  Future<void> _loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    String cakeKeyValue;
    int? intKeyValue;
    _cakes = [];

    for (String key in keys) {
      if (key.startsWith('cakename-')) {
        cakeKeyValue = key.split('-').last;
        intKeyValue = int.tryParse(cakeKeyValue);
        if (intKeyValue != null) {
           _cakes.add(cakeWidget(value: intKeyValue));
         }
        }
      }
    if (_cakes.isNotEmpty) {
      print("good");
    }
    }
    @override
    notifyListeners();
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
        return wholeCake();
      case 1:
        return pieceCake_1();
      case 2:
        return pieceCake_2();
      default:
        return Container();
    }
  }
}
