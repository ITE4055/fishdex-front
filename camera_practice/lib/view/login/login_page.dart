import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';
import 'kakao_login.dart';
import 'main_view_model.dart';
import 'package:http/http.dart' as http;


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<String?> loginUser() async {
    try{
      User user = await UserApi.instance.me();
      final response = await http.post(
        Uri.parse('http://218.39.215.36:3000/login'),
        body:{
          'username': user.kakaoAccount?.profile?.nickname,
          'usercode': user.id.toString(),
        },

      );
      print('리스폰스');
      print(response.body);

      if (response.statusCode == 200){
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String token = responseData['token'];

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String un = user.kakaoAccount?.profile?.nickname ?? '';
        prefs.setString('token', token);
        prefs.setString('username', un);
        prefs.setString('usercode', user.id.toString());
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomePage()));

        return token;

      }

      else{
        throw Exception('로그인 실패');
      }
    }
    catch(error){
      print(error);
    }
    return null;
  }


  Future<void> signInWithKakao() async {
    // print(await KakaoSdk.origin);

    // 카카오 로그인 구현 예제

    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomePage()));

        // loginUser();
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => HomePage()));
          // loginUser();
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomePage()));
        loginUser();
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'fishdex', // 텍스트 내용
                  style: TextStyle(
                    fontSize: 40, // 폰트 크기 설정
                    fontFamily: 'Roboto', // 사용할 폰트 설정
                    fontWeight: FontWeight.bold, // 폰트 굵기 설정
                    fontStyle: FontStyle.italic, // 폰트 스타일 설정
                    color: Colors.black, // 텍스트 색상 설정
                  ),
                ),
                Container(
                  width: 130, // 이미지의 너비를 200으로 설정
                  height: 130, // 이미지의 높이를 200으로 설정
                  child: Image.asset(
                    'lib/icons/fishing.png', // 이미지 경로
                    fit: BoxFit.cover, // 이미지를 화면에 맞게 늘리고 자르기
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  '당신만의 물고기 도감을 만들어보세요!', // 텍스트 내용
                  style: TextStyle(
                    fontSize: 18, // 폰트 크기 설정
                    fontFamily: 'Roboto', // 사용할 폰트 설정
                    fontWeight: FontWeight.bold, // 폰트 굵기 설정
                    // fontStyle: FontStyle.italic, // 폰트 스타일 설정
                    color: Colors.black54, // 텍스트 색상 설정
                  ),
                ),
                SizedBox(height: 20.0),
                SizedBox(
                  child: GestureDetector(
                      onTap: () async {
                        // await viewModel.login();
                        // setState(() {});
                        signInWithKakao();

                      },
                      child: Image.asset(
                      'lib/icons/kakao_login_medium_wide.png'
                      )
                  ),
                ),

                // SizedBox(height:15),
                // SizedBox(
                //   width: 200,
                //   child: ElevatedButton(
                //     onPressed: () async {
                //       await viewModel.logout();
                //       setState(() {});
                //       },
                //     child: Text('LOGOUT', style: TextStyle(color: Colors.lightBlueAccent)),
                //   ),
                // ),
                // SizedBox(height:15),
                // SizedBox(
                //   width: 200,
                //   child: ElevatedButton(
                //     onPressed: () async {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => HomePage()),
                //       );
                //     }, child: Text('Guest', style: TextStyle(color: Colors.lightBlueAccent)),
                //   ),
                // ),
              ]
          ),
        ),
      ),
    );
  }
}

// void user_log(int user_id, String? nickname) async{
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   if(nickname != null) {
//     prefs.setString(user_id.toString(), nickname);
//   }
//   String? value = prefs.getString(user_id.toString());
//   print(value);
// }

void getuser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, dynamic> allPrefs = {for (var key in prefs.getKeys()) key: prefs.get(key)};

  print(allPrefs);
}

