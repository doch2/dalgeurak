import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/screens/calendar/calendar_page.dart';
import 'package:dalgeurak/screens/meal_planner/meal_planner.dart';
import 'package:dalgeurak/screens/profile/my_profile.dart';
<<<<<<< HEAD
import 'package:dalgeurak/screens/home.dart';
import 'package:dalgeurak/screens/admin_page.dart';
=======
import 'package:dalgeurak/screens/home/home.dart';
import 'package:dalgeurak/screens/studentManage/admin_page.dart';
>>>>>>> 92c83953fd75001b4a696ac8f90034ff2b2f9a90
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
<<<<<<< HEAD
    String? userGroup = Get.find<UserController>().user.group;
=======
    DimigoinUserType? userGroup = Get.find<UserController>().user?.userType;
    List<DimigoinPermissionType>? userPermission = Get.find<UserController>().user?.permissions;

    Map pageIcon = {
      '홈': 'home',
      '급식표': 'calendar',
      '관리': 'signDocu',
      '일정': 'calendar2',
      '내 정보': 'user'
    };
>>>>>>> 92c83953fd75001b4a696ac8f90034ff2b2f9a90

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

<<<<<<< HEAD
    if (userGroup != null && userGroup != "student") {
      pages.insert(1, AdminPage());
=======
    if ((userGroup != null && userGroup == DimigoinUserType.student) && userPermission!.contains(DimigoinPermissionType.dalgeurak)) {
      pages.insert(2, AdminPage());
>>>>>>> 92c83953fd75001b4a696ac8f90034ff2b2f9a90

      bottomNavigatorItem.insert(1, BottomNavigationBarItem(
          label: "급식 정보",
          icon: Icon(Icons.edit)
      ));
    }

<<<<<<< HEAD
=======
    if ((userGroup != null && userGroup == DimigoinUserType.teacher)) {
      pages.insert(2, CalendarPage());

      bottomNavigatorItem.insert(2, BottomNavigationBarItem(
        label: "일정",
        icon: SvgPicture.asset('assets/images/icons/calendar2_unselect.svg'),
      ));
    }

    for (int i=0; i<pages.length; i++) {
      String? label = bottomNavigatorItem[i].label;
      bottomNavigatorItem[i] = BottomNavigationBarItem(
        label: label,
        icon: SvgPicture.asset('assets/images/icons/${pageIcon[label]}_${_selectIndex == i ? "select" : "unselect"}.svg'),
      );
    }

>>>>>>> 92c83953fd75001b4a696ac8f90034ff2b2f9a90
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