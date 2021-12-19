import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/screens/meal_planner.dart';
import 'package:dalgeurak/screens/profile/my_profile.dart';
import 'package:dalgeurak/screens/home.dart';
import 'package:dalgeurak/screens/admin_page.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();

}

class _MainScreenState extends State<MainScreen> {
  int _selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    String? userGroup = Get.find<UserController>().user.group;

    List pages = [
      Home(),
      MealPlanner(),
      MyProfile()
    ];

    List<BottomNavigationBarItem> bottomNavigatorItem = [
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
    ];

    if (userGroup != null && userGroup != "student") {
      pages.insert(1, AdminPage());

      bottomNavigatorItem.insert(1, BottomNavigationBarItem(
          label: "급식 정보",
          icon: Icon(Icons.edit)
      ));
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: blueThree,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.withOpacity(0.6),
        selectedFontSize: 12,
        currentIndex: _selectIndex,
        onTap: (int index) {
          setState(() {
            _selectIndex = index;
          });
        },
        items: bottomNavigatorItem,
      ),
      body: pages[_selectIndex]
    );
  }
}