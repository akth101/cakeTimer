

import 'package:flutter/material.dart';

import 'main.dart';


class wholeCakeList extends StatefulWidget {
  const wholeCakeList({super.key});

  @override
  State<wholeCakeList> createState() => _wholeCakeListState();
}

class _wholeCakeListState extends State<wholeCakeList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("홀케익 목록 설정"),
      ),
      body: Row(
        children: [
          TextButton(
            onPressed: () {
              print("pressed TextButton");
            }
            , child: Text(
              "홀케익 추가",
            ),
          ),
        ],
      ),
    );
  }
}

class showList extends StatefulWidget {
  const showList({super.key});

  @override
  State<showList> createState() => _showListState();
}

class _showListState extends State<showList> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class hideList extends StatefulWidget {
  const hideList({super.key});

  @override
  State<hideList> createState() => _hideListState();
}

class _hideListState extends State<hideList> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}