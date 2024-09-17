import 'package:flutter/material.dart';
import 'sconeList.dart';
import 'makalongList.dart';

class DataTableExample extends StatelessWidget {
  final String bread;

  DataTableExample({super.key, required this.bread});

  double textFontSize = 20;
  double headerFontSize = 25;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columnSpacing: 100,
        columns: [
          DataColumn(
            label: Text(
              bread,
              style: TextStyle(fontSize: headerFontSize), // 폰트 크기 적용
            ),
          ),
          DataColumn(
            label: Text(
              '진열 날짜',
              style: TextStyle(fontSize: headerFontSize), // 폰트 크기 적용
            ),
            numeric: true,
          ),
        ],
        rows: [
          DataRow(cells: [
            DataCell(
              Text(
                'Alice',
                style: TextStyle(fontSize: textFontSize), // 폰트 크기 적용
              ),
            ),
            DataCell(
              Text(
                '24',
                style: TextStyle(fontSize: textFontSize), // 폰트 크기 적용
              ),
            ),
          ]),
          DataRow(cells: [
            DataCell(
              Text(
                'Bob',
                style: TextStyle(fontSize: textFontSize), // 폰트 크기 적용
              ),
            ),
            DataCell(
              Text(
                '30',
                style: TextStyle(fontSize: textFontSize), // 폰트 크기 적용
              ),
            ),
          ]),
          DataRow(cells: [
            DataCell(
              Text(
                'Charlie',
                style: TextStyle(fontSize: textFontSize), // 폰트 크기 적용
              ),
            ),
            DataCell(
              Text(
                '29',
                style: TextStyle(fontSize: textFontSize), // 폰트 크기 적용
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class sconeAndMakalong extends StatefulWidget {
  const sconeAndMakalong({super.key});

  @override
  State<sconeAndMakalong> createState() => _sconeAndMakalongState();
}

class _sconeAndMakalongState extends State<sconeAndMakalong> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "스콘 & 마카롱",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DataTableExample(bread: "스콘"),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => (SconeList()), // 이동할 페이지
                        ),
                      );
                    },
                    child: const Text("스콘 관리")),
              ],
            ),
            Container(
              width: 70,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DataTableExample(bread: "마카롱"),
                ElevatedButton(onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => (Makalonglist()), // 이동할 페이지
                        ),
                      );
                }, child: const Text("마카롱 관리")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
