import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/screens/meal_planner/meal_planner.dart';
import 'package:dalgeurak/screens/profile/my_profile.dart';
import 'package:dalgeurak/screens/home/home.dart';
import 'package:dalgeurak/screens/studentManage/admin_page.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../themes/text_theme.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();

}

class _MainScreenState extends State<MainScreen> {
  int _selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    DimigoinUserType? userGroup = Get.find<UserController>().user?.userType;
    List<DimigoinPermissionType>? userPermission = Get.find<UserController>().user?.permissions;

    Map pageIcon = {
      '홈': 'home',
      '급식표': 'calendar',
      '관리': 'signDocu',
      '내 정보': 'user'
    };

    List pages = [
      Home(),
      MealPlanner(),
      MyProfile()
    ];

    List<BottomNavigationBarItem> bottomNavigatorItem = [
      BottomNavigationBarItem(
        label: "홈",
        icon: SvgPicture.asset('assets/images/icons/home_select.svg'),
      ),
      BottomNavigationBarItem(
        label: "급식표",
        icon: SvgPicture.asset('assets/images/icons/calendar_unselect.svg'),
      ),
      BottomNavigationBarItem(
        label: "내 정보",
        icon: SvgPicture.asset('assets/images/icons/user_unselect.svg'),
      ),
    ];

    if ((userGroup != null && userGroup != DimigoinUserType.student) || userPermission!.contains(DimigoinPermissionType.dalgeurak)) {
      pages.insert(2, AdminPage());

      bottomNavigatorItem.insert(2, BottomNavigationBarItem(
          label: "관리",
          icon: SvgPicture.asset('assets/images/icons/signDocu_unselect.svg'),
      ));
    }

    for (int i=0; i<pages.length; i++) {
      String? label = bottomNavigatorItem[i].label;
      bottomNavigatorItem[i] = BottomNavigationBarItem(
        label: label,
        icon: SvgPicture.asset('assets/images/icons/${pageIcon[label]}_${_selectIndex == i ? "select" : "unselect"}.svg'),
      );
    }

    return Scaffold(
        extendBody: true,
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(topRight: Radius.circular(10),
              topLeft: Radius.circular(10)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: blueEight,
            unselectedItemColor: grayEleven,
            selectedLabelStyle: homeBottomNavigationBarLabel,
            unselectedLabelStyle: homeBottomNavigationBarLabel,
            currentIndex: _selectIndex,
            onTap: (int index) {
              setState(() {
                _selectIndex = index;
              });
            },
            items: bottomNavigatorItem,
          ),
        ),
        body: pages[_selectIndex]
    );
  }
}