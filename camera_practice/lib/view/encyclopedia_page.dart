import 'dart:convert';

import 'package:flutter/material.dart';
import 'fish_page.dart';
import 'package:http/http.dart' as http;
import 'package:fishdex/utils.dart';

class EncyclopediaPage extends StatefulWidget {
  const EncyclopediaPage({Key? key});

  @override
  State<EncyclopediaPage> createState() => _EncyclopediaPageState();
}

class _EncyclopediaPageState extends State<EncyclopediaPage> {

  // _getUrlImages(String usercode, String category) async {
  //   // final url = 'http://218.39.215.36:3000/download/$category';
  //   // var uri = Uri.parse('http://218.39.215.36:3000/download/$category'); // Adjust if necessary
  //   // // Map data = {
  //   // //   'usercode': usercode
  //   // // };
  //   // final Map<String, String> params = {'usercode': usercode};
  //
  //   // final uri = Uri.parse(url);
  //   // final response = await http.get(uri, headers:params);
  //
  //   // var body = json.encode(params);
  //
  //   final String baseUrl = 'http://218.39.215.36:3000/download/$category';
  //
  //   // Complete URL with usercode as a query parameter
  //   var uri = Uri.parse('$baseUrl?usercode=$usercode');
  //
  //   print("uri: $uri");
  //   print("USERCODE: $usercode");
  //
  //   var response = await http.get(uri);
  //
  //   print("STATUS CODE: ${response.statusCode}");
  //
  //   if (response.statusCode == 200) {
  //     String responseBody = response.body;
  //     List<dynamic> jsonData = jsonDecode(responseBody);
  //     List<String> urls = jsonData.map((item) => item['url'] as String).toList();
  //     print("Retrieved URLs: $urls");
  //     return urls;
  //   } else {
  //     print("Can't get Images");
  //     return [];
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var _text = [];

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

