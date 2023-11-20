
import 'package:flutter/material.dart';
import 'package:timer/pieceCake_1.dart';
import 'package:timer/wholeCake.dart';

class SideBar extends StatefulWidget {
  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      color: Colors.red[300],
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.home, color: Colors.white),
            // title: const Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => wholeCake()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            // title: const Text('Settings', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => pieceCake_1()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.contacts, color: Colors.white),
            // title: const Text('Contacts', style: TextStyle(color: Colors.white)),
            onTap: () {
              // 연락처로 이동하는 로직 추가
            },
          ),
        ],
      ),
    );
  }
}
