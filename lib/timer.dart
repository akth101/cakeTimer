import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cakeIndividualSetting.dart';


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
  }

  //////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////Timer function//////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////

  String startTime = ''; //해동 시작 시간
  String elapsedTime = ''; //해동 경과 시간
  String remainingTime = ''; //해동 완료까지 남은 시간
  Timer? currentTimer; //타이머
  Timer? sixHoursLaterTimer; //타이머

  void startTimers() {
    // 현재 시각을 얻어와 startTime 변수에 저장.
    DateTime now = DateTime.now();
    setState(() {
      startTime = now.toString();
    });

    //startTime에 저장되어 있는 시간을 출력하기 좋은 string 형태로 parse
    DateTime startDateTime = DateTime.parse(startTime);

    // 이전에 활성화된 타이머를 취소
    currentTimer?.cancel();
    sixHoursLaterTimer?.cancel();

    // 1초마다 '해동 경과 시간'(현재 시각 - 시작 시각)을 표시하는 타이머를 시작
    currentTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      DateTime currentDateTime = DateTime.now();
      Duration difference = currentDateTime.difference(now);

      //시간, 분, 초별 현재 시각과 시작 시각의 차이를 계산
      int hours = difference.inHours;
      int minutes = (difference.inMinutes % 60);
      int seconds = (difference.inSeconds % 60);

      //시간 차이를 HH:mm:ss 형태로 포맷팅
      String formattedDifference =
          '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

      setState(() {
        elapsedTime = formattedDifference;
      });
    });

    // 1초마다 '해동 완료까지 남은 시간'을 표시하는 타이머를 시작
    sixHoursLaterTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      DateTime currentDateTime = DateTime.now();
      DateTime sixHoursLater = startDateTime.add(const Duration(hours: 6));
      Duration timeDifference = sixHoursLater.difference(currentDateTime);

      // 시간, 분, 초별 해동 시작 시각과 6시간 후의 시각 차이를 계산
      int hours = timeDifference.inHours;
      int minutes = (timeDifference.inMinutes % 60);
      int seconds = (timeDifference.inSeconds % 60);

      // 시간 차이를 HH:mm:ss 형식으로 포맷팅
      String formattedTimeDifference =
          '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

      setState(() {
        remainingTime = formattedTimeDifference;
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

  int isPhotoTouched = 0;

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
                showIndividualSetting(context, '케익 설정', 'content', widget.value);
              });
            },
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

  void showAlertPopUp() {
    showDialog(
        context: context,
        builder: (BuildContext con) {
          return AlertDialog(
              title: const Text("잠깐!"),
              content: Container(
                child: const Text(
                  "정말로 판매 완료 처리하시겠습니까?",
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    resetTimers();
                    Navigator.of(context).pop();
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Close"),
                )
              ]
          );
        }
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
          //SizedBox(height: screenWidth / 60),
          //_imageButton(),
          SizedBox(height: screenWidth / 60),
          Text(
            'remaining time : $remainingTime',
            style: const TextStyle(fontSize: 20),
          ),
          // Text(
          //   'value3: ${widget.value3}',
          //   style: const TextStyle(fontSize:15),
          // ),
        ],
      ),
    );
  }
}

