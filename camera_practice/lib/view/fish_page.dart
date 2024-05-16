import 'package:flutter/material.dart';
import 'dart:io';
import 'package:s3_storage/s3_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


class FishPage extends StatefulWidget {
  const FishPage({super.key});

  @override
  State<FishPage> createState() => _FishPageState();
}

class _FishPageState extends State<FishPage> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    fetchImageFromS3();
  }



  fetchImageFromS3() async {
    try {
      var url = Uri.parse('https://final-fishdex.s3.ap-northeast-2.amazonaws.com/00030.png');
      var response = await http.get(url);
      print("RESPONSE SC: ${response.statusCode}");


      if (response.statusCode == 200) {
        setState(() {
          imageUrl = url.toString();
        });
        print("IMAGE URL: ${imageUrl}");
      } else {
        print('Failed to load image');
      }
    } catch (e) {
      print('Error occurred while fetching image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("이미지 불러오기"),
      ),
      body: imageUrl == null
          ? Center(child: CircularProgressIndicator())
          : Image.network(imageUrl!),
    );
  }
}