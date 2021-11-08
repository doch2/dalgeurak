import 'package:dalgeurak/screens/meal_planner.dart';
import 'package:dalgeurak/screens/my_profile.dart';
import 'package:flutter/material.dart';

import 'package:dalgeurak/screens/home.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();

}

class _MainScreenState extends State<MainScreen> {
  int _selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    List pages = [
      Home(),
      MealPlanner(),
      MyProfile()
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.withOpacity(0.6),
        selectedFontSize: 12,
        currentIndex: _selectIndex,
        onTap: (int index) {
          setState(() {
            _selectIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: "홈",
            icon: Icon(Icons.home_filled)
          ),
          BottomNavigationBarItem(
              label: "급식표",
              icon: Icon(Icons.calendar_today)
          ),
          BottomNavigationBarItem(
              label: "내 정보",
              icon: Icon(Icons.person)
          ),
        ],
      ),
      body: pages[_selectIndex]
    );
  }
}