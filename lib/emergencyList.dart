import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cakeDataBase.dart';

class EmergencyList extends StatelessWidget {
  const EmergencyList({super.key});

  Future<String?> findKeyId(String cakeName) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    String? id;
    for (String key in keys) {
      if (key.startsWith("cakename_")) {
        String? cakeNameCompare = prefs.getString(key);
        if (cakeName == cakeNameCompare) {
          id = key.split('_').last;
          break;
        }
      }
    }
    String? result = prefs.getString("startTime_$id");
    return (result);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CakeDataBase>(builder: (context, CakeDataBase, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "임시 리스트",
          ),
        ),
        body: ListView.builder(
          itemCount: CakeDataBase.cakeNameList.length,
          itemBuilder: (context, index) {
            final cakeName = CakeDataBase.cakeNameList[index];
            return FutureBuilder<String?>(
              future: findKeyId(cakeName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(
                    title: Text('Loading...'),
                    subtitle: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return ListTile(
                    title: Text(cakeName),
                    subtitle: Text('Error: ${snapshot.error}'),
                  );
                  // } else if (snapshot.hasData) {
                  //   return ListTile(
                  //     title: Text(cakeName),
                  //     subtitle: Text(snapshot.data ?? 'No data'),
                  //   );
                } else if (CakeDataBase
                        .cakeDisplay[CakeDataBase.cakeNameList[index]] ==
                    true) {
                  return ListTile(
                    title: Text(cakeName),
                    subtitle: Text(snapshot.data ?? '진열되지 않음'),
                  );
                } else {
                  return ListTile(
                    title: Text(cakeName),
                    subtitle: const Text("숨김 처리됨"),
                  );
                }
              },
            );
          },
        ),
      );
    });
  }
}
