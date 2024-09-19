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
  void removeScone(BreadDataBase breadDataBase, String? sconeName) async {
    String? id = breadDataBase.makalongNameDateConnector[sconeName];
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("sconeName_$id");
    prefs.remove("sconeDisplayOnList_$id");
    prefs.remove("sconeDate_$id");
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
          return Row(
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: breadDatabase.sconeName.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(breadDatabase.sconeName[index]),
                            confirmDismiss: (direction) async {
                              return await showAlertDialog(context);
                            },
                            onDismissed: (direction) async {
                              removeScone(breadDatabase, breadDatabase.sconeName[index]);
                              breadDatabase.buildBreadDB();
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: ListTile(
                              title: Text(breadDatabase.sconeName[index]),
                              tileColor: Colors.grey.shade300,
                              trailing: Switch(
                                value: breadDatabase.sconeDisplay[index],
                                onChanged: (value) {
                                  _toggleSwitch(breadDatabase, index, value);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Flexible(
                flex: 1,
                child: BreadAddSetting(kind: "scone"),
              ),
            ],
          );
        },
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
}