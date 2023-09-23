import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class cakeTimer extends StatefulWidget {
  const cakeTimer({super.key});

  @override
  _cakeTimerState createState() => _cakeTimerState();
}

class _cakeTimerState extends State<cakeTimer> {
  String startTime = ''; //해동 시작 시간
  String elapsedTime = ''; //해동 경과 시간
  String remainingTime = ''; //해동 완료까지 남은 시간
  Timer? currentTimer;
  Timer? sixHoursLaterTimer;


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
          '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString()
          .padLeft(2, '0')}';

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
          '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString()
          .padLeft(2, '0')}';

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

  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  @override
  //해야 될 것들
  //사진이 1번 눌리면 startTimers 실행
  //사진이 이미 1번 눌린 상태에서 1번 더 눌리면 resetTimers 실행
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    return Center(
      child: SingleChildScrollView(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           _photoArea(screenWidth, screenHeight),
           SizedBox(height : screenWidth / 50),
           _imageButton(),
           SizedBox(height : screenWidth / 50),
           Text(
             '해동 완료까지 남은 시간 : $remainingTime',
             style: const TextStyle(fontSize: 18),
           ),
         ],
        ),
      ),
    );
  }

  int isPhotoTouched = 0;

  Widget _photoArea(double screenWidth, double screenHeight) {
    double imageWidth = (screenWidth / 3 - screenWidth * 0.01) / 2;
    double imageHeight = (screenHeight / 2 - screenWidth * 0.01) / 2;

    return _image != null
          ? GestureDetector(
                onTap: () {
                  setState(() {
                      if (isPhotoTouched == 0) {
                      startTimers();
                      isPhotoTouched = 1;
                      } else if (isPhotoTouched == 1) {
                      resetTimers();
                     isPhotoTouched = 0;
                 }
               });
              },
              child: Container(
                 width: imageWidth,
                height: imageHeight,
                child: Image.file(File(_image!.path)),
            ))
            : GestureDetector(
                onTap: () {
                  setState(() {
                    getImage(ImageSource.camera);
                  });
                },
               child: Container(
                 width: imageWidth,
                 height: imageHeight,
                 color: Colors.grey,
        ));
  }

  // Container(
  // width: imageWidth,
  // height: imageHeight,
  // color: Colors.grey,
  // );


  Widget _imageButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.camera); //getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
          },
          child: Text("카메라"),
        ),
        SizedBox(width: 30),
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
          },
          child: Text("갤러리"),
        ),
      ],
    );
  }
}