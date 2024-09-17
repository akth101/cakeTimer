
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'BreadDataBase.dart';

class BreadAddSetting extends StatefulWidget {
  final String kind;

  const BreadAddSetting({super.key, required this.kind});

  @override
  State<BreadAddSetting> createState() => _BreadAddSettingState();
}

class _BreadAddSettingState extends State<BreadAddSetting> {
  final _textEditingController = TextEditingController();

  @override
  void dispose() {
    // TextEditingController 해제
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        // listen: false로 BreadDataBase 객체를 가져옴
        final breadDB = Provider.of<BreadDataBase>(context);

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(hintText: '빵 이름 입력'),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();

                  // bread 이름 저장
                  String id = const Uuid().v4();
                  await prefs.setString('${widget.kind}Name_$id', _textEditingController.text);
                  _textEditingController.clear();

                  // bread 표시 상태 저장
                  await prefs.setInt('${widget.kind}DisplayOnList_$id', 1);

                  // 오늘 날짜 저장
                  DateTime date = DateTime.now();
                  String formattedDate = DateFormat('yy/MM/dd').format(date);
                  await prefs.setString('${widget.kind}Date_$id', formattedDate);

                  // breadDB 업데이트
                  breadDB.buildBreadDB();
                },
                child: const Text('저장'),
              ),
            ],
          ),
        );
      },
    );
  }
}
