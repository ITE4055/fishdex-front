import 'dart:convert';

import 'package:fishdex/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BadgePage extends StatefulWidget {
  const BadgePage({super.key});

  @override
  State<BadgePage> createState() => _BadgePageState();
}

class _BadgePageState extends State<BadgePage> {
  List<String> _isBadgeActive = [
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
  ];

  @override
  void initState() {
    super.initState();
    _loadBadgeList();
  }



  Future<void> _loadBadgeList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uri = Uri.parse(dotenv.get('BASE_URL') + '/user/code');

    // Create the body of the request
    var body = json.encode({'usercode': prefs.getString('usercode')});

    var request = http.Request('GET', uri)
      ..headers['Content-Type'] = 'application/json'
      ..body = body;

    var response = await request.send();

    var responseBody = await response.stream.bytesToString();

    // print("USERCODE: $usercode");
    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${responseBody}");

    if(response.statusCode == 200){
      var jsonData = json.decode(responseBody);
      // print(jsonData["badges"].split(','));

      setState(() {
        _isBadgeActive = jsonData["badges"].split(',');
      });

      print(_isBadgeActive);
      // return [jsonData];
    }
    // if(response.statusCode == 401){
    //   var jsonData = json.decode(responseBody);
    //   print("$jsonData");
    //   return [jsonData];
    // }
    // else{
    //   print("Failed to Load User");
    //   return [];
    // }
  }

  _setMainBadgeTitle(String badgeImage, String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mainBadge', badgeImage);
    prefs.setString('mainTitle', title);
  }

  @override
  Widget build(BuildContext context) {
    List<String> imageList = [
      'lib/collection/medal3.png',
      'lib/collection/medal2.png',
      'lib/collection/medal1.png',
      'lib/collection/medal_3.png',
      'lib/collection/medal_2.png',
      'lib/collection/medal_1.png',
      'lib/collection/trophy3.png',
      'lib/collection/trophy2.png',
      'lib/collection/trophy1.png',
    ];

    List<String> titleList = [
      '초보 낚시꾼',
      '낚시 마스터',
      '전설의 어부',
      '흑해청어 뉴비',
      '흑해청어 마스터',
      '흑해청어왕',
      '송어 뉴비',
      '송어 마스터',
      '송어왕',
    ];

    List<String> descriptionList = [
      '도감에 1마리 이상 등록한 사람에게 주어지는 뱃지',
      '도감에 30마리 이상 등록한 사람에게 주어지는 뱃지',
      '도감에 100마리 이상 등록한 사람에게 주어지는 뱃지',
      '흑해청어를 1마리 이상 등록한 사람에게 주어지는 뱃지',
      '흑해청어를 10마리 이상 등록한 사람에게 주어지는 뱃지',
      '흑해청어를 30마리 이상 등록한 사람에게 주어지는 뱃지',
      '송어를 1마리 이상 등록한 사람에게 주어지는 뱃지',
      '송어를 10마리 이상 등록한 사람에게 주어지는 뱃지',
      '송어를 30마리 이상 등록한 사람에게 주어지는 뱃지',

    ];



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF98BAD5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: const Text(
          '컬렉션', // 텍스트 내용
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
      body: GridView.builder(
        itemCount: imageList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(titleList[index]),
                    content: Text(descriptionList[index]),
                    actions: <Widget>[
                      if (_isBadgeActive[index] == '1')
                        TextButton(
                          child: Text('대표 뱃지로 등록'),
                          onPressed: () {
                            _setMainBadgeTitle(imageList[index], titleList[index]);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage()),
                                  (route) => false,
                            );
                          },
                        ),
                      TextButton(
                        child: Text('취소'),
                        onPressed: () {
                          // 다이얼로그를 닫을 수 있는 로직 추가
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: GridTile(
              child: Container(
                padding: EdgeInsets.all(8.0), // 위아래 공간을 만들기 위해 패딩을 추가합니다.
                color: _isBadgeActive[index] == '1'
                    ? Colors.transparent
                    : Colors.grey.withOpacity(0.5),
                child: Center(
                  child: Image.asset(
                    imageList[index],
                    fit: BoxFit.cover,
                    color: _isBadgeActive[index] == '1'
                        ? null
                        : Colors.grey.withOpacity(0.5),
                    colorBlendMode: _isBadgeActive[index] == '1'
                        ? null
                        : BlendMode.saturation,
                  ),
                ),
              ),
            ),
          );
        },
      )
    );
  }
}
