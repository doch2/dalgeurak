import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../themes/color_theme.dart';
import '../../../themes/text_theme.dart';

enum LiveMealSequenceMode {
  blue,
  white
}

extension LiveMealSequenceModeExtension on LiveMealSequenceMode {
  Color get convertContainerColor {
    switch (this) {
      case LiveMealSequenceMode.blue: return dalgeurakBlueOne;
      case LiveMealSequenceMode.white: return Colors.white;
      default: return Colors.transparent;
    }
  }

  Color get convertAssetColor {
    switch (this) {
      case LiveMealSequenceMode.blue: return Colors.white;
      case LiveMealSequenceMode.white: return dalgeurakBlueOne;
      default: return Colors.transparent;
    }
  }
}

class LiveMealSequence extends GetWidget<MealController> {
  LiveMealSequenceMode mealSequenceMode;
  int? checkGradeNum;

  LiveMealSequence({required this.mealSequenceMode, this.checkGradeNum});


  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();

    checkGradeNum ??= userController.user?.gradeNum;

    return Container(
      height: Get.height * 0.18,
      width: 350,
      margin: EdgeInsets.only(top: Get.height * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: mealSequenceMode.convertContainerColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: Get.height * 0.02),
          SizedBox(
            width: 280,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "${userController.user?.userType == DimigoinUserType.teacher ? "$checkGradeNum학년 " : ""}급식 순서",
                    style: homeMealSequenceTitle.copyWith(color: mealSequenceMode.convertAssetColor)
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 264,
            child: Obx(() {
              Map mealSequence = controller.mealSequence;
              Map mealTime = controller.mealTime;

              String mealType = controller.dalgeurakService.getMealKind(false).convertEngStr;

              
              if (mealSequence.isEmpty || mealTime["extra${mealType[0].toUpperCase()}${mealType.substring(1)}"] == null) { return Center(child: Text("로딩중입니다..", style: TextStyle(color: mealSequenceMode.convertAssetColor))); }
              List userGradeMealSequence = mealSequence[mealType][checkGradeNum!-1];
              List userGradeMealTime = mealTime["extra${mealType[0].toUpperCase()}${mealType.substring(1)}"][checkGradeNum!-1];

              List<Widget> widgetList = [];
              for (int i=1; i<=6; i++) {
                bool isOn = ((controller.nowClassMealSequence.value == i) ? true : false);

                widgetList.add(Container(
                    width: 26,
                    height: 39,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Positioned(
                            top: -9,
                            child: isOn ? Icon(Icons.arrow_drop_down, color: mealSequenceMode.convertAssetColor) : SizedBox(),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${userGradeMealSequence[i-1]}반", style: homeMealSequenceClass.copyWith(color: mealSequenceMode.convertAssetColor)),
                              SizedBox(height: 3),
                              Text(isOn ? "배식중" : "${userGradeMealTime[i-1].toString().substring(0, 2)}:${userGradeMealTime[i-1].toString().substring(2)}", style: homeMealSequenceClassTime.copyWith(color: mealSequenceMode.convertAssetColor))
                            ],
                          ),
                        ]
                    )
                ));
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widgetList,
              );
            }),
          ),
          SizedBox(height: Get.height * 0.0075),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                width: 290,
                height: 10,
                decoration: BoxDecoration(
                    color: blueFive,
                    borderRadius: BorderRadius.circular(14.5)
                ),
              ),
              Obx(() => AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: (310 / 6) * controller.nowClassMealSequence[checkGradeNum]!,
                height: 10,
                decoration: BoxDecoration(
                    color: yellowFive,
                    borderRadius: BorderRadius.circular(14.5)
                ),
              )),
            ],
          )
        ],
      ),
    );
  }

}