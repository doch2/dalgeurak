import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak_widget_package/widgets/window_title.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tab_bar/library.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../services/meal_info.dart';
import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';

class ManagePageTabBar extends StatefulWidget {
  List<String> tabBarMenuList = [];
  List<Widget> tabBarMenuWidgetList = [];
  ManagePageTabBar({required this.tabBarMenuList, required this.tabBarMenuWidgetList});

  @override
  _ManagePageTabBarState createState() => _ManagePageTabBarState(tabBarMenuList: tabBarMenuList, tabBarMenuWidgetList: tabBarMenuWidgetList);
}

class _ManagePageTabBarState extends State<ManagePageTabBar> {
  List<String> tabBarMenuList = [];
  List<Widget> tabBarMenuWidgetList = [];
  _ManagePageTabBarState({required this.tabBarMenuList, required this.tabBarMenuWidgetList});


  late MealController _mealController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _mealController = Get.find<MealController>();

    
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              color: dalgeurakGrayOne,
              borderRadius: BorderRadius.circular(25)
          ),
          width: 350,
          height: 42,
          child: Center(
            child: CustomTabBar(
              itemCount: tabBarMenuList.length,
              tabBarController: _mealController.managePageTabBarController,
              pageController: _mealController.managePagePageController,
              height: 40,
              width: 350,
              indicator: RoundIndicator(
                height: 36,
                color: Colors.white,
                top: 2.5,
                bottom: 2.5,
                left: 2.5,
                right: 2.5,
                radius: BorderRadius.circular(21),
              ),
              builder: getTabBarChild,
            ),
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: Get.width,
          height: Get.height-208,
          child: PageView.builder(
              controller: _mealController.managePagePageController,
              itemCount: tabBarMenuList.length,
              itemBuilder: (context, index) {
                return Center(child: tabBarMenuWidgetList[index]);
              }
          ),
        ),
      ],
    );
  }

  Widget getTabBarChild(BuildContext context, int index) {
    return TabBarItem(
      transform: ColorsTransform(
        highlightColor: Colors.black,
        normalColor: dalgeurakGrayThree,
        builder: (context, color) {
          return Container(
            alignment: Alignment.center,
            constraints: BoxConstraints(minWidth: (Get.width / 2.4)),
            child: Text(
              tabBarMenuList[index],
              style: (tabBarMenuList.length == 2 ? managePageTabBar_big.copyWith(color: color) : managePageTabBar_small.copyWith(color: color)),
            ),
          );
        }
      ),
      index: index
    );
  }
}
