import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.picture}) : super(key: key);

  final XFile picture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Preview Page')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.file(File(picture.path), fit: BoxFit.cover, width: 250),
          const SizedBox(height: 24),
          // Text(picture.path),
          //촬영 후 바로 업로드
          ElevatedButton(onPressed: (){
            _uploadImage(picture.path);
          },
              child: Text('Upload', style: TextStyle(color: Colors.lightBlueAccent)))
        ]),
      ),
    );
  }
  void _uploadImage(String imagePath) async{
    var uri = Uri.parse(dotenv.get('FLASK_URL') + '/predict');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    var response = await request.send();

    if(response.statusCode == 200){
      String species = await response.stream.bytesToString();

      print('species: $species');
    }
    else{
      print('UPLOAD FAILED');
    }
  }
}