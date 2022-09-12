import 'dart:ui';

import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:dalgeurak_meal_application/pages/meal_cancel/page.dart';
import 'package:dalgeurak_meal_application/routes/routes.dart';
import 'package:dalgeurak_widget_package/widgets/student_list_tile.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MealCancelConfirm extends GetWidget<MealController> {
  MealCancelConfirm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isAramark = Get.find<UserController>().user?.userId == "aramark";

    return Scaffold(
      backgroundColor: blueThree,
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
                  Column(
                    children: [
                      Text("${isAramark ? "급식실 " : "담임"}선생님", style: mealCancelConfirm_subTitle),
                      SizedBox(height: 4),
                      Text("급식 취소 컨펌", style: mealCancelConfirm_title)
                    ],
                  ),
                  Positioned(
                    left: Get.width * 0.06,
                    child: GestureDetector(onTap: () => Get.back(), child: Container(color: Colors.transparent, child: Icon(Icons.arrow_back_ios_rounded, size: 26))),
                  )
                ],
              ),
              SizedBox(
                height: Get.height * 0.7,
                child: FutureBuilder(
                    future: controller.dalgeurakService.getMealCancelApplicationList(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        List<DalgeurakMealCancel> mealCancelContentList = (snapshot.data['content']).cast<DalgeurakMealCancel>();

                        return SizedBox(
                          width: Get.width,
                          height: Get.height * 0.7,
                          child: ListView.builder(
                            itemCount: mealCancelContentList.length,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () => Get.toNamed(DalgeurakMealApplicationRoutes.MEALCANCEL, arguments: {"pageMode": MealCancelPageMode.changeStatus, "cancelContent": mealCancelContentList[index]}),
                              child: StudentListTile(
                                  selectStudent: mealCancelContentList[index].applierUser!,
                                  trailingWidget: Icon(Icons.arrow_forward_ios_rounded, size: 26)
                              ),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) { //데이터를 정상적으로 불러오지 못했을 때
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
          )
        ),
      ),
    );
  }
}