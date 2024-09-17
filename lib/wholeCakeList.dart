import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer/cakeAddSetting.dart';
import 'cakeDataBase.dart';

class wholeCakeList extends StatefulWidget {
  const wholeCakeList({super.key});

  @override
  State<wholeCakeList> createState() => _wholeCakeListState();
}

class _wholeCakeListState extends State<wholeCakeList> {
  Future<String?> findKeyId(String cakeName) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith("cakename_")) {
        String? cakeNameCompare = prefs.getString(key);
        if (cakeName == cakeNameCompare) {
          String? id = key.split('_').last;
          return (id);
        }
      }
    }
    return (null);
  }

  void removeCake(String? id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("cakename_$id");
    prefs.remove("displayonlist_$id");
    prefs.remove("isElapseCompleted_$id");
    prefs.remove("selectedHour_$id");
    prefs.remove("selectedMinute_$id");
    prefs.remove("soundSetting_$id");
    prefs.remove("imagePath_$id");
    prefs.remove("ringAlarmSoundOnlyOnce_$id");
    prefs.remove("startTimeBackUp_$id");
    prefs.remove("startTime_$id");
    return;
  }

  void _toggleSwitch(CakeDataBase cakeDataBase, int index, bool value) async {
    setState(() {
      cakeDataBase.cakeDisplay[cakeDataBase.cakeNameList[index]] = value;
    });
    cakeDataBase.updateCakeDisplay(cakeDataBase.cakeNameList[index], value);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CakeDataBase>(
      builder: (context, cakeDatabase, child) {
        return Row(
          children: [
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  Container(
                    height: 40,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 19,
                      child: Text(
                        "홀케익 리스트",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: cakeDatabase.cakeNameList.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(cakeDatabase.cakeNameList[index]),
                            confirmDismiss: (direction) async {
                              return await showAlertDialog(context);
                            },
                            onDismissed: (direction) async {
                              String? id = await findKeyId(
                                  cakeDatabase.cakeNameList[index]);
                              removeCake(id);
                              cakeDatabase.reBuildCakeList();
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: ListTile(
                              title: Text(cakeDatabase.cakeNameList[index]),
                              tileColor: Colors.grey.shade300,
                              trailing: Switch(
                                  value: cakeDatabase.cakeDisplay[
                                      cakeDatabase.cakeNameList[index]]!,
                                  onChanged: (value) {
                                    _toggleSwitch(cakeDatabase, index, value);
                                  }),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            const Flexible(
              flex: 1,
              child: CakeAddSetting(),
            ),
          ],
        );
      },
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
