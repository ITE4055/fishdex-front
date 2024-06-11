import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:path/path.dart' as p;
import 'package:fishdex/view/login/login_page.dart';
import 'package:http_parser/http_parser.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});


  @override
  State<Gallery> createState() => _GalleryState();
}


class _GalleryState extends State<Gallery> {
  XFile? _image;
  final ImagePicker picker = ImagePicker();

  _uploadToS3() async {
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
          return s3_uri;
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
        return category;
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

  getUsercode() async {
    try {
      User user = await UserApi.instance.me();
      return user.id.toString();
    }
    catch (e) {
      print("GETUSERCODE ERROR: $e");
    }
  }

  _uploadtoApiServer(String usercode, String s3_url, String category) async {
    try {
      var uri = Uri.parse(dotenv.get('BASE_URL') + '/image/upload');

      Map data = {
        'usercode': usercode,
        'url': s3_url,
        'category': category
      };

      var body = json.encode(data);

      var response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        print("Usercode, Url, Category 업로드 성공");
      }
      else {
        print("Usercode, Url, Category 업로드 실패");
      }
    }
    catch (e) {
      print("upload to api server error : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var _text = '';

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            if(_image != null)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                // padding: const EdgeInsets.all(8.0),
                child: Image.file(
                  File(_image!.path),
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),

            Text(
              _text,
            ),
            //이거 빼기
            ElevatedButton(onPressed: () => getImage(ImageSource.gallery),
                child: Text('Select Image',
                    style: TextStyle(color: Colors.lightBlueAccent))),
            if (_image != null)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() async {
                        try {
                          _text = await _uploadImage();
                          print(_text);
                        }
                        catch (e) {
                          print("ERROR: $e");
                        }
                      });
                    },
                    child: Text('UPLOAD',
                        style: TextStyle(color: Colors.lightBlueAccent)),
                  ),
                  ElevatedButton(onPressed: () {
                    setState(() async {
                      if (_image != null) {
                        try {
                          print("이미지이미지이밎: ");
                          String url = await _uploadToS3();
                          String usercode = await getUsercode();
                          String category = await _uploadImage();
                          print("S3 URL S3 URL S3 URL: " + url);
                          print("USERCODE USERCODE USERCODE: " + usercode);
                          print("CATEGORY CATEGORY CATEGORY: " + category);
                          _uploadtoApiServer(usercode, url, category);
                        }
                        catch (e) {
                          print("ERROR: $e");
                        }
                        // String s3_uri = returnS3Uri() as String;
                        // print("S3 URL: " + s3_uri);
                      }
                    });
                  },
                    child: Text('도감에 저장',
                        style: TextStyle(color: Colors.lightBlueAccent)),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
