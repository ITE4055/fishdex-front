import 'package:fishdex/view/login/auto_login_page.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:s3_storage/s3_storage.dart';

//model - data and business logic of the application
//view - UI components that the user interacts with
//controller - Mediates between the Model and the View,
// handling user input and updating the model accordingly.

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  KakaoSdk.init(
    nativeAppKey: '300de9121f69b9358b245c466ceeff57',
    javaScriptAppKey: '620f2c74e75cc0175258b32ada316ed9'
  );
  //
  // final s3_storage = S3Storage(
  //     endPoint: 's3.amazonaws.com',
  //     accessKey: 'AKIA6ODU65VTMUU33ENK',
  //     secretKey: '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'
  // );


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Camera Demo',
      debugShowCheckedModeBanner: false,
      // home: SplashScreen(),
      home: AutoLoginScreen(),
    );
  }
}