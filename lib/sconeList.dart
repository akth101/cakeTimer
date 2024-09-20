import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'breadAddSetting.dart';
import 'breadDataBase.dart';

class SconeList extends StatefulWidget {
  const SconeList({super.key});

  @override
  State<SconeList> createState() => _SconeListState();
}

class _SconeListState extends State<SconeList> {
  Future<void> removeScone(BreadDataBase breadDataBase, String? sconeName) async {
    if (sconeName == null) {
      print('Error: sconeName is null');
      return;
    }

    String? id = breadDataBase.makalongNameDateConnector[sconeName];
    if (id == null) {
      print('Error: id not found for sconeName: $sconeName');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("sconeName_$id");
      await prefs.remove("sconeDisplayOnList_$id");
      await prefs.remove("sconeDate_$id");

      // Update the state or notify listeners
      breadDataBase.buildBreadDB();
      setState(() {});
    } catch (e) {
      print('Error removing scone: $e');
    }
  }

  void _toggleSwitch(BreadDataBase breadDataBase, int index, bool value) async {
    setState(() {
      breadDataBase.sconeDisplay[index] = value;
    });
    breadDataBase.updateBreadDisplay("scone", breadDataBase.sconeName[index], value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("스콘 리스트"),
      ),
      body: Consumer<BreadDataBase>(
        builder: (context, breadDatabase, child) {
          return Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: _buildSconeListView(breadDatabase),
                    ),
                    const Flexible(
                      flex: 1,
                      child: BreadAddSetting(kind: "scone"),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => _showResetConfirmationDialog(context),
                style: ElevatedButton.styleFrom(
                  // primary: Colors.red,
                  // onPrimary: Colors.white,
                ),
                child: const Text('Reset All Data'),
              ),
              const SizedBox(height: 20), // Add some padding at the bottom
            ],
          );
        },
      ),
    );
  }

  Widget _buildSconeListView(BreadDataBase breadDatabase) {
    return ListView.builder(
      itemCount: breadDatabase.sconeName.length,
      itemBuilder: (context, index) => _buildSconeListItem(breadDatabase, index),
    );
  }

  Widget _buildSconeListItem(BreadDataBase breadDatabase, int index) {
    return Dismissible(
      key: Key(breadDatabase.sconeName[index]),
      confirmDismiss: (direction) async => await showAlertDialog(context),
      onDismissed: (direction) async {
        removeScone(breadDatabase, breadDatabase.sconeName[index]);
        breadDatabase.buildBreadDB();
      },
      background: _buildDismissibleBackground(),
      child: _buildListTile(breadDatabase, index),
    );
  }

  Widget _buildDismissibleBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  Widget _buildListTile(BreadDataBase breadDatabase, int index) {
    return ListTile(
      title: Text(breadDatabase.sconeName[index]),
      tileColor: Colors.grey.shade300,
      trailing: Switch(
        value: breadDatabase.sconeDisplay[index],
        onChanged: (value) => _toggleSwitch(breadDatabase, index, value),
      ),
    );
  }

  Future<bool?> showAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '경고!',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text('정말로 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showResetConfirmationDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset All Data'),
          content: const Text('Are you sure you want to reset all data? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Reset'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final breadDataBase = Provider.of<BreadDataBase>(context, listen: false);
      await breadDataBase.resetAllData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All data has been reset')),
      );
    }
  }
}