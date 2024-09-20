import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'breadAddSetting.dart';
import 'breadDataBase.dart';

class MakalongList extends StatefulWidget {
  const MakalongList({super.key});

  @override
  State<MakalongList> createState() => _MakalongListState();
}

class _MakalongListState extends State<MakalongList> {
  Future<void> removeMakalong(BreadDataBase breadDataBase, String? makalongName) async {
    if (makalongName == null) {
      print('Error: makalongName is null');
      return;
    }

    String? id = breadDataBase.makalongNameDateConnector[makalongName];
    if (id == null) {
      print('Error: id not found for makalongName: $makalongName');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("makalongName_$id");
      await prefs.remove("makalongDisplayOnList_$id");
      await prefs.remove("makalongDate_$id");

      // Update the state or notify listeners
      await breadDataBase.buildBreadDB();
    } catch (e) {
      print('Error removing makalong: $e');
    }
  }

  void _toggleSwitch(BreadDataBase breadDataBase, int index, bool value) async {
    breadDataBase.updateBreadDisplay("makalong", breadDataBase.makalongName[index], value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("마카롱 리스트"),
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
                      child: _buildMakalongListView(breadDatabase),
                    ),
                    const Flexible(
                      flex: 1,
                      child: BreadAddSetting(kind: "makalong"),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => _showResetConfirmationDialog(context),
                child: const Text('Reset All Data'),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMakalongListView(BreadDataBase breadDatabase) {
    return ListView.builder(
      itemCount: breadDatabase.makalongName.length,
      itemBuilder: (context, index) => _buildMakalongListItem(breadDatabase, index),
    );
  }

  Widget _buildMakalongListItem(BreadDataBase breadDatabase, int index) {
    return Dismissible(
      key: Key(breadDatabase.makalongName[index]),
      confirmDismiss: (direction) async => await showAlertDialog(context),
      onDismissed: (direction) async {
        final removedName = breadDatabase.makalongName[index];
        await removeMakalong(breadDatabase, removedName);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$removedName removed')),
        );
        setState(() {}); // Trigger a rebuild of the widget tree
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
      title: Text(breadDatabase.makalongName[index]),
      tileColor: Colors.grey.shade300,
      trailing: Switch(
        value: breadDatabase.makalongDisplay[index],
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
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
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