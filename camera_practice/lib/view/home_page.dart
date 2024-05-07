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
  // final viewModel = MainViewModel(KakaoTalkLogin());
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _username = '';
  String _mainTitle = '';
  String _mainBadgeImagePath = 'lib/icons/fishing.png';

  @override
  void initState() {
    super.initState();
    print('initState 호출됨');
    getUserData();
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? mainTitle = prefs.getString('mainTitle');
    String? mainBadge = prefs.getString('mainBadge');
    if (username != null) {
      setState(() {
        _username = username;
        _mainTitle = mainTitle!;
        _mainBadgeImagePath = mainBadge!;
      });
    }
    print(username);
    print(mainTitle);
    print(mainBadge);
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          'fishdex', // 텍스트 내용
          style: TextStyle(
            fontSize: 30, // 폰트 크기 설정
            fontFamily: 'Roboto', // 사용할 폰트 설정
            fontWeight: FontWeight.bold, // 폰트 굵기 설정
            fontStyle: FontStyle.italic, // 폰트 스타일 설정
            color: Colors.black, // 텍스트 색상 설정
          ),
        ),
        centerTitle: true,

        // leading: IconButton(
        //   icon: Icon(Icons.person),
        //   onPressed: () {
        //     _scaffoldKey.currentState?.openDrawer();
        //   },
        // ),

      ),
      // key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(

          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('$_username'),
              accountEmail: null,
            ),
            ListTile(
              leading: Icon(Icons.album),
              title: Text('뱃지'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BadgePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('계정 설정'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountPage()),
                );
              },
            ),

          ],
        ),
      ),


      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$_mainTitle', // 텍스트 내용
                style: TextStyle(
                  fontSize: 24, // 폰트 크기 설정
                  fontFamily: 'Roboto', // 사용할 폰트 설정
                  fontWeight: FontWeight.bold, // 폰트 굵기 설정
                  // fontStyle: FontStyle.italic, // 폰트 스타일 설정
                  color: Colors.black54, // 텍스트 색상 설정
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                width: 150, // 이미지의 너비를 200으로 설정
                height: 150, // 이미지의 높이를 200으로 설정
                child: Image.asset(
                  '$_mainBadgeImagePath', // 이미지 경로
                  fit: BoxFit.cover, // 이미지를 화면에 맞게 늘리고 자르기
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                '$_username님 반갑습니다', // 텍스트 내용
                style: TextStyle(
                  fontSize: 30, // 폰트 크기 설정
                  fontFamily: 'Roboto', // 사용할 폰트 설정
                  fontWeight: FontWeight.bold, // 폰트 굵기 설정
                  // fontStyle: FontStyle.italic, // 폰트 스타일 설정
                  color: Colors.black54, // 텍스트 색상 설정
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 120,
                    child: ElevatedButton(
                      onPressed: () async {
                        await availableCameras().then((value) => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0))),
                      child: Transform.scale(
                        scale: 0.5,
                        child: Image.asset(
                          'lib/icons/camera.png',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  SizedBox(
                    width: 150,
                    height: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Gallery()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0))),
                      child: Transform.scale(
                        scale: 0.5,
                        child: Image.asset(
                          'lib/icons/gallery.png',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),



                ]
              ),
              const SizedBox(height: 20.0), // Add space between the buttons

              SizedBox(
                width: 320,
                height: 120,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EncyclopediaPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Transform.scale(
                    scale: 0.7,
                    child: Image.asset(
                      'lib/icons/encyclopedia.png',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}


_openSite() async {
  final Uri url = Uri.parse('https://tpirates.com/%EC%8B%9C%EC%84%B8');
  if (!await launchUrl(url)){
    print("Can't open URL");
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


void _openGallery() async{
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  if (image != null){
    XFile(image.path);
  }
}
