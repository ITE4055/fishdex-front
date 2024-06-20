import 'dart:convert';

import 'package:fishdex/view/bottom_nav.dart';
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
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0'
  ];

  @override
  void initState() {
    super.initState();
    _loadBadgeList();
  }


  _activeBadge(var jsonData) {
    // print(jsonData);
    int blackseasprat = 0;
    int trout = 0;
    int stripedredmullet = 0;
    int shrimp = 0;
    int seabass = 0;
    int redseabream = 0;
    int redmullet = 0;
    int horsemackerel = 0;
    int glitheadbream = 0;

    for (int i = 0; i < jsonData.length; i++) {
      switch (jsonData[i]["category"]) {
        case "Black Sea Sprat":
          blackseasprat = jsonData[i]['count'];
          break;
        case "Trout":
          trout = jsonData[i]['count'];
          break;
        case "Striped Red Mullet":
          stripedredmullet = jsonData[i]['count'];
          break;
        case "Shrimp":
          shrimp = jsonData[i]['count'];
          break;
        case "Sea Bass":
          seabass = jsonData[i]['count'];
          break;
        case "Red Sea Bream":
          redseabream = jsonData[i]['count'];
          break;
        case "Red Mullet":
          redmullet = jsonData[i]['count'];
          break;
        case "Horse Mackerel":
          horsemackerel = jsonData[i]['count'];
          break;
        case "Glit-Head Bream":
          glitheadbream = jsonData[i]['count'];
          break;

      }
    }

    int sum = blackseasprat + trout + stripedredmullet + shrimp + redmullet + seabass + redseabream + horsemackerel + glitheadbream;
    setState(() {
      if (10 <= sum) {
        _isBadgeActive[2] = '1';
      } if (5<= sum) {
        _isBadgeActive[1] = '1';
      } if(1<= sum) {
        _isBadgeActive[0] = '1';
      }

      if (5 <= blackseasprat) {
        _isBadgeActive[5] = '1';
      }  if(3<= blackseasprat) {
        _isBadgeActive[4] = '1';
      }  if(1<= blackseasprat) {
        _isBadgeActive[3] = '1';
      }

      if (5 <= trout) {
        _isBadgeActive[8] = '1';
      }  if(3<= trout) {
        _isBadgeActive[7] = '1';
      }  if(1<= trout) {
        _isBadgeActive[6] = '1';
      }

      if (5 <= stripedredmullet) {
        _isBadgeActive[11] = '1';
      }  if(3<= stripedredmullet) {
        _isBadgeActive[10] = '1';
      }  if(1<= stripedredmullet) {
        _isBadgeActive[9] = '1';
      }

      if (5 <= shrimp) {
        _isBadgeActive[14] = '1';
      }  if(3<= shrimp) {
        _isBadgeActive[13] = '1';
      }  if(1<= shrimp) {
        _isBadgeActive[12] = '1';
      }

      if (5 <= seabass) {
        _isBadgeActive[17] = '1';
      }  if(3<= seabass ) {
        _isBadgeActive[16] = '1';
      }  if(1<= seabass) {
        _isBadgeActive[15] = '1';
      }

      if (5 <= redseabream) {
        _isBadgeActive[20] = '1';
      }  if(3<= redseabream) {
        _isBadgeActive[19] = '1';
      }  if(1<= redseabream ) {
        _isBadgeActive[18] = '1';
      }

      if (5 <= redmullet) {
        _isBadgeActive[23] = '1';
      }  if(3<= redmullet) {
        _isBadgeActive[22] = '1';
      }  if(1<= redmullet ) {
        _isBadgeActive[21] = '1';
      }

      if (5 <= horsemackerel) {
        _isBadgeActive[26] = '1';
      }  if(3<= horsemackerel) {
        _isBadgeActive[25] = '1';
      }  if(1<= horsemackerel ) {
        _isBadgeActive[24] = '1';
      }

      if (5 <= glitheadbream) {
        _isBadgeActive[29] = '1';
      }  if(3<= glitheadbream) {
        _isBadgeActive[28] = '1';
      }  if(1<= glitheadbream ) {
        _isBadgeActive[27] = '1';
      }


    });

  }


  Future<void> _loadBadgeList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uri = Uri.parse(dotenv.get('BASE_URL') + '/image');

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
      _activeBadge(jsonData);
    }
  }

  _setMainBadgeTitle(String badgeImage, String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mainBadge', badgeImage);
    prefs.setString('mainTitle', title);
  }

  @override
  Widget build(BuildContext context) {
    List<String> imageList = [
      'lib/collection/medal_3.png',
      'lib/collection/medal_2.png',
      'lib/collection/medal_1.png',
      'lib/collection/medal3.png',
      'lib/collection/medal2.png',
      'lib/collection/medal1.png',
      'lib/collection/a-bronze-medal-a.png',
      'lib/collection/a-silver-medal-a.png',
      'lib/collection/a-gold-medal-a.png',
      'lib/collection/c-bronze-medal.png',
      'lib/collection/c-silver-medal.png',
      'lib/collection/c-gold-medal.png',
      'lib/collection/m-medal3.png',
      'lib/collection/m-medal2.png',
      'lib/collection/m-medal1.png',
      'lib/collection/n-bronze-medal.png',
      'lib/collection/n-silver-medal.png',
      'lib/collection/n-gold-medal.png',
      'lib/collection/r-medal3.png',
      'lib/collection/r-medal2.png',
      'lib/collection/r-medal.png',
      'lib/collection/v-bronze-medal.png',
      'lib/collection/v-silver-medal.png',
      'lib/collection/v-gold-medal.png',
      'lib/collection/x-award-medal3.png',
      'lib/collection/x-award-medal2.png',
      'lib/collection/x-award-medal.png',
      'lib/collection/z-bronze-medal.png',
      'lib/collection/z-silver-medal.png',
      'lib/collection/z-gold-medal.png',
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
      '줄무늬붉은돔 뉴비',
      '줄무늬붉은돔 마스터',
      '줄무늬붉은돔왕',
      '새우 뉴비',
      '새우 마스터',
      '새우왕',
      '농어 뉴비',
      '농어 마스터',
      '농어왕',
      '참돔 뉴비',
      '참돔 마스터',
      '참돔왕',
      '붉은숭어 뉴비',
      '붉은숭어 마스터',
      '붉은숭어왕',
      '전갱이 뉴비',
      '전갱이 마스터',
      '전갱이왕',
      '도미 뉴비',
      '도미 마스터',
      '도미왕'
    ];

    List<String> descriptionList = [
      '도감에 1마리 이상 등록한 사람에게 주어지는 뱃지',
      '도감에 5마리 이상 등록한 사람에게 주어지는 뱃지',
      '도감에 10마리 이상 등록한 사람에게 주어지는 뱃지',
      '흑해청어를 1마리 이상 등록한 사람에게 주어지는 뱃지',
      '흑해청어를 3마리 이상 등록한 사람에게 주어지는 뱃지',
      '흑해청어를 5마리 이상 등록한 사람에게 주어지는 뱃지',
      '송어를 1마리 이상 등록한 사람에게 주어지는 뱃지',
      '송어를 3마리 이상 등록한 사람에게 주어지는 뱃지',
      '송어를 5마리 이상 등록한 사람에게 주어지는 뱃지',
      '줄무늬붉은돔을 1마리 이상 등록한 사람에게 주어지는 뱃지',
      '줄무늬붉은돔을 3마리 이상 등록한 사람에게 주어지는 뱃지',
      '줄무늬붉은돔을 5마리 이상 등록한 사람에게 주어지는 뱃지',
      '새우를 1마리 이상 등록한 사람에게 주어지는 뱃지',
      '새우를 3마리 이상 등록한 사람에게 주어지는 뱃지',
      '새우를 5마리 이상 등록한 사람에게 주어지는 뱃지',
      '농어를 1마리 이상 등록한 사람에게 주어지는 뱃지',
      '농어를 3마리 이상 등록한 사람에게 주어지는 뱃지',
      '농어를 5마리 이상 등록한 사람에게 주어지는 뱃지',
      '참돔을 1마리 이상 등록한 사람에게 주어지는 뱃지',
      '참돔을 3마리 이상 등록한 사람에게 주어지는 뱃지',
      '참돔을 5마리 이상 등록한 사람에게 주어지는 뱃지',
      '붉은숭어를 1마리 이상 등록한 사람에게 주어지는 뱃지',
      '붉은숭어를 3마리 이상 등록한 사람에게 주어지는 뱃지',
      '붉은숭어를 5마리 이상 등록한 사람에게 주어지는 뱃지',
      '전갱이를 1마리 이상 등록한 사람에게 주어지는 뱃지',
      '전갱이를 3마리 이상 등록한 사람에게 주어지는 뱃지',
      '전갱이를 5마리 이상 등록한 사람에게 주어지는 뱃지',
      '도미를 1마리 이상 등록한 사람에게 주어지는 뱃지',
      '도미를 3마리 이상 등록한 사람에게 주어지는 뱃지',
      '도미를 5마리 이상 등록한 사람에게 주어지는 뱃지',
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
                              MaterialPageRoute(builder: (context) => BottomNav()),
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
