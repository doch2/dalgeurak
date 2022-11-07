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
  String tabBarTitle;
  List<String> tabBarMenuList = [];
  List<Widget> tabBarMenuWidgetList = [];
  ManagePageTabBar({required this.tabBarTitle, required this.tabBarMenuList, required this.tabBarMenuWidgetList});

  @override
  _ManagePageTabBarState createState() => _ManagePageTabBarState(tabBarTitle: tabBarTitle, tabBarMenuList: tabBarMenuList, tabBarMenuWidgetList: tabBarMenuWidgetList);
}

class _ManagePageTabBarState extends State<ManagePageTabBar> {
  String tabBarTitle;
  List<String> tabBarMenuList = [];
  List<Widget> tabBarMenuWidgetList = [];
  _ManagePageTabBarState({required this.tabBarTitle, required this.tabBarMenuList, required this.tabBarMenuWidgetList});


  late MealController _mealController;

  @override
  void initState() {
    super.initState();

    _mealController = Get.find<MealController>();

    (_mealController.managePageTabBarController)[tabBarTitle] = CustomTabBarController();
    (_mealController.managePagePageController)[tabBarTitle] = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              color: dalgeurakGrayOne,
              borderRadius: BorderRadius.circular(25)
          ),
          width: Get.width * 0.864,
          height: 42,
          child: Center(
            child: CustomTabBar(
              itemCount: tabBarMenuList.length,
              tabBarController: (_mealController.managePageTabBarController)[tabBarTitle],
              pageController: (_mealController.managePagePageController)[tabBarTitle]!,
              height: 40,
              width: Get.width * 0.864,
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
        Expanded(
          child: PageView.builder(
              controller: (_mealController.managePagePageController)[tabBarTitle]!,
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
            constraints: BoxConstraints(minWidth: (Get.width / (tabBarMenuList.length == 2 ? 2.4 : (tabBarMenuList.length == 5 ? 5.9 : 3.5)))),
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
