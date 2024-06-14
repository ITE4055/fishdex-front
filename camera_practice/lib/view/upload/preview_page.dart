import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({Key? key, required this.picture}) : super(key: key);

  final XFile picture;

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  String _category = '';
  final ImagePicker picker = ImagePicker();
  final TextEditingController _weightcontroller = TextEditingController();
  final TextEditingController _lengthcontroller = TextEditingController();
  final TextEditingController _locationcontroller = TextEditingController();


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
          '카메라로 등록하기', // 텍스트 내용
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
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min,
            children: [
              Image.file(File(widget.picture.path), fit: BoxFit.cover, width: 250, height: 200,),
              const SizedBox(height: 24),
              // Text(picture.path),
              //촬영 후 바로 업로드
              // ElevatedButton(onPressed: (){
              //   _uploadImage(picture.path);
              // },
              //     child: Text('Upload', style: TextStyle(color: Colors.lightBlueAccent))),
              widget.picture == null ?
              Text(
                "물고기 사진을 선택해주세요",
                style: TextStyle(fontSize: 20.0),
              )
                  :
              _category == '' ?

              ElevatedButton(
                onPressed: () {
                  _uploadImage();
                },
                child: Text('어떤 물고기일까요?',
                    style: TextStyle(color: Colors.lightBlueAccent)),
              )
                  :
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _category,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('무게: '),
                      Container(
                        width: 200,
                        child: TextFormField(
                          controller: _weightcontroller,
                          decoration: InputDecoration(border: OutlineInputBorder()),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('길이: '),
                      Container(
                        width: 200,
                        child: TextFormField(
                          controller: _lengthcontroller,
                          decoration: InputDecoration(border: OutlineInputBorder()),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('위치: '),
                      Container(
                        width: 200,
                        child: TextFormField(
                          controller: _locationcontroller,
                          decoration: InputDecoration(border: OutlineInputBorder()),
                        ),
                      ),
                    ],
                  ),

                  ElevatedButton(
                    onPressed: () {
                      _uploadToS3();
                      Navigator.pop(
                          context
                      );
                      Navigator.pop(
                          context
                      );
                      showToast();
                    },
                    child: Text('도감에 저장',
                        style: TextStyle(color: Colors.lightBlueAccent)),
                  )
                ],
              ),


            ]
        ),
      ),
    );
  }


  _uploadToS3() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.picture != null) {
      try {
        String filename = p.basename(widget.picture!.path);
        var url = Uri.parse(dotenv.get('S3_URL') + '/${filename}');
        var response = await http.put(
          url,
          headers: {'Content-Type': 'image/png'},
          body: File(widget.picture!.path).readAsBytesSync(),
        );
        print("RESPONSE SC: ${response.statusCode}");

        if (response.statusCode == 200) {
          print("S3에 업로드 성공!");
          print(dotenv.get('S3_URL') + '/${filename}');
          String s3_uri = dotenv.get('S3_URL') + '/${filename}';
          String _usercode = prefs.getString('usercode') ?? '';
          print(_usercode + '' + s3_uri+ '' + _category+ '' + _weightcontroller.text+ '' + _lengthcontroller.text+ '' + _locationcontroller.text);
          _uploadtoApiServer(_usercode, s3_uri, _category, _weightcontroller.text, _lengthcontroller.text, _locationcontroller.text);
          return '성공';
        }
        else {
          print("S3에 업로드 실패! : ${response.statusCode}");
          return 's3 fail';
        }
      }
      catch (e) {
        print("S3 업로드 실패: $e");
        return 's3 fail';
      }
    }
  }

  _uploadImage() async {
    if (widget.picture != null) {
      var uri = Uri.parse(dotenv.get('FLASK_URL') + '/predict');
      var request = http.MultipartRequest('POST', uri);
      request.files.add(
          await http.MultipartFile.fromPath('image', widget.picture!.path.toString()));

      var response = await request.send();

      if (response.statusCode == 200) {
        String species = await response.stream.bytesToString();
        Map<String, dynamic> jsonData = jsonDecode(species);
        String category = jsonData['species'];
        print('species: $category');
        setState(() {
          _category = category;
        });
        // return category;
      }
      else {
        print('UPLOAD FAILED');
        return 'no species';
      }
    }
    else {
      print('NO IMAGE SELECTED');
      return 'no species';
    }
  }



  _uploadtoApiServer(String usercode, String s3_url, String category, String weight, String length, String location) async {
    try {
      var uri = Uri.parse(dotenv.get('BASE_URL') + '/image/upload');

      Map data = {
        'usercode': usercode,
        'url': s3_url,
        'category': category,
        'weight': weight,
        'length': length,
        'location': location
      };

      var body = json.encode(data);

      var response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        print("Usercode, Url, Category, 무게, 길이, 위치 업로드 성공");
      }
      else {
        print("Usercode, Url, Category, 무게, 길이, 위치 업로드 실패");
      }
    }
    catch (e) {
      print("upload to api server error : $e");
    }
  }


// void _uploadImage(String imagePath) async{
  //   var uri = Uri.parse(dotenv.get('FLASK_URL') + '/predict');
  //   var request = http.MultipartRequest('POST', uri);
  //   request.files.add(await http.MultipartFile.fromPath('image', imagePath));
  //
  //   var response = await request.send();
  //
  //   if(response.statusCode == 200){
  //     String species = await response.stream.bytesToString();
  //
  //     print('species: $species');
  //   }
  //   else{
  //     print('UPLOAD FAILED');
  //   }
  // }
}

void showToast() {
  Fluttertoast.showToast(
      msg: "도감 등록 완료",
      gravity: ToastGravity.BOTTOM,
      fontSize: 20,
      toastLength: Toast.LENGTH_SHORT);
}