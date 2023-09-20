import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' as foundation;
import "timer.dart";
import 'package:permission_handler/permission_handler.dart';



class displayAndClickImage extends StatelessWidget {

  Future<void> _recognizeOS(BuildContext context) async {
  // 식별한 운영체제에 따라 접근 권한 요청
    if (foundation.defaultTargetPlatform == TargetPlatform.android ||
        foundation.defaultTargetPlatform == TargetPlatform.iOS) {
        await _handleMobileImageAccess(context);
        }
    else if (foundation.defaultTargetPlatform == TargetPlatform.windows ||
        foundation.defaultTargetPlatform == TargetPlatform.linux ||
        foundation.defaultTargetPlatform == TargetPlatform.macOS) {
      // 데스크톱인 경우
      await _handleDesktopImageAccess(context);
    }
  }

  Future<void> _handleMobileImageAccess(BuildContext context) async {
    final imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // 선택한 이미지를 화면에 표시
      _showImage(context, image.path);
    } else {
      // 이미지 선택이 취소된 경우
      print('Image selection canceled.');
    }
  }

  Future<void> _handleDesktopImageAccess(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.count == 1) {
      // 선택한 이미지를 화면에 표시
      _showImage(context, result.files.single.path);
    } else {
      // 이미지 선택이 취소된 경우
      print('Image selection canceled.');
    }
  }


  Future<void> _requestImagePermission() async {
  // TODO: 사진첩 접근 권한 요청
  var status = await Permission.photos.request();

  if (status.isGranted) {
  print('Photo access permission granted.');
  } else {
  print('Photo access permission denied.');
  }
  }

  Future<String?> _pickImage() async {
  final imagePicker = ImagePicker();
  final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
  return image?.path;
  }

  void _detectClicks(String? imagePath) {
  // TODO: 클릭 정보 감지
  // 이미지에 대한 클릭 정보를 감지하고, startTimers와 resetTimers 함수를 호출할 수 있습니다.
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: Text('Image Access and Display'),
  ),
  body: Center(
  child: ElevatedButton(
  onPressed: () async {
  await _accessAndDisplayImage(context);
  },
  child: Text('Access and Display Image'),
  ),
  ),
  );
  }
  }
