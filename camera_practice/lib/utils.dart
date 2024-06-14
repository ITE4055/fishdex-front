import 'dart:io';

import 'package:fishdex/view/pages/image_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getUsercode() async {
  try {
    User user = await UserApi.instance.me();
    return user.id.toString();
  } catch (e) {
    print("GETUSERCODE ERROR: $e");
    return null;
  }
}

Future<List<ImageData>> getUrlImages(String category) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var uri = Uri.parse(dotenv.get('BASE_URL') + '/image/$category');
  // Create the body of the request
  var body = json.encode({'usercode': prefs.getString('usercode') ?? ''});
  var request = http.Request('GET', uri)
    ..headers['Content-Type'] = 'application/json'
    ..body = body;

  var response = await request.send();
  var responseBody = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(responseBody);
    print(jsonResponse);
    return jsonResponse.map((data) => ImageData.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load images');
  }

  // var responseBody = await response.stream.bytesToString();
  // print("USERCODE: $usercode");
  //
  // print("STATUS CODE: ${response.statusCode}");
  // print("RESPONSE BODY: ${responseBody}");
  // if(response.statusCode == 200){
  //   var jsonData = json.decode(responseBody);
  //   print("Image URLs: ${jsonData}");
  //   return jsonData;
  // }
  // if(response.statusCode == 401){
  //   var jsonData = json.decode(responseBody);
  //   print("$jsonData");
  //   return jsonData;
  // }
  // else{
  //   print("Failed to Load Image");
  //   return [];
  // }

}