    List<String> english_fishnames = [
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

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: Text(
            '도감', // 텍스트 내용
            style: TextStyle(
              fontSize: 30, // 폰트 크기 설정
              fontFamily: 'Roboto', // 사용할 폰트 설정
              fontWeight: FontWeight.bold, // 폰트 굵기 설정
              fontStyle: FontStyle.italic, // 폰트 스타일 설정
              color: Colors.black, // 텍스트 색상 설정
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false
      ),
      body:
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            children: List<Widget>.generate(9, (index) {
              // String img = 'lib/fish/fish1.png';
              return InkWell(
                onTap: () async {
                  print("${english_fishnames[index]} clicked!");
                  String? usercode = await getUsercode();
                  print("usercode: $usercode");
                  _text = await getUrlImages(usercode!, english_fishnames[index]);
                  print('LIST OF URL:   ${_text}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FishPage()),
                  );
                },
                child: Container(
                color: Colors.black12,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.grey,
                        BlendMode.saturation,
                      ),
                      child:
                      Image.asset(
                        'lib/fish/fish-${index + 1}.png',
                        // fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      fishNames[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      )
                    ),
                  ],
                )
                ),
              );
            }),
          ),
    );
      // body: SafeArea(
      //   child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Row(
    //               children: [
    //                 SizedBox(
    //                   width: 90,
    //                   height: 90,
    //                   child: ClipOval(
    //                     child: ElevatedButton(
    //                       onPressed: () async {},
    //                       style: ElevatedButton.styleFrom(
    //                         backgroundColor: Colors.lightBlueAccent,
    //                       ),
    //                       child: Transform.scale(
    //                         scale: 0.8,
    //                         child: Image.asset(
    //                           'lib/icons/fish.png',
    //                           color: Colors.white,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 const SizedBox(width: 20.0),
    //                 SizedBox(
    //                   width: 90,
    //                   height: 90,
    //                   child: ClipOval(
    //                     child: ElevatedButton(
    //                       onPressed: () async {},
    //                       style: ElevatedButton.styleFrom(
    //                         backgroundColor: Colors.lightBlueAccent,
    //                       ),
    //                       child: Transform.scale(
    //                         scale: 0.8,
    //                         child: Image.asset(
    //                           'lib/icons/fish.png',
    //                           color: Colors.white,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 const SizedBox(width: 20.0),
    //                 SizedBox(
    //                   width: 90,
    //                   height: 90,
    //                   child: ClipOval(
    //                     child: ElevatedButton(
    //                       onPressed: () async {},
    //                       style: ElevatedButton.styleFrom(
    //                         backgroundColor: Colors.lightBlueAccent,
    //                       ),
    //                       child: Transform.scale(
    //                         scale: 0.8,
    //                         child: Image.asset(
    //                           'lib/icons/fish.png',
    //                           color: Colors.white,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 const SizedBox(height: 20.0),
    //               ],
    //             ),
    //             const SizedBox(height: 20.0),
    //             Row(
    //               children: [
    //                 SizedBox(
    //                   width: 90,
    //                   height: 90,
    //                   child: ClipOval(
    //                     child: ElevatedButton(
    //                       onPressed: () async {},
    //                       style: ElevatedButton.styleFrom(
    //                         backgroundColor: Colors.lightBlueAccent,
    //                       ),
    //                       child: Transform.scale(
    //                         scale: 0.8,
    //                         child: Image.asset(
    //                           'lib/icons/fish.png',
    //                           color: Colors.white,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 const SizedBox(width: 20.0),
    //                 SizedBox(
    //                   width: 90,
    //                   height: 90,
    //                   child: ClipOval(
    //                     child: ElevatedButton(
    //                       onPressed: () async {},
    //                       style: ElevatedButton.styleFrom(
    //                         backgroundColor: Colors.lightBlueAccent,
    //                       ),
    //                       child: Transform.scale(
    //                         scale: 0.8,
    //                         child: Image.asset(
    //                           'lib/icons/fish.png',
    //                           color: Colors.white,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 const SizedBox(width: 20.0),
    //                 SizedBox(
    //                   width: 90,
    //                   height: 90,
    //                   child: ClipOval(
    //                     child: ElevatedButton(
    //                       onPressed: () async {},
    //                       style: ElevatedButton.styleFrom(
    //                         backgroundColor: Colors.lightBlueAccent,
    //                       ),
    //                       child: Transform.scale(
    //                         scale: 0.8,
    //                         child: Image.asset(
    //                           'lib/icons/fish.png',
    //                           color: Colors.white,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 const SizedBox(height: 20.0),
    //               ],
    //             ),
    //             const SizedBox(height: 20.0),
    //             Row(
    //               children: [
    //                 SizedBox(
    //                   width: 90,
    //                   height: 90,
    //                   child: ClipOval(
    //                     child: ElevatedButton(
    //                       onPressed: () async {},
    //                       style: ElevatedButton.styleFrom(
    //                         backgroundColor: Colors.lightBlueAccent,
    //                       ),
    //                       child: Transform.scale(
    //                         scale: 0.8,
    //                         child: Image.asset(
    //                           'lib/icons/fish.png',
    //                           color: Colors.white,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 const SizedBox(width: 20.0),
    //                 SizedBox(
    //                   width: 90,
    //                   height: 90,
    //                   child: ClipOval(
    //                     child: ElevatedButton(
    //                       onPressed: () async {},
    //                       style: ElevatedButton.styleFrom(
    //                         backgroundColor: Colors.lightBlueAccent,
    //                       ),
    //                       child: Transform.scale(
    //                         scale: 0.8,
    //                         child: Image.asset(
    //                           'lib/icons/fish.png',
    //                           color: Colors.white,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 const SizedBox(width: 20.0),
    //                 SizedBox(
    //                   width: 90,
    //                   height: 90,
    //                   child: ClipOval(
    //                     child: ElevatedButton(
    //                       onPressed: () async {},
    //                       style: ElevatedButton.styleFrom(
    //                         backgroundColor: Colors.lightBlueAccent,
    //                       ),
    //                       child: Transform.scale(
    //                         scale: 0.8,
    //                         child: Image.asset(
    //                           'lib/icons/fish.png',
    //                           color: Colors.white,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 const SizedBox(height: 20.0),
    //               ],
    //             ),
    //             // Repeat the similar structure for other rows
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
