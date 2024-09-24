import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sconeList.dart';
import 'makalongList.dart';
import 'breadDataBase.dart';

class sconeAndMakalong extends StatelessWidget {
  const sconeAndMakalong({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "스콘 & 마카롱",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SconeSection(),
          SizedBox(width: 200),
          MakalongSection(),
          // Expanded(
          //   flex: 1,
          //   child: SconeSection()
          //   ),
          // // SizedBox(width: 20),
          // Expanded(child: MakalongSection()),
        ],
      ),
    );
  }
}

class SconeSection extends StatelessWidget {
  const SconeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const BreadDataTable(breadType: "스콘"),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _navigateToBreadList(context, const SconeList()),
          child: const Text("스콘 관리"),
        ),
      ],
    );
  }
}

class MakalongSection extends StatelessWidget {
  const MakalongSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const BreadDataTable(breadType: "마카롱"),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _navigateToBreadList(context, const MakalongList()),
          child: const Text("마카롱 관리"),
        ),
      ],
    );
  }
}

void _navigateToBreadList(BuildContext context, Widget listPage) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => listPage),
  );
}

class BreadDataTable extends StatelessWidget {
  final String breadType;

  const BreadDataTable({super.key, required this.breadType});

  @override
  Widget build(BuildContext context) {
    return Consumer<BreadDataBase>(
      builder: (context, breadDatabase, child) {
        List<String> names = [];
        List<String> dates = [];
        List<bool> displayStatus = [];

        if (breadType == "스콘") {
          names = breadDatabase.sconeName;
          dates = breadDatabase.sconeDate;
          displayStatus = breadDatabase.sconeDisplay;
        } else if (breadType == "마카롱") {
          names = breadDatabase.makalongName;
          dates = breadDatabase.makalongDate;
          displayStatus = breadDatabase.makalongDisplay;
        }

        List<int> displayedIndices = [];
        for (int i = 0; i < displayStatus.length; i++) {
          if (displayStatus[i]) {
            displayedIndices.add(i);
          }
        }

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columnSpacing: 20,
            columns: _buildColumns(),
            rows: _buildRows(context, breadDatabase, names, dates, displayedIndices),
          ),
        );
      },
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      DataColumn(
        label: Text(
          breadType,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      const DataColumn(
        label: Text(
          '진열 날짜',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    ];
  }

  List<DataRow> _buildRows(BuildContext context, BreadDataBase breadDatabase, List<String> names, List<String> dates, List<int> displayedIndices) {
    return List.generate(
      displayedIndices.length,
      (index) => DataRow(
        cells: [
          DataCell(Text(names[displayedIndices[index]])),
          DataCell(
            Text(dates[displayedIndices[index]]),
            onTap: () => _updateDate(context, breadDatabase, names[displayedIndices[index]]),
          ),
        ],
      ),
    );
  }

  void _updateDate(BuildContext context, BreadDataBase breadDatabase, String name) {
    DateTime today = DateTime.now();
    breadDatabase.updateBreadDate(breadType, name, today);

    // Show a snackbar to confirm the update
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name의 진열 날짜가 오늘로 업데이트되었습니다.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
