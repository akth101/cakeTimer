import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'cakeDataBase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class CakeAddSetting extends StatefulWidget {
  const CakeAddSetting({super.key});

  @override
  State<CakeAddSetting> createState() => _CakeAddSettingState();
}

class _CakeAddSettingState extends State<CakeAddSetting> {
  final _textEditingController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  XFile? _pickedFile;
  CroppedFile? _croppedFile;
  String? imagePath;

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
          imagePath = _croppedFile?.path;
        });
      }
    }
  }

  Widget showCroppedOrGreyContainer(double imageWidth, double imageHeight) {
    if (_croppedFile != null) {
      return SizedBox(
        width: imageWidth,
        height: imageHeight,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.file(File(_croppedFile!.path))),
      );
    }
    return Container(
      width: imageWidth,
      height: imageHeight,
      color: Colors.grey,
    );
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

  Widget _photoArea(double screenWidth, double screenHeight) {
    double imageWidth = (screenWidth / 3 - screenWidth * 0.01) / 2;
    double imageHeight = (screenHeight / 2 - screenWidth * 0.01) / 2;
    return GestureDetector(
      onTap: () {
        setState(() {
          getImage(ImageSource.gallery);
        });
      },
      child: showCroppedOrGreyContainer(imageWidth, imageHeight),
    );
  }

  void _showWarningPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const Text('케익 이름과 사진을 모두 입력해주세요.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CakeDataBase>(
      builder: (context, CakeDataBase, child) {
        MediaQueryData mediaQueryData = MediaQuery.of(context);
        double screenWidth = mediaQueryData.size.width;
        double screenHeight = mediaQueryData.size.height;
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(hintText: '홀케익 이름 입력'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _photoArea(screenWidth, screenHeight),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                //새로운 케익 저장 버튼
                onPressed: () async {
                  if (_textEditingController.text == '' || imagePath == null) {
                    _showWarningPopUp();
                  } else {
                    final prefs = await SharedPreferences.getInstance();
                    String id = const Uuid().v4();
                    await prefs.setString(
                        'cakename_$id', _textEditingController.text);
                    _textEditingController.clear();
                    await prefs.setInt('displayonlist_$id', 1);
                    await prefs.setInt('isElapseCompleted_$id', 0);
                    await prefs.setInt('selectedHour_$id', 6);
                    await prefs.setInt('selectedMinute_$id', 0);
                    await prefs.setString('imagePath_$id', imagePath!);
                    setState(() {
                      _croppedFile = null;
                      imagePath = null;
                    });
                  }
                  CakeDataBase.reBuildCakeList();
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
