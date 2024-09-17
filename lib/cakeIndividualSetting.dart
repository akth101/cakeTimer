import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndividualSetting extends StatefulWidget {
  final String cakeKey;
  final void Function(int) saveIsNeedToRecovered;
  final void Function(int) fetchSoundSetting;
  final void Function(int, int) isSelectedTimeChanged;
  final Future<void> Function() loadPreviousTimerState;

  const IndividualSetting(
      {Key? key,
      required this.cakeKey,
      required this.saveIsNeedToRecovered,
      required this.fetchSoundSetting,
      required this.isSelectedTimeChanged,
      required this.loadPreviousTimerState})
      : super(key: key);

  @override
  State<IndividualSetting> createState() => _IndividualSettingState();
}

class _IndividualSettingState extends State<IndividualSetting> {
  final _textEditingController = TextEditingController();
  late SharedPreferences _prefs;
  int? soundSetting = 1;

  String? _selectedTime;
  int? _selectedHour = 0;
  int? _selectedMinute = 0;
  int _convertedHour = 0;
  int _convertedMinute = 0;

  ////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////save to shared-preference/////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////

  Future<void> _saveSoundSetting(int num) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setInt('soundSetting_${widget.cakeKey}', num);
    setState(() {
      soundSetting = num;
    });
  }

  Future<void> _saveSelectedTime(int hour, int minute) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setInt('selectedHour_${widget.cakeKey}', hour);
    await _prefs.setInt('selectedMinute_${widget.cakeKey}', minute);
  }

  ////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////load from shared-preference/////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////

  Future<void> _loadSoundSetting() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      soundSetting = _prefs.getInt('soundSetting_${widget.cakeKey}');
      //만약에 데이터 못받아오면 0으로 설정
      soundSetting ??= 0;
    });
  }

  Future<void> _loadSelectedTime() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedHour = _prefs.getInt('selectedHour_${widget.cakeKey}')!;
      _selectedMinute = _prefs.getInt('selectedMinute_${widget.cakeKey}')!;
      _convertedHour = _selectedHour ?? 1;
      _convertedMinute = _selectedMinute ?? 0;
    });
  }

  void regulateSoundSetting() {
    if (soundSetting == 0) {
      _saveSoundSetting(1);
      widget.fetchSoundSetting(1);
    } else if (soundSetting == 1) {
      _saveSoundSetting(0);
      widget.fetchSoundSetting(0);
    }
  }

  Future<void> pickTime() async {
    final TimeOfDay? result = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: _convertedHour, minute: _convertedMinute),
        builder: (context, childWidget) {
          return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: childWidget!);
        });
    if (result != null) {
      setState(() {
        _selectedTime = '${result.hour}:${result.minute}';
        _selectedHour = result.hour;
        _selectedMinute = result.minute;
        _convertedHour = _selectedHour ?? 1;
        _convertedMinute = _selectedMinute ?? 0;
        // print("pickTime");
        // print("convertedHour: $_convertedHour");
        // print("convertedMinute: $_convertedMinute");
      });
      _saveSelectedTime(_convertedHour, _convertedMinute);
      widget.isSelectedTimeChanged(_convertedHour, _convertedMinute);
    }
  }

  Future<void> receiveUserDefinedStartTime() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.purple,
            colorScheme: const ColorScheme.light(primary: Colors.purple),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: _convertedHour, minute: _convertedMinute),
        builder: (context, childWidget) {
          return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: childWidget!);
        });
    if (selectedDate != null && selectedTime != null) {
      final DateTime combinedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      String? startTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(combinedDateTime);
      print("startTime: $startTime");

      if (combinedDateTime.isAfter(DateTime.now())) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('경고'),
              content: const Text(
                  '현재 시각 이전으로 지정해주세요'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        _prefs = await SharedPreferences.getInstance();
        await _prefs.setString('startTime_${widget.cakeKey}', startTime);
        widget.loadPreviousTimerState();
      }
    }
  }

  //여기 고쳐야 되지 않나? super.initState를 위로??
  @override
  void initState() {
    _loadSoundSetting();
    _loadSelectedTime();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Widget dialogContent(
      BuildContext context, String title, String content, String cakeKey) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            //설정 제목
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 10.0), //여백
          // TextField(controller: _textEditingController), //케익 이름 입력창
          // const SizedBox(height: 10.0), //여백
          // ElevatedButton(
          //   //케익 이름 저장 버튼
          //   onPressed: () async {
          //     prefs = await SharedPreferences.getInstance();
          //     String id = const Uuid().v4();
          //     await prefs.setString('cakename_$id', _textEditingController.text);
          //     await prefs.setInt('displayonlist_$id', 1);
          //   },
          //   child: const Text('저장'),
          // ),
          IconButton(
            onPressed: () {
              regulateSoundSetting();
            },
            icon: Icon(soundSetting == 1
                ? Icons.notifications_active
                : Icons.notifications_active_outlined),
          ),
          const SizedBox(height: 10.0), //여백
          ElevatedButton(
              //복구 버튼
              onPressed: () {
                widget.saveIsNeedToRecovered(1);
              },
              child: const Text('직전 시각 복구')),
          const SizedBox(height: 20.0), //여백
          ElevatedButton(
            onPressed: () {
              pickTime();
            },
            child: const Text("타이머 시간 변경"),
          ),
          const SizedBox(height: 20.0), //여백
          ElevatedButton(
              onPressed: () {
                receiveUserDefinedStartTime();
              },
              child: const Text("시작 시각 변경")),
          const SizedBox(height: 20),
          ElevatedButton(
            //창 닫기 버튼
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context, '설정', 'content', widget.cakeKey),
    );
  }
}
