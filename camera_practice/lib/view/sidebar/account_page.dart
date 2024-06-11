import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/login_page.dart';


class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {


  Future<void> Logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('usercode');
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
            '마이페이지', // 텍스트 내용
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
        body: ListView(
            children: [
              // ListTile(
              //     leading: Icon(Icons.drive_file_rename_outline),
              //     title: Text('닉네임 변경'),
              //     onTap: () {
              //       // showDialog 함수를 호출하여 다이얼로그를 표시
              //       showDialog(
              //         context: context,
              //         builder: (BuildContext context) {
              //           return AlertDialog(
              //             title: Text('닉네임 변경'),
              //             content: TextField(
              //               decoration: InputDecoration(
              //                 hintText: '새로운 닉네임을 입력하세요',
              //               ),
              //             ),
              //             actions: <Widget>[
              //               TextButton(
              //                 child: Text('확인'),
              //                 onPressed: () {
              //                   // 여기에 새로운 닉네임을 저장하고 다이얼로그를 닫을 수 있는 로직 추가
              //                   Navigator.of(context).pop();
              //                 },
              //               ),
              //               TextButton(
              //                 child: Text('취소'),
              //                 onPressed: () {
              //                   // 다이얼로그를 닫을 수 있는 로직 추가
              //                   Navigator.of(context).pop();
              //                 },
              //               ),
              //             ],
              //           );
              //         },
              //       );
              //     }
              // ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('로그아웃'),
                onTap: () {
                  Logout();
                  // shared preferences에 저장된 정보들 삭제
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
                  );
                },
              ),
            ]


        )
    );
  }
}
