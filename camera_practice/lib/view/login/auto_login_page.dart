import 'package:fishdex/view/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';
import 'login_page.dart';

class AutoLoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: attemptAutoLogin(),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 로딩 중이면 로딩 표시
          return CircularProgressIndicator();
        } else {
          if (snapshot.data == true) {
            return BottomNav();
          } else {
            return LoginPage();
          }
        }
      },
    );
  }

  Future<bool> attemptAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? usercode = prefs.getString('usercode');

    return (username != null && usercode != null);

  }
}