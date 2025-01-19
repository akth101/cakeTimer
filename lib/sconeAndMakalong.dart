import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sconeList.dart';
import 'makalongList.dart';
import 'breadDataBase.dart';

class sconeAndMakalong extends StatelessWidget {
  const sconeAndMakalong({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "스콘 & 마카롱",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isLandscape
                ? const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: BreadSection(breadType: "스콘", icon: Icons.bakery_dining)),
                      SizedBox(width: 16),
                      Expanded(child: BreadSection(breadType: "마카롱", icon: Icons.cookie)),
                    ],
                  )
                : const Column(
                    children: [
                      BreadSection(breadType: "스콘", icon: Icons.cake),
                      SizedBox(height: 16),
                      BreadSection(breadType: "마카롱", icon: Icons.cookie),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class BreadSection extends StatelessWidget {
  final String breadType;
  final IconData icon;

  const BreadSection({super.key, required this.breadType, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 30, color: Colors.teal),
                const SizedBox(width: 8),
                Text(
                  breadType,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            BreadDataTable(breadType: breadType),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _navigateToBreadList(context, breadType == "스콘" ? const SconeList() : const MakalongList()),
                icon: const Icon(Icons.edit),
                label: Text("$breadType 관리"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
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

        return Column(
          children: displayedIndices.map((index) => 
            BreadItem(
              name: names[index],
              date: dates[index],
              onTap: () => _updateDate(context, breadDatabase, names[index]),
            )
          ).toList(),
        );
      },
    );
  }

  void _updateDate(BuildContext context, BreadDataBase breadDatabase, String name) {
    DateTime today = DateTime.now();
    breadDatabase.updateBreadDate(breadType, name, today);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name의 진열 날짜가 오늘로 업데이트되었습니다.'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.teal,
      ),
    );
  }
}

class BreadItem extends StatelessWidget {
  final String name;
  final String date;
  final VoidCallback onTap;

  const BreadItem({super.key, required this.name, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(date, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.teal),
          onPressed: onTap,
        ),
      ),
    );
  }
}
