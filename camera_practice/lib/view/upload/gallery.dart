import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:minio_new/io.dart';
import 'package:minio_new/minio.dart';
import 'package:minio_new/models.dart';
import 'package:path/path.dart' as p;

class Gallery extends StatefulWidget {
  const Gallery({super.key});


  @override
  State<Gallery> createState() => _GalleryState();
}


class _GalleryState extends State<Gallery> {
  XFile? _image;
  final ImagePicker picker = ImagePicker();

  _uploadToS3() async{
    if(_image != null){
      try{
        String filename = p.basename(_image!.path);
        var request = http.MultipartRequest('PUT', Uri.parse('https://oq98wk34h3.execute-api.ap-northeast-2.amazonaws.com/dev/final-fishdex/${filename}'));
        request.files.add(await http.MultipartFile.fromPath('file', _image!.path));
        var response = await request.send();

        if(response.statusCode == 200){
          print("S3에 업로드 성공!");
          print("https://final-fishdex.s3.ap-northeast-2.amazonaws.com/${filename}");
          String s3_uri =  "https://final-fishdex.s3.ap-northeast-2.amazonaws.com/${filename}";
          return s3_uri;
        }
        else{
          print("S3에 업로드 실패! : ${response.statusCode}");
        }
      }
      catch(e){
        print("S3 업로드 실패: $e");
      }
    }
  }


  _uploadImage() async{
    if (_image != null){
      var uri = Uri.parse('http://218.39.215.36:5000/predict');
      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', _image!.path.toString()));

      var response = await request.send();

      if(response.statusCode == 200){
        String species = await response.stream.bytesToString();
        print('species: $species');
        return species;
      }
      else{
        print('UPLOAD FAILED');
      }
    }
    else{
      print('NO IMAGE SELECTED');
    }
  }


  Future getImage(ImageSource imageSource) async{
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null){
      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _text = '';

    return Scaffold(
      // appBar: AppBar(title: const Text('Image')),
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
            ElevatedButton(onPressed: () => getImage(ImageSource.gallery), child: Text('Select Image', style: TextStyle(color: Colors.lightBlueAccent))),
            if (_image != null)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _text = _uploadImage();
                      });
                    },
                    child: Text('UPLOAD', style: TextStyle(color: Colors.lightBlueAccent)),
                  ),
                  ElevatedButton(onPressed: () {
                    setState(() {
                      if(_image != null) {
                        print("이미지이미지이밎: " );
                        _uploadToS3();
                        // String s3_uri = returnS3Uri() as String;
                        // print("S3 URL: " + s3_uri);
                      }
                    });
                  },
                    child: Text('도감에 저장', style: TextStyle(color: Colors.lightBlueAccent)),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}

//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH
//MAKE BRANCH