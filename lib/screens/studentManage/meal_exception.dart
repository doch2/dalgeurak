import 'dart:ui';

import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:dalgeurak_meal_application/pages/meal_exception/controller.dart';
import 'package:dalgeurak_widget_package/widgets/blue_button.dart';
import 'package:dalgeurak_widget_package/widgets/student_list_tile.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'manage_page_tabbar.dart';


enum MealExceptionPageMode {
  list,
  confirm
}

extension MealExceptionPageModeExtension on MealExceptionPageMode {
  String get convertStr {
    switch (this) {
      case MealExceptionPageMode.list: return "선후밥 명단";
      case MealExceptionPageMode.confirm: return "선밥 컨펌";
      default: return "";
    }
  }
}

class MealExceptionPage extends GetWidget<MealController> {
  MealExceptionPageMode pageMode;

  MealExceptionPage({required this.pageMode});

  @override
  Widget build(BuildContext context) {
    controller.managePageStudentListTileBtnColor.clear();
    controller.managePageStudentListTileBtnTextColor.clear();

    controller.getMealExceptionStudentList(pageMode==MealExceptionPageMode.list);


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
                    Text(pageMode.convertStr, style: pageTitle1),
                    Positioned(
                      left: Get.width * 0.06,
                      child: GestureDetector(onTap: () => Get.back(), child: Container(color: Colors.transparent, child: Icon(Icons.arrow_back_ios_rounded, size: 26))),
                    )
                  ],
                ),
                SizedBox(height: 32),
                Obx(() {
                  if (!(controller.isMealExceptionConfirmPageDataLoading.value)) {
                    List<DalgeurakMealException> exceptionList = controller.mealExceptionConfirmPageData.cast<DalgeurakMealException>();


                    List<String> tabBarMenuList = ["점심", "저녁"];

                    DateTime nowTime = DateTime.now();
                    List<String> tabBarWeekDayMenuList = [];
                    List<Widget> tabBarWeekDayWidgetList = [];
                    for (int i=1; i<6; i++) {
                      tabBarWeekDayMenuList.add(i.convertWeekDayKorStr);

                      tabBarWeekDayWidgetList.add(
                        ManagePageTabBar(
                          tabBarTitle: "exceptionList_$i",
                          tabBarMenuList: tabBarMenuList,
                          tabBarMenuWidgetList: [
                            _getStudentListWidget(exceptionList, MealType.lunch, tabBarMenuList[0], nowTime.subtract(Duration(days: nowTime.weekday - i))),
                            _getStudentListWidget(exceptionList, MealType.dinner, tabBarMenuList[1], nowTime.subtract(Duration(days: nowTime.weekday - i)))
                          ],
                        )
                      );
                    }

                    if (controller.managePageStudentListTileBtnColor.isEmpty) {
                      exceptionList.forEach((exceptionContent) {
                        tabBarMenuList.forEach((tabBarMenu) {
                          Map<int, Color> btnColorMap = {};
                          Map<int, Color> textColorMap = {};
                          if (controller.managePageStudentListTileBtnColor.keys.contains(tabBarMenu)) {
                            btnColorMap.addAll(controller.managePageStudentListTileBtnColor[tabBarMenu]!);
                            textColorMap.addAll(controller.managePageStudentListTileBtnTextColor[tabBarMenu]!);
                          }
                          btnColorMap.addAll({(exceptionContent).applierUser!.id!: dalgeurakGrayOne});
                          textColorMap.addAll({(exceptionContent).applierUser!.id!: dalgeurakGrayFour});

                          controller.managePageStudentListTileBtnColor.addAll({tabBarMenu: btnColorMap.obs});
                          controller.managePageStudentListTileBtnTextColor.addAll({tabBarMenu: textColorMap.obs});
                        });
                      });
                    }


                    return Expanded(
                      child: ManagePageTabBar(
                        tabBarTitle: "exceptionMainList",
                        tabBarMenuList: tabBarWeekDayMenuList,
                        tabBarMenuWidgetList: tabBarWeekDayWidgetList
                      )
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

  _getStudentListWidget(List<DalgeurakMealException> mealExceptionList, MealType mealType, String tabBarMenuStr, DateTime dateTime) {
    studentListView(List<DalgeurakMealException> mealExceptionList) => SizedBox(
      width: Get.width,
      height: mealExceptionList.length * 75,
      child: ListView.builder(
        itemCount: mealExceptionList.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          DalgeurakMealException mealExceptionContent = mealExceptionList[index];
          DimigoinUser selectStudent = mealExceptionContent.applierUser!;

          return StudentListTile(
              isGroupTile: mealExceptionContent.groupApplierUserList!.isNotEmpty,
              selectStudent: selectStudent,
              groupStudentAmount: (mealExceptionContent.groupApplierUserList!.length-1),
              trailingWidget: (
                pageMode == MealExceptionPageMode.list ?
                (
                  controller.isSameDate(mealExceptionContent.date!, DateTime.now()) ?
                  GestureDetector(
                      onTap: () => controller.enterMealException(tabBarMenuStr, selectStudent.id!),
                      child: Obx(() => Container(
                        width: Get.width * 0.15,
                        height: Get.height * 0.045,
                        decoration: BoxDecoration(
                            color: controller.managePageStudentListTileBtnColor[tabBarMenuStr]![selectStudent.id],
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Center(child: Text("입장", style: studentSearchListTileBtn.copyWith(color: controller.managePageStudentListTileBtnTextColor[tabBarMenuStr]![selectStudent.id]))),
                      ))
                  ) : SizedBox()
                ) :
                SizedBox(
                  width: 125,
                  height: 60,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => controller.changeMealExceptionStatus(mealExceptionContent.id!, MealExceptionStatusType.reject, pageMode==MealExceptionPageMode.list),
                          child: BlueButton(content: "거절", isLong: false, isSmall: true, isFill: false, isDisable: false, isTiny: true)
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                          onTap: () => controller.changeMealExceptionStatus(mealExceptionContent.id!, MealExceptionStatusType.approve, pageMode==MealExceptionPageMode.list),
                          child: BlueButton(content: "수락", isLong: false, isSmall: true, isFill: true, isDisable: false, isTiny: true)
                      ),
                    ],
                  ),
                )
              )
          );
        },
      ),
    );


    List<DalgeurakMealException> firstExceptionList = [].cast<DalgeurakMealException>();
    List<DalgeurakMealException> lastExceptionList = [].cast<DalgeurakMealException>();
    mealExceptionList.forEach((element) {
      if (element.mealType! == mealType && (pageMode == MealExceptionPageMode.confirm || controller.isSameDate(element.date!, dateTime))) {
        (element.exceptionType == MealExceptionType.first ? firstExceptionList.add(element) : lastExceptionList.add(element));
      }
    });

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 44),
              Text("선밥 ${firstExceptionList.length}명", style: mealExceptionList_exceptionType),
            ],
          ),
          Container(width: Get.width, child: Divider(color: dalgeurakGrayOne, thickness: 1.0)),
          studentListView(firstExceptionList),
          (
            pageMode == MealExceptionPageMode.list ?
              Column(
                children: [
                  SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(width: 44),
                      Text("후밥 ${lastExceptionList.length}명", style: mealExceptionList_exceptionType),
                    ],
                  ),
                  Container(width: Get.width, child: Divider(color: dalgeurakGrayOne, thickness: 1.0)),
                  studentListView(lastExceptionList),
                ],
              )
              : SizedBox()
          )
        ],
      ),
    );
  }
}