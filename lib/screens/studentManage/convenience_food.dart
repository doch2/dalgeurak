import 'dart:ui';

import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:dalgeurak_widget_package/widgets/blue_button.dart';
import 'package:dalgeurak_widget_package/widgets/student_list_tile.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
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
                    Text("간편식 체크인", style: pageTitle1),
                    Positioned(
                      left: Get.width * 0.06,
                      child: GestureDetector(onTap: () => Get.back(), child: Container(color: Colors.transparent, child: Icon(Icons.arrow_back_ios_rounded, size: 26))),
                    )
                  ],
                ),
                SizedBox(height: 27),
                Obx(() {
                  if (!(controller.isConvenienceFoodCheckInPageDataLoading.value)) {
                    List<String> tabBarMenuList = ["샐러드", "샌드위치", "선식"];

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

                    return ManagePageTabBar(
                      tabBarMenuList: tabBarMenuList,
                      tabBarMenuWidgetList: [
                        _getStudentListWidget(foodList[ConvenienceFoodType.salad]!, tabBarMenuList[0]),
                        _getStudentListWidget(foodList[ConvenienceFoodType.sandwich]!, tabBarMenuList[1]),
                        _getStudentListWidget(foodList[ConvenienceFoodType.misu]!, tabBarMenuList[2]),
                      ],
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
            DalgeurakConvenienceFood foodContent = foodList[index];
            DimigoinUser selectStudent = foodContent.student!;

            return Column(
              children: [
                StudentListTile(
                    isGroupTile: false,
                    selectStudent: selectStudent,
                    trailingWidget: SizedBox(
                      width: 124,
                      child: Row(
                        children: [
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
                          ),
                          const SizedBox(width: 8),
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
                          ),
                        ],
                      ),
                    )
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