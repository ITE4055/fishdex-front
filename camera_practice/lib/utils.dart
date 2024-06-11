import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> getUsercode() async {
  try {
    User user = await UserApi.instance.me();
    return user.id.toString();
  } catch (e) {
    print("GETUSERCODE ERROR: $e");
    return null;
  }
}

getUrlImages(String usercode, String category) async {

  var uri = Uri.parse(dotenv.get('BASE_URL') + '/image/$category');

  // Create the body of the request
  var body = json.encode({'usercode': usercode});

  var request = http.Request('GET', uri)
    ..headers['Content-Type'] = 'application/json'
    ..body = body;

  var response = await request.send();

  var responseBody = await response.stream.bytesToString();

  print("USERCODE: $usercode");

  print("STATUS CODE: ${response.statusCode}");
  print("RESPONSE BODY: ${responseBody}");

  if(response.statusCode == 200){
    var jsonData = json.decode(responseBody);
    print("Image URLs: ${jsonData}");
    return [jsonData];
  }
  if(response.statusCode == 401){
    var jsonData = json.decode(responseBody);
    print("$jsonData");
    return [jsonData];
  }
  else{
    print("Failed to Load Image");
    return [];
  }
}

