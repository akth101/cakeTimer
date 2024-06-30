

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

  @override
  Widget build(BuildContext context) {
    return Consumer<CakeDataBase>(
  builder: (context, cakeDatabase, child) {
    return ListView.builder(
      itemCount: cakeDatabase.cakeNameList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(cakeDatabase.cakeNameList[index]),
        );
      }
      );
   },
  );
  }

  // ListView cakeListview() {
  //   return ListView.builder(
  //     itemCount: _cakeList.length,
  //     itemBuilder: (context, index) {
  //       print("index: $index");
  //       // print("index: $index");
  //       // if (index == _cakeList.length) {
  //       //   return const ListTile(
  //       //     title: Text("추가"),
  //       //   );
  //       // }
  //       // else {
  //       return ListTile(
  //         title: Text(_cakeList[index]),
  //         // trailing: Switch(
  //         //   value: true,
  //         //   onChanged: (bool value) {
  //         //     value = false;
  //         //   },
  //         // ),
  //         );
  //       // }
  //     },
  //   );
  // }


}