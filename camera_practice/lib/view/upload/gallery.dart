import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:path/path.dart' as p;
import 'package:fishdex/view/login/login_page.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});


  @override
  State<Gallery> createState() => _GalleryState();
}


class _GalleryState extends State<Gallery> {
  XFile? _image;
  final ImagePicker picker = ImagePicker();
  String _category = '';
  final TextEditingController _weightcontroller = TextEditingController();
  final TextEditingController _lengthcontroller = TextEditingController();
  final TextEditingController _locationcontroller = TextEditingController();

  _uploadToS3() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_image != null) {
      try {
        String filename = p.basename(_image!.path);
        var url = Uri.parse(dotenv.get('S3_URL') + '/${filename}');
        var response = await http.put(
          url,
          headers: {'Content-Type': 'image/png'},
          body: File(_image!.path).readAsBytesSync(),
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
    if (_image != null) {
      var uri = Uri.parse(dotenv.get('FLASK_URL') + '/predict');
      var request = http.MultipartRequest('POST', uri);
      request.files.add(
          await http.MultipartFile.fromPath('image', _image!.path.toString()));

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

  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
      });
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
          '앨범에서 등록하기', // 텍스트 내용
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,

          children: [
            Container(
                padding: EdgeInsets.all(5),
                width: 250.0,
                height: 250.0,
                decoration: BoxDecoration(
                  color: Color(0xff98bad5),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        blurRadius: 5.0,
                        spreadRadius: 0.0,
                        offset: Offset(0, 5))
                  ],
                ),
                child: _image == null
                    ? GestureDetector(
                  onTap: () {
                    getImage(ImageSource.gallery);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffD9D9D9),
                          shape: BoxShape.circle),
                      child: Icon(
                        Icons.file_upload_outlined,
                        size: 100.0,
                        color: Colors.white,
                      )),
                )
                    :

                CircleAvatar(
                  backgroundImage: FileImage(File(_image!.path)),
                )
          // Container(
          //         decoration: BoxDecoration(
          //           border: Border.all(),
          //         ),
          //         // padding: const EdgeInsets.all(8.0),
          //         child: Image.file(
          //           File(_image!.path),
          //           width: 200,
          //           height: 200,
          //           fit: BoxFit.cover,
          //         ),
          //       )
            ),
            SizedBox(
              height: 30.0,
            ),


            _image == null ?
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
                              Container(
                                width: 100,
                                child: TextFormField(
                                  controller: _weightcontroller,
                                  decoration: InputDecoration(
                                      hintText: '무게 Weight',
                                      hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide: BorderSide.none
                                      )),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                child: TextFormField(
                                  controller: _lengthcontroller,
                                  decoration: InputDecoration(
                                      hintText: '길이 Length',
                                      hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide: BorderSide.none
                                      )),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                child: TextFormField(
                                  controller: _locationcontroller,
                                  decoration: InputDecoration(
                                      hintText: '위치 Location',
                                      hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide: BorderSide.none
                                      )),
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
                              showToast();
                            },
                            child: Text('도감에 저장',
                                style: TextStyle(color: Colors.lightBlueAccent)),
                          )
                        ],
                    ),






            SizedBox(
              height: 40.0,
            ),
          ],
        ),
      ),
    );
  }
}

void showToast() {
  Fluttertoast.showToast(
      msg: "도감 등록 완료",
      gravity: ToastGravity.BOTTOM,
      fontSize: 20,
      toastLength: Toast.LENGTH_SHORT);
}