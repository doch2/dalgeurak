import 'dart:ui';

import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:dalgeurak_widget_package/widgets/student_list_tile.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../studentManage/manage_page_tabbar.dart';

class StudentApplicationStatus extends GetWidget<MealController> {
  StudentApplicationStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: Get.width * 0.06,
                      child: GestureDetector(onTap: () => Get.back(), child: Container(color: Colors.transparent, child: Icon(Icons.arrow_back_ios_rounded, size: 26))),
                    ),
                    SizedBox(width: Get.width),
                    Text("차주 간편식 신청 현황", style: pageTitle1),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: FutureBuilder(
                      future: controller.getAllConvenienceFoodInfo(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          List responseData = snapshot.data;


                          DateTime nowTime = DateTime.now();
                          List<String> tabBarWeekDayMenuList = ["아침", "저녁"];
                          List<Widget> tabBarWeekDayWidgetList = [];
                          for (String mealTypeStr in tabBarWeekDayMenuList) {
                            MealType mealType = mealTypeStr == "아침" ? MealType.breakfast : MealType.dinner;
                            List<String> tabBarMenuList = ["샐러드", "선식"];
                            if (mealType == MealType.breakfast) { tabBarMenuList.add("샌드위치"); }

                            List<Widget> widgetList = [];
                            for (String menuName in tabBarMenuList) {
                              List<DalgeurakConvenienceFood> convenienceList = (responseData.where((element) => (element['name'] == menuName && element['time'] == mealType.convertEngStr && controller.isSameDate(element['duration']['start'], nowTime.subtract(Duration(days: nowTime.weekday - 1))))).toList())[0]['applications'];

                              widgetList.add(getStudentListWidget(convenienceList));
                            }

                            tabBarWeekDayWidgetList.add(
                                ManagePageTabBar(
                                  tabBarTitle: "convenienceAppliList_${mealType.convertEngStr}",
                                  tabBarMenuList: tabBarMenuList,
                                  tabBarMenuWidgetList: widgetList,
                                )
                            );
                          }


                          return ManagePageTabBar(
                              tabBarTitle: "convenienceAppliList",
                              tabBarMenuList: tabBarWeekDayMenuList,
                              tabBarMenuWidgetList: tabBarWeekDayWidgetList
                          );
                        } else if (snapshot.hasError) { //데이터를 정상적으로 불러오지 못했을 때
                          print(snapshot.error);
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(width: Get.width, height: Get.height * 0.4),
                              Center(child: Text("데이터를 정상적으로 불러오지 못했습니다. \n다시 시도해 주세요.", textAlign: TextAlign.center)),
                            ],
                          );
                        } else { //데이터를 불러오는 중
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(width: Get.width, height: Get.height * 0.4),
                              Center(child: CircularProgressIndicator()),
                            ],
                          );
                        }
                      }
                  )
                )
              ],
            ),
          )
      ),
    );
  }

  getStudentListWidget(List<DalgeurakConvenienceFood> convenienceFoodList) => ListView.builder(
    itemCount: convenienceFoodList.length,
    itemBuilder: (context, index) {
      return StudentListTile(
        isGroupTile: false,
        selectStudent: convenienceFoodList[index].student!,
        trailingWidget: const SizedBox()
      );
    },
  );
}