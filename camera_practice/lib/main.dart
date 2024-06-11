import 'package:fishdex/view/login/auto_login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:s3_storage/s3_storage.dart';

//model - data and business logic of the application
//view - UI components that the user interacts with
//controller - Mediates between the Model and the View,
// handling user input and updating the model accordingly.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  KakaoSdk.init(
    nativeAppKey: dotenv.get('KAKAO_NATIVE_APP_KEY'),
    javaScriptAppKey: dotenv.get('KAKAO_JAVASCRIPT_APP_KEY')
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