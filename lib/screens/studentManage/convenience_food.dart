import 'dart:ui';

import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:dalgeurak_meal_application/pages/meal_exception/controller.dart';
import 'package:dalgeurak_widget_package/widgets/blue_button.dart';
import 'package:dalgeurak_widget_package/widgets/student_list_tile.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'manage_page_tabbar.dart';


class ConvenienceFoodCheckInPage extends GetWidget<MealController> {
  ConvenienceFoodCheckInPage();

  @override
  Widget build(BuildContext context) {
    controller.managePageStudentListTileBtnColor.clear();
    controller.managePageStudentListTileBtnTextColor.clear();

    controller.getConvenienceFoodStudentList();


    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(width: Get.width),
                    Text("${controller.dalgeurakService.getMealKind(true).convertKor2Str} 간편식 체크인", style: pageTitle1),
                    Positioned(
                      left: Get.width * 0.06,
                      child: GestureDetector(onTap: () => Get.back(), child: Container(color: Colors.transparent, child: Icon(Icons.arrow_back_ios_rounded, size: 26))),
                    )
                  ],
                ),
                SizedBox(height: 27),
                Obx(() {
                  if (!(controller.isConvenienceFoodCheckInPageDataLoading.value)) {
                    List<Widget> tabBarWidgetList = [];

                    List<String> tabBarMenuList = ["샐러드", "샌드위치", "선식"];
                    List<String> tabBarMenuMealTypeList = ["아침", "저녁"];

                    for (String mealTypeStr in tabBarMenuMealTypeList) {
                      Map<ConvenienceFoodType, List<DalgeurakConvenienceFood>> foodList = controller.convenienceFoodCheckInPageData;
                      if (controller.managePageStudentListTileBtnColor.isEmpty) {
                        for (ConvenienceFoodType foodType in [ConvenienceFoodType.sandwich, ConvenienceFoodType.salad, ConvenienceFoodType.misu]) {
                          if ((foodList[foodType] as List).isNotEmpty) {
                            foodList[foodType]!.forEach((foodContent) {
                              tabBarMenuList.forEach((tabBarMenu) {
                                Map<int, Color> btnColorMap = {};
                                Map<int, Color> textColorMap = {};
                                if (controller.managePageStudentListTileBtnColor.keys.contains(tabBarMenu)) {
                                  btnColorMap.addAll(controller.managePageStudentListTileBtnColor[tabBarMenu]!);
                                  textColorMap.addAll(controller.managePageStudentListTileBtnTextColor[tabBarMenu]!);
                                }
                                btnColorMap.addAll({(foodContent).student!.id!: dalgeurakGrayOne});
                                textColorMap.addAll({(foodContent).student!.id!: dalgeurakGrayFour});

                                controller.managePageStudentListTileBtnColor.addAll({tabBarMenu: btnColorMap.obs});
                                controller.managePageStudentListTileBtnTextColor.addAll({tabBarMenu: textColorMap.obs});
                              });
                            });
                          }
                        }
                      }

                      tabBarWidgetList.add(ManagePageTabBar(
                        tabBarTitle: "convenienceFood_$mealTypeStr",
                        tabBarMenuList: tabBarMenuList,
                        tabBarMenuWidgetList: [
                          _getStudentListWidget(foodList[ConvenienceFoodType.salad]!.where((element) => (element.mealType! == (mealTypeStr == "아침" ? MealType.breakfast : MealType.dinner))).toList(), tabBarMenuList[0]),
                          _getStudentListWidget(foodList[ConvenienceFoodType.sandwich]!.where((element) => (element.mealType! == (mealTypeStr == "아침" ? MealType.breakfast : MealType.dinner))).toList(), tabBarMenuList[1]),
                          _getStudentListWidget(foodList[ConvenienceFoodType.misu]!.where((element) => (element.mealType! == (mealTypeStr == "아침" ? MealType.breakfast : MealType.dinner))).toList(), tabBarMenuList[2]),
                        ],
                      ));
                    }

                    return Expanded(
                      child: ManagePageTabBar(
                        tabBarTitle: "convenienceFood",
                        tabBarMenuList: tabBarMenuMealTypeList,
                        tabBarMenuWidgetList: tabBarWidgetList,
                      ),
                    );
                  } else {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(width: Get.width, height: Get.height * 0.835),
                        Center(child: CircularProgressIndicator()),
                      ],
                    );
                  }
                })
              ],
            )
        ),
      ),
    );
  }

  _getStudentListWidget(List<DalgeurakConvenienceFood> foodList, String tabBarMenuStr) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: ListView.builder(
          itemCount: foodList.length,
          itemBuilder: (context, index) {
            DateTime nowTime = DateTime.now();
            DalgeurakConvenienceFood foodContent = foodList[index];
            DimigoinUser selectStudent = foodContent.student!;


            List<DateTime> studentHistoryData = [];
            for (Map tempHistoryData in (controller.convenienceFoodCheckInPageHistoryData)) {
              if (tempHistoryData['student'] == selectStudent.id!) { studentHistoryData = (tempHistoryData['date'] as List).cast<DateTime>(); }
            }

            List<Widget> weekDayTextWidget = [];
            for (int i=1; i<6; i++) {
              TextStyle textStyle = convenienceCheckInPageHistory;

              for (DateTime time in studentHistoryData) {
                if (controller.isSameDate(nowTime.subtract(Duration(days: nowTime.weekday - i)), time)) {
                  textStyle = textStyle.copyWith(color: dalgeurakBlueOne, fontWeight: FontWeight.w700);
                }
              }

              weekDayTextWidget.add(Text("${i.convertWeekDayKorStr}", style: textStyle));
            }

            MealType mealType = controller.dalgeurakService.getMealKind(true);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: Get.width * 0.62,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${index+1}", style: listIndex),
                      SizedBox(
                        width: 340,
                        height: 70,
                        child: StudentListTile(
                            isGroupTile: false,
                            selectStudent: selectStudent,
                            trailingWidget: SizedBox(
                              width: 124,
                              child: Row(
                                children: [
                                  (
                                      mealType == MealType.dinner ?
                                      GestureDetector(
                                          onTap: () => controller.registerFridayHomecoming(selectStudent.id!),
                                          child: Container(
                                            width: 55,
                                            height: 33,
                                            decoration: BoxDecoration(
                                                color: dalgeurakYellowOne,
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            child: Center(child: Text("금요귀가", style: studentSearchListTileBtn.copyWith(color: Colors.white, fontSize: 13))),
                                          )
                                      ) : SizedBox()
                                  ),
                                  const SizedBox(width: 8),
                                  (
                                    foodContent.mealType! == mealType ?
                                    GestureDetector(
                                        onTap: () => controller.checkInConvenienceFood(tabBarMenuStr, selectStudent.id!),
                                        child: Obx(() => Container(
                                          width: 55,
                                          height: 33,
                                          decoration: BoxDecoration(
                                              color: controller.managePageStudentListTileBtnColor[tabBarMenuStr]![selectStudent.id],
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: Center(child: Text("입장", style: studentSearchListTileBtn.copyWith(color: controller.managePageStudentListTileBtnTextColor[tabBarMenuStr]![selectStudent.id]))),
                                        ))
                                    ) : SizedBox()
                                  ),
                                ],
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: weekDayTextWidget,
                  ),
                ),
                Container(width: Get.width, child: Divider(color: dalgeurakGrayOne, thickness: 1.0))
              ],
            );
          },
        ),
      )
    ],
  );
}