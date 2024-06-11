import 'package:fishdex/view/encyclopedia_page.dart';
import 'package:fishdex/view/home_page.dart';
import 'package:fishdex/view/sidebar/account_page.dart';
import 'package:fishdex/view/sidebar/badge_page.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    EncyclopediaPage(),
    BadgePage(),
    AccountPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '도감',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: '컬렉션',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xffffffff),
        unselectedItemColor: Color(0xffc6d3e3),
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        backgroundColor: Color(0xff98bad5),
      ),
    );
  }
}
