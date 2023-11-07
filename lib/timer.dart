import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cakeIndividualSetting.dart';
import 'dart:io';

class TimerFunction extends StatefulWidget {

  final int value;
  const TimerFunction({Key? key, required this.value}) : super(key: key);

  @override
  State<TimerFunction> createState() => _TimerFunctionState();
}

class _TimerFunctionState extends State<TimerFunction> {

  ///////////////////////////////////////////////////////////////////////
  /////////////////////////////////variables/////////////////////////////
  ///////////////////////////////////////////////////////////////////////

  //flag variables
  int isPhotoTouched = 0;
  int? isElapseCompleted = 0;
  int isNeedToRecovered = 0;

  // time variables
  String? startTime = null;
  String? remainingTime;
  String? currentTimeString;
  String? laterTimeString;
  Timer? timeTimer;

  // image variables
  XFile? _pickedFile;
  XFile? _savedFile;
  CroppedFile? _croppedFile;

  //etc
  String? cakeName;

  //Instance
  late SharedPreferences _prefs;
  final ImagePicker picker = ImagePicker();

  //temp
  late  bool isCurrentPassedTheTargetTime = true;
  late int isCurrentArrivedAtTargetTime = 0;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  int isStartTimeLoaded = 0;

  ////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////load from shared-preference/////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////

