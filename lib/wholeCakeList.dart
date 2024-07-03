

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer/cakeAddSetting.dart';
import 'main.dart';


class wholeCakeList extends StatefulWidget {
  const wholeCakeList({super.key});

  @override
  State<wholeCakeList> createState() => _wholeCakeListState();
}

class _wholeCakeListState extends State<wholeCakeList> {



  Future<String?> findKeyId (String cakeName) async {
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

  void  removeCake (String? id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("cakename_$id");
    prefs.remove("displayonlist_$id");
    prefs.remove("isElapseCompleted_$id");
    prefs.remove("selectedHour_$id");
    prefs.remove("selectedMinute_$id");
    prefs.remove("imagePath_$id");
    return ;
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
          child: ListView.builder(
            itemCount: cakeDatabase.cakeNameList.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(cakeDatabase.cakeNameList[index]),
                onDismissed: (direction) async {
                  String? id = await findKeyId(cakeDatabase.cakeNameList[index]);
                  removeCake(id);
                  cakeDatabase.reBuildCakeList();
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
                  title: Text(cakeDatabase.cakeNameList[index]),
                  tileColor: Colors.grey.shade300,
                  trailing: Switch (
                    value: cakeDatabase.cakeDisplay[cakeDatabase.cakeNameList[index]]!,
                    onChanged: (value) {
                      _toggleSwitch(cakeDatabase, index, value);
                    print("hello");
                     print(cakeDatabase.cakeDisplay[cakeDatabase.cakeNameList[index]]); 
                      }
                    ),
                  ),
              );
              }
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


}