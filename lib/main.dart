import 'package:flutter/material.dart';
import 'package:timer/wholeCakeList.dart';
import 'wholeCakeElapsing.dart';
import 'wholeCakeElapsed.dart';
import 'sconeAndMakalong.dart';
import 'package:provider/provider.dart';
import 'settings.dart';
import 'breadDataBase.dart';
import 'cakeDataBase.dart';

// void main() async {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => CakeDataBase()),
//         ChangeNotifierProvider(create: (context) => BreadDataBase()),
//       ],
//       child: const MaterialApp(
//         title: 'Navigator',
//         home: MyApp(),
//       ),
//     ),
//   );
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final breadDataBase = BreadDataBase();
  await breadDataBase.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CakeDataBase()),
        ChangeNotifierProvider.value(value: breadDataBase),
      ],
      child: const MaterialApp(
        title: 'Navigator',
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
    BreadDataBase();
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
              minWidth: 80,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const settings(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Icon(
                      Icons.settings,
                      size: 32,
                    ),
                  ),
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.cake_outlined),
                  selectedIcon: Icon(Icons.cake_outlined),
                  label: Text('해동 중'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.cake_rounded),
                  selectedIcon: Icon(Icons.cake_rounded),
                  label: Text('해동 완'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.electric_bolt_sharp),
                  selectedIcon: Icon(Icons.electric_bolt_sharp),
                  label: Text('빠른 설정'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.bakery_dining),
                  selectedIcon: Icon(Icons.bakery_dining),
                  label: Text('스콘 & 마카롱'),
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
      case 3:
        return const sconeAndMakalong();
      default:
        return const wholeCakeList();
    }
  }
}
