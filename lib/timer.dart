import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cakeIndividualSetting.dart';
// import 'globals.dart' as globals;



class TimerFunction extends StatefulWidget {

  final int value;
  //value3를 TimerFunctionState에서 사용하려면 ${widget.value3} 이렇게 사용해야 함.

  const TimerFunction({Key? key, required this.value}) : super(key: key);

  @override
  TimerFunctionState createState() => TimerFunctionState();
}

class TimerFunctionState extends State<TimerFunction> {

  @override
  void initState() {
    super.initState();
    _loadImage();
    _loadstartTime();
    _loadisElapseCompleted();
  }
  //////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////Timer function//////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////

  String? startTime = ''; //해동 시작 시간
  String elapsedTime = ''; //해동 경과 시간
  String remainingTime = ''; //해동 완료까지 남은 시간
  Timer? currentTimer; //타이머
  Timer? sixHoursLaterTimer; //타이머

  int isPhotoTouched = 0;
  int isElapseCompleted = 0;

  Future<void> _saveStartTime(String? startTime) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('startTime-${widget.value}', startTime!);
  }

  Future<void> _loadFromShared() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      startTime = _prefs.getString('startTime-${widget.value}')! ?? null;
    });
  }

  Future<void> _saveisElapseCompleted(int num) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setInt('isElapseCompleted-${widget.value}', num);
    setState(() {
      isElapseCompleted = num;
    });
  }

  Future<void> _loadisElapseCompleted() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      isElapseCompleted = _prefs.getInt('isElapseCompleted-${widget.value}')!;
    });
  }




  void startTimers() {

    //일단 해동 완료가 표시되지 않도록 만들어놓고 시작.
    _saveisElapseCompleted(0);

    // 현재 시각을 얻어와 startTime 변수에 저장.
    DateTime now = DateTime.now();
    setState(() {
      startTime = now.toString();
    });

    _saveStartTime(startTime);

    //startTime 안에 저장된 현재 시각을 sharedpreference에 업로드
    // final SharedPreferences _prefs = await SharedPreferences.getInstance();
    // await _prefs.setString('startTime-${widget.value}', startTime!);


    //startTime에 저장되어 있는 시간을 출력하기 좋은 string 형태로 parse
    DateTime startDateTime = DateTime.parse(startTime!);

    // 이전에 활성화된 타이머를 취소
    currentTimer?.cancel();
    sixHoursLaterTimer?.cancel();

    // 1초마다 '해동 경과 시간'(현재 시각 - 시작 시각)을 표시하는 타이머를 시작
    // currentTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   DateTime currentDateTime = DateTime.now();
    //   Duration difference = currentDateTime.difference(now);
    //
    //   //시간, 분, 초별 현재 시각과 시작 시각의 차이를 계산
    //   int hours = difference.inHours;
    //   int minutes = (difference.inMinutes % 60);
    //   int seconds = (difference.inSeconds % 60);
    //
    //   //시간 차이를 HH:mm:ss 형태로 포맷팅
    //   String formattedDifference =
    //       '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    //
    //   setState(() {
    //     elapsedTime = formattedDifference;
    //   });
    // });

    // 1초마다 '해동 완료까지 남은 시간'을 표시하는 타이머를 시작
    sixHoursLaterTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      DateTime currentDateTime = DateTime.now();
      DateTime sixHoursLater = startDateTime.add(const Duration(seconds: 10));
      Duration timeDifference = sixHoursLater.difference(currentDateTime);

      // 시간, 분, 초별 해동 시작 시각과 6시간 후의 시각 차이를 계산
      int hours = timeDifference.inHours;
      int minutes = (timeDifference.inMinutes % 60);
      int seconds = (timeDifference.inSeconds % 60);

      // 시간 차이를 HH:mm:ss 형식으로 포맷팅
      String formattedTimeDifference =
          '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

      setState(() {
        if (remainingTime != '0:00:00') {
          remainingTime = formattedTimeDifference;
        }
        else {
          currentTimer?.cancel();
          sixHoursLaterTimer?.cancel();
        }
      });
    });
  }

  void resetTimers() {
    // '판매 완료' 버튼을 누르면 현재 활성화된 타이머를 모두 취소하고 시간 정보를 초기화
    currentTimer?.cancel();
    sixHoursLaterTimer?.cancel();
    setState(() {
      startTime = '';
      elapsedTime = '';
      remainingTime = '';
    });
  }

  Future<void> _loadstartTime() async {

    //_loadstartTime이 실행되고 있는 상태에서 터치이벤트가 들어오면 showAlertPopUp을 실행시키기 위함
    isPhotoTouched = 1;

    //startTime 불러오기
    _loadFromShared();

    //startTime 불러오기
    // final SharedPreferences _prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   startTime = _prefs.getString('startTime-${widget.value}')! ?? null;
    // });

    //startTime이 성공적으로 불러와졌고 isElpaseCompleted != 0이 아닐 경우에만 타이머를 시작
    if (startTime != null && isElapseCompleted != 1) {
      DateTime startDateTime = DateTime.parse(startTime!);

      // 이전에 활성화된 타이머를 취소
      currentTimer?.cancel();
      sixHoursLaterTimer?.cancel();

      // 1초마다 '해동 완료까지 남은 시간'을 표시하는 타이머를 시작
      sixHoursLaterTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        DateTime currentDateTime = DateTime.now();
        DateTime sixHoursLater = startDateTime.add(const Duration(seconds: 10));
        Duration timeDifference = sixHoursLater.difference(currentDateTime);

        // 시간, 분, 초별 해동 시작 시각과 6시간 후의 시각 차이를 계산
        int hours = timeDifference.inHours;
        int minutes = (timeDifference.inMinutes % 60);
        int seconds = (timeDifference.inSeconds % 60);

        // 시간 차이를 HH:mm:ss 형식으로 포맷팅
        String formattedTimeDifference =
            '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString()
            .padLeft(2, '0')}';

        setState(() {
          if (remainingTime != '0:00:00') {
            remainingTime = formattedTimeDifference;
          }
          else {
            currentTimer?.cancel();
            sixHoursLaterTimer?.cancel();
          }
        });
      });
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////Image function//////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////

  XFile? _pickedFile;
  XFile? _savedFile;
  CroppedFile? _croppedFile;
  late SharedPreferences _prefs;
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화


    Future<void> _saveImagePath(String? imagePath) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('imagePath${widget.value}', imagePath!);
  }

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
                  return IndividualSetting(value: widget.value);
                }));
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
 

  Widget _imageButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.camera); //getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
          },
          child: const Text("camera"),
        ),
        const SizedBox(width: 30),
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
          },
          child: const Text("gallery"),
        ),
      ],
    );
  }

  //////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////Safety function/////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////

  String? cakeName;

  Future<void> _loadCakeName() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      cakeName = _prefs.getString('cakename-${widget.value}');
    });
  }

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
                    _saveisElapseCompleted(0);
                    Navigator.of(context).pop();
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    isPhotoTouched = 1;
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close"),
                )
              ]
          );
        }
    );
  }

  Text showRemainingTime() {
    //남은 시간이 0이라는 말은 해동이 완료되었고 그에 따라 더 이상 타이머를 돌릴 필요가 없다는 것.
    if (remainingTime == '0:00:00') {
      _saveisElapseCompleted(1);
      currentTimer?.cancel();
      sixHoursLaterTimer?.cancel();
    }
    return (isElapseCompleted == 1)
            ? Text('해동 완료!',
              style: const TextStyle(fontSize: 20),
    )
            : Text('남은 시간 : $remainingTime',
               style: const TextStyle(fontSize: 20),
    );
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
          SizedBox(height: screenWidth / 80),
          _photoArea(screenWidth, screenHeight),
          SizedBox(height: screenWidth / 60),
          showRemainingTime(),
        ],
      ),
    );
  }
}