  Future<String?> _loadImagePath() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('imagePath${widget.value}');
  }

  Future<void> _loadImage() async {
    String? imagePath = await _loadImagePath();
    if (imagePath != null) {
      setState(() {
        _savedFile = XFile(imagePath);
      });
    }
  }

  Future<void> _loadIsElapseCompleted() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      isElapseCompleted = _prefs.getInt('isElapseCompleted-${widget.value}');
    });
  }

  Future<void> _loadStartTime() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      startTime = _prefs.getString('startTime-${widget.value}');
    });
  }

  Future<void> _loadCakeName() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      cakeName = _prefs.getString('cakename-${widget.value}');
    });
  }


  Future<void> _loadPreviousTimerState() async {

    _prefs = await SharedPreferences.getInstance();
    setState(() {
    startTime = _prefs.getString('startTime-${widget.value}');
    });

    if (startTime != null) {
      isStartTimeLoaded = 1;
    }

    if (isStartTimeLoaded == 1) {
      if (isElapseCompleted == 0) {
          isPhotoTouched = 1;
          timer();
        }
      if (isElapseCompleted == 1) {
        isPhotoTouched = 1;
      }
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////save to shared-preference/////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////

  Future<void> _saveImagePath(String? imagePath) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('imagePath${widget.value}', imagePath!);
  }

  Future<void> _saveIsElapseCompleted(int num) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setInt('isElapseCompleted-${widget.value}', num);
    setState(() {
      isElapseCompleted = num;
    });
  }

  Future<void> _saveStartTime(String? startTime) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('startTime-${widget.value}', startTime!);
  }


  ////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////initState//////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    _loadImage();
    _loadIsElapseCompleted();
    _loadPreviousTimerState();
  }

  ////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////Timers///////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////

  //startTime이 null이 아니라는 전제 하에 실행되는 함수
  void timer() {

    //startTime에 저장되어 있는 시간을 출력하기 좋은 string 형태로 parse
    DateTime startDateTime = DateTime.parse(startTime!);

    //이전에 활성화된 타이머를 취소
    timeTimer?.cancel();


    // 1초마다 '해동 완료까지 남은 시간'을 표시하는 타이머를 시작
    timeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      DateTime currentDateTime = DateTime.now();
      DateTime laterDateTime = startDateTime.add(const Duration(minutes: 10));
      Duration timeDifference = laterDateTime.difference(currentDateTime);

      // 시간, 분, 초별 해동 시작 시각과 6시간 후의 시각 차이를 계산
      hours = timeDifference.inHours;
      minutes = (timeDifference.inMinutes % 60);
      seconds = (timeDifference.inSeconds % 60);

      // 시간 차이를 HH:mm:ss 형식으로 포맷팅
      String formattedTimeDifference =
          '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';


      // final bool isCurrentPassedTheTargetTime;
      // int isCurrentArrivedAtTargetTime;

      //current 시간대가 later 시간대보다 뒤에 있는가?

      currentTimeString = currentDateTime.toString();
      laterTimeString = laterDateTime.toString();
      isCurrentPassedTheTargetTime = DateTime.parse(currentTimeString!).isAfter(DateTime.parse(laterTimeString!));
      //current 시간대와 later 시간대가 일치하는가?
      isCurrentArrivedAtTargetTime = currentDateTime.compareTo(laterDateTime);

      setState(() {
        if (isCurrentPassedTheTargetTime == true || isCurrentArrivedAtTargetTime == 0) {
          _saveIsElapseCompleted(1);
          remainingTime = '';
          timeTimer?.cancel();
        }
        else {
            remainingTime = formattedTimeDifference;
        }
      });
    });

  }


  void startTimers() {

    //일단 해동 완료가 표시되지 않도록 예방 조치
    _saveIsElapseCompleted(0);

    //현재 시각을 얻어와 startTime 변수에 저장
    DateTime now = DateTime.now();
    setState(() {
      startTime = now.toString();
      // startTime = DateFormat('yyyy-MM-dd kk:mm').format(now);
    });

    //startTime에 저장된 시간을 shared에 업로드
    _saveStartTime(startTime);

    //타이머 시작
    timer();
  }

  void resetTimers() {

    //활성화된 타이머 모두 취소
    timeTimer?.cancel();

    //시간 관련 변수들 빈 문자열로 초기화
    setState(() {
      startTime = '';
      remainingTime = '';
    });
  }

  void recoveryTimers() {
    if (isNeedToRecovered == 1) {
      _loadStartTime();
      timer();
      isNeedToRecovered = 0;
    }
  }

  Text showRemainingTime() {
    return (isElapseCompleted == 1)
        ? const Text('해동 완료!',
      style: TextStyle(fontSize: 20),
    )
        : Text('remainingTime : $remainingTime',
      style: const TextStyle(fontSize: 20),
    );
  }


  ////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////Images///////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////


  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
            const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
          String? imagePath = _croppedFile != null ? _croppedFile!.path : null;  //이거 삼항 연산자임
          _saveImagePath(imagePath);
        });
      }
    }
  }

  Widget croppedOrSaved(double imageWidth, double imageHeight) {
    if (_croppedFile != null && _savedFile != null) {
      return Container(
        width: imageWidth,
        height: imageHeight,
        child: Image.file(File(_croppedFile!.path)),
      );
    }
    if (_croppedFile != null && _savedFile == null) {
      return Container(
        width: imageWidth,
        height: imageHeight,
        child: Image.file(File(_croppedFile!.path)),
      );
    }
    return Container(
      width: imageWidth,
      height: imageHeight,
      child: Image.file(File(_savedFile!.path)),
    );
  }


  Widget _photoArea(double screenWidth, double screenHeight) {
    double imageWidth = (screenWidth / 3 - screenWidth * 0.01) / 2;
    double imageHeight = (screenHeight / 2 - screenWidth * 0.01) / 2;

    return (_croppedFile != null || _savedFile != null)
        ? GestureDetector(
      onTap: () {
        setState(() {
          if (isPhotoTouched == 0) {
            startTimers();
            isPhotoTouched = 1;
          } else if (isPhotoTouched == 1) {
            showAlertPopUp();
            isPhotoTouched = 0;
          }
        });
      },
      child: croppedOrSaved(imageWidth, imageHeight),
      onDoubleTap: () {
        setState(() {
          showDialog(
              context: context,
              builder: ((BuildContext context) {
                return IndividualSetting(value: widget.value, saveIsNeedToRecovered: saveIsNeedToRecovered);
              }));
          recoveryTimers();
        }); //setState
      },  //ondoubletap
      onLongPress: () {
        setState(() {
          getImage(ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
        });
      }
      ,
    )
        : GestureDetector(
        onTap: () {
          setState(() {
            getImage(ImageSource.gallery);
          });
        },
        child: Container(
          width: imageWidth,
          height: imageHeight,
          color: Colors.grey,
        ));
  }

  ////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////Safety///////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////

  void showAlertPopUp() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("잠깐!"),
              content: Container(
                  child: FutureBuilder<void>(
                      future: _loadCakeName(),
                      builder: (context, snapshot) {
                        return Text('정말 ${cakeName}을(를) 판매 완료 처리하시겠습니까?');
                      }
                  )
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    resetTimers();
                    _saveIsElapseCompleted(0);
                    Navigator.of(context).pop();
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close"),
                )
              ]
          );
        }
    );
  }

  // Future<void> _loadStartTime() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     startTime = _prefs.getString('startTime-${widget.value}');
  //   });
  // }

  //예비 보험용
  // saveIsNeedToRecovered(int value) => setState(() {
  //   isNeedToRecovered = value;
  //   if (isNeedToRecovered == 1) {
  //     _loadStartTime();
  //     timer();
  //     isNeedToRecovered = 0;
  //   }
  // });

  Future<void> saveIsNeedToRecovered(int value) async {
    isNeedToRecovered = value;
    if (isNeedToRecovered == 1) {
        _prefs = await SharedPreferences.getInstance();
        setState(() {
          startTime = _prefs.getString('startTime-${widget.value}');
        });
        isPhotoTouched = 1;

      timer();
      isNeedToRecovered = 0;
    }
  }



  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    return Center(
      // child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: screenWidth / 90),
          _photoArea(screenWidth, screenHeight),
          SizedBox(height: screenWidth / 80),
          showRemainingTime(),
          SizedBox(height: screenWidth / 80),
          Text('start photo: ${startTime}, ${isPhotoTouched}'),
          Text('recover: ${isNeedToRecovered}'),
        ],
      ),
    );
  }
}

