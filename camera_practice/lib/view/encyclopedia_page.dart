import 'dart:convert';

import 'package:fishdex/view/pages/fish_info_page.dart';
import 'package:flutter/material.dart';
import 'pages/fish_page.dart';
import 'package:http/http.dart' as http;
import 'package:fishdex/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class EncyclopediaPage extends StatefulWidget {
  const EncyclopediaPage({Key? key}) : super(key: key);

  @override
  State<EncyclopediaPage> createState() => _EncyclopediaPageState();
}

class _EncyclopediaPageState extends State<EncyclopediaPage> {
  List<String> fishNames = [
    '흑해 청어', //'Black Sea Sprat', //fish-1
    '송어', //'Trout', //fish-2
    '줄무늬 붉은돔', //'Striped Red Mullet', //fish-3
    '새우',//'Shrimp', //fish-4
    '농어', //'Sea Bass', //fish-5
    '참돔', //'Red Sea Bream', //fish-6
    '붉은 숭어', //'Red Mullet', //fish-7
    '전갱이', //'Horse Mackerel', //fish-8
    '도미', //'Gilt Head Bream', //fish-9
  ];

  List<String> englishFishNames = [
    'Black Sea Sprat',
    'Trout',
    'Striped Red Mullet',
    'Shrimp',
    'Sea Bass',
    'Red Sea Bream',
    'Red Mullet',
    'Horse Mackerel',
    'Gilt-Head Bream',
  ];

  @override
  Widget build(BuildContext context) {
    List<String> _text = [];

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
        padding: const EdgeInsets.only(top: 10.0), // Added more space from the app bar and the grid
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          children: List.generate(9, (index) {
            // String img = 'lib/fish/fish1.png';
            return InkWell(
              onTap: () async {
                // print("${english_fishnames[index]} clicked!");
                // String? usercode = await getUsercode();
                // print("usercode: $usercode");
                // _text = await getUrlImages(usercode!, english_fishnames[index]);
                // String fe = _text[0];
                // print('LIST OF URL:   ${_text}');
                // print('FIRST ELEMENT:   ${fe}');

                print("${englishFishNames[index]} clicked!");

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FishInfoPage(fishName: englishFishNames[index]),
                  ),
                );

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder:(context) => FishInfoPage(
                //     fishName: english_fishnames[index],
                //     imageUrl: fe,
                //   ),
                //       // builder: (context) => FishPage(imageUrl: fe)
                //  ),
                // );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF98BAD5),
                  borderRadius: BorderRadius.circular(15),
                ),
                // color: Colors.black12,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/fish/fish-${index + 1}.png',
                    ),
                    // ColorFiltered(
                    //   colorFilter: const ColorFilter.mode(
                    //     Colors.grey,
                    //     BlendMode.saturation,
                    //   ),
                    //   child:
                    //   Image.asset(
                    //     'lib/fish/fish-${index + 1}.png',
                    //   ),
                    // ),
                    // SizedBox(height: 5),
                    Text(
                      fishNames[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      englishFishNames[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
