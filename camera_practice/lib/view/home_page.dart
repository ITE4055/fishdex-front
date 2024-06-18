import 'package:camera/camera.dart';
import 'package:fishdex/view/sidebar/account_page.dart';
import 'package:fishdex/view/sidebar/badge_page.dart';
import 'package:fishdex/view/upload/camera_page.dart';
import 'package:fishdex/view/upload/gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'encyclopedia_page.dart';
import 'dart:io';

import 'login/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  String _username = '';
  String _mainTitle = '칭호를 등록해주세요';
  String _mainBadgeImagePath = 'lib/icons/fishing.png';

  @override
  void initState() {
    super.initState();
    print('initState 호출됨');
    getUserData();
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
      _mainTitle = prefs.getString('mainTitle') ?? '';
      _mainBadgeImagePath = prefs.getString('mainBadge') ?? '';
    });
    print(_username);
    print(_mainTitle);
    print(_mainBadgeImagePath);
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF98BAD5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: const Text(
          'Fishdex', // 텍스트 내용
          style: TextStyle(
            fontSize: 30, // 폰트 크기 설정
            fontFamily: 'Roboto', // 사용할 폰트 설정
            fontWeight: FontWeight.bold, // 폰트 굵기 설정
            fontStyle: FontStyle.italic, // 폰트 스타일 설정
            color: Colors.white, // 텍스트 색상 설정
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color(0xFFC6D3E3),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),

              Card(
                color: Color(0xffffffff),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage('$_mainBadgeImagePath'), // 뱃지 이미지
                      ),
                      SizedBox(height: 10),
                      Text(
                        '$_mainTitle',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.yellow),
                      ),
                      Text(
                        '$_username',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),

              Spacer(),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await availableCameras().then((value) => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff98bad5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      icon: Icon(
                        Icons.camera_alt,
                        size: 30,
                        color: Colors.white,
                      ),
                      label: Text(
                        '카메라로 등록하기',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Gallery()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff98bad5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      icon: Icon(
                        Icons.photo,
                        size: 30,
                        color: Colors.white,
                      ),
                      label: Text(
                        '앨범에서 등록하기',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),

    );
  }
}



// black sea sprat - 흑해 청어
// gilt-head bream - 도미
// horse mackerel - 전갱이
// red mullet - 불은 숭어
// red sea bream - 참돔
// sea bass - 농어(바닷고기)
// shrimp - 새우
// striped red mullet - 줄무늬 붉은돔
// trout - 송어
