import 'dart:ui';

import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:dalgeurak_widget_package/widgets/student_list_tile.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'manage_page_tabbar.dart';

class MealExceptionListPage extends GetWidget<MealController> {
  MealExceptionListPage({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    controller.managePageStudentListTileBtnColor.clear();
    controller.managePageStudentListTileBtnTextColor.clear();


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
                    Text("선후밥 명단", style: pageTitle1),
                    Positioned(
                      left: Get.width * 0.06,
                      child: GestureDetector(onTap: () => Get.back(), child: Container(color: Colors.transparent, child: Icon(Icons.arrow_back_ios_rounded, size: 26))),
                    )
                  ],
                ),
                SizedBox(height: 32),
                FutureBuilder(
                    future: controller.getMealExceptionStudentList(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        List<String> tabBarMenuList = ["점심", "저녁"];

                        List<DalgeurakMealException> exceptionList = (snapshot.data as List).cast<DalgeurakMealException>();
                        if (controller.managePageStudentListTileBtnColor.isEmpty) {
                          exceptionList.forEach((exceptionContent) {
                            tabBarMenuList.forEach((tabBarMenu) {
                              controller.managePageStudentListTileBtnColor.addAll({tabBarMenu: {(exceptionContent).applierUser!.id!: dalgeurakGrayOne}.obs});
                              controller.managePageStudentListTileBtnTextColor.addAll({tabBarMenu: {(exceptionContent).applierUser!.id!: dalgeurakGrayFour}.obs});
                            });
                          });
                        }

                        return ManagePageTabBar(
                          tabBarMenuList: tabBarMenuList,
                          tabBarMenuWidgetList: [
                            _getStudentListWidget(exceptionList, MealType.lunch, tabBarMenuList[0]),
                            _getStudentListWidget(exceptionList, MealType.dinner, tabBarMenuList[1])
                          ],
                        );
                      } else if (snapshot.hasError) { //데이터를 정상적으로 불러오지 못했을 때
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(width: _width, height: _height * 0.835),
                            Center(child: Text("데이터를 정상적으로 불러오지 못했습니다. \n다시 시도해 주세요.", textAlign: TextAlign.center)),
                          ],
                        );
                      } else { //데이터를 불러오는 중
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(width: _width, height: _height * 0.835),
                            Center(child: CircularProgressIndicator()),
                          ],
                        );
                      }
                    }
                ),
              ],
            )
        ),
      ),
    );
  }

  _getStudentListWidget(List<DalgeurakMealException> mealExceptionList, MealType mealType, String tabBarMenuStr) {
    List<DalgeurakMealException> firstExceptionList = [].cast<DalgeurakMealException>();
    List<DalgeurakMealException> lastExceptionList = [].cast<DalgeurakMealException>();
    mealExceptionList.forEach((element) {
      if (element.mealType! == mealType) {
        (element.exceptionType == MealExceptionType.first ? firstExceptionList.add(element) : lastExceptionList.add(element));
      }
    });

    studentListView(List<DalgeurakMealException> mealExceptionList) => SizedBox(
      width: Get.width,
      height: mealExceptionList.length * 75,
      child: ListView.builder(
        itemCount: mealExceptionList.length,
        itemBuilder: (context, index) {
          DalgeurakMealException mealExceptionContent = mealExceptionList[index];
          DimigoinUser selectStudent = mealExceptionContent.applierUser!;

          return StudentListTile(
              selectStudent: selectStudent,
              trailingWidget: GestureDetector(
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
              )
          );
        },
      ),
    );

    return Column(
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
    );
  }
}