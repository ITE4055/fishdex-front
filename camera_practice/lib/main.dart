import 'package:fishdex/view/login/auto_login_page.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

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