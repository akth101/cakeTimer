

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';


class wholeCakeList extends StatefulWidget {
  const wholeCakeList({super.key});

  @override
  State<wholeCakeList> createState() => _wholeCakeListState();
}

class _wholeCakeListState extends State<wholeCakeList> {

  // Future<bool> cakeDisplayState async (String cakename) {

  //   final prefs = await SharedPreferences.getInstance();
  //   final keys = prefs.getKeys();

  //   for (String key in keys) {
  //     String? value = prefs.getString(key);
  //     if (value == cakename) {
  //       String? cakeKeyValue = key.split("-").last;
  //       for (String key in keys) {

  //       }

  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<CakeDataBase>(
  builder: (context, cakeDatabase, child) {
    return ListView.builder(
      itemCount: cakeDatabase.cakeNameList.length + 1,
      itemBuilder: (context, index) {
        if (index == cakeDatabase.cakeNameList.length) {
          return const ListTile(
            title: Text("추가"),
          );
        }
        else {
        return ListTile(
          title: Text(cakeDatabase.cakeNameList[index]),
          // trailing: Switch(
          //   value: cakeDisplayState(cakeDatabase, cakeDatabase.cakeNameList[index]),
          //   onChanged: ,
          // ),
          );
        }
      }
      );
   },
  );
  }


}