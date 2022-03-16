import 'dart:convert';

import 'package:dalgeurak/controllers/qrcode_controller.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/screens/widget_reference.dart';
import 'package:dalgeurak/services/firestore_database.dart';
import 'package:dalgeurak/services/meal_info.dart';
import 'package:dalgeurak/services/shared_preference.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MealController extends GetxController {
  Map weekDay = {
    1: "월",
    2: "화",
    3: "수",
    4: "목",
    5: "금",
    6: "토",
    7: "일"
  };

  RxString userMealTime = "로드 중..".obs;
  RxMap mealSequence = {}.obs;
  RxMap mealTime = {}.obs;
  Map classLeftPeople = {};
  Rx<MealStatusType> userMealStatus = MealStatusType.empty.obs;
  Rx<MealExceptionType> userMealException = MealExceptionType.normal.obs;
  RxInt nowClassMealSequence = 0.obs;
  bool isCreateRefreshTimer = false;
  final mealDelayTextController = TextEditingController();

  FirestoreDatabase firestoreDatabase = FirestoreDatabase();
  UserController _userController = Get.find<UserController>();
  QrCodeController _qrCodeController = Get.find<QrCodeController>();
  DalgeurakService dalgeurakService = DalgeurakService();
  WidgetReference widgetReference = WidgetReference();
  MealInfo mealInfo = MealInfo();
  DateTime nowTime = DateTime.now();

  RxInt refreshTime = 0.obs;

  Future<void> refreshTimer() async {
    try {
      while (true) {
        await Future.delayed(
            Duration(seconds: 1),
                () async {
              if (refreshTime.value == 0) {
                await refreshInfo();

                refreshTime.value = 30;
              } else {
                refreshTime.value = refreshTime.value - 1;
              }
            }
        );
      }
    } catch (e) { //중간에 로그아웃 되서 타이머가 오류가 났을 경우
      isCreateRefreshTimer = false;
    }
  }

  refreshInfo() async {
    await getMealSequence();
    await getMealTime();

    String mealType = dalgeurakService.getMealKind(false).convertEngStr;
    List mealSequence = this.mealSequence[mealType][(_userController.user?.gradeNum)!-1];
    List mealTime = this.mealTime[mealType][(_userController.user?.gradeNum)!-1];
    String userMealTempTime = mealTime[mealSequence.indexOf(_userController.user?.classNum)].toString();
    userMealTime.value = "${userMealTempTime.substring(0, 2)}시 ${userMealTempTime.substring(2)}분";
    nowClassMealSequence.value = mealSequence.indexOf((await getNowMealSequence())['content']) + 1;

    Map userInfo = await dalgeurakService.getUserMealInfo();
    if (userInfo['success']) {
    userMealStatus.value = userInfo['content']['mealStatus'];
    userMealException.value = userInfo['content']['exception'];
    _qrCodeController.setQrCodeData(userInfo['content']['QRkey']);
    } else {
    widgetReference.showToast("현재 정보를 불러오는데 실패했습니다. \n인터넷에 연결되어있는지 확인해주세요.");
    }
  }

  getMealPlanner() async {
    String? stringData = SharedPreference().getMealPlanner();
    int weekFirstDay = (nowTime.day - (nowTime.weekday - 1));

    if (stringData == null || (json.decode(stringData))["weekFirstDay"] != mealInfo.getCorrectDate(weekFirstDay)['day']) {
      Map data = await mealInfo.getMealPlanner();

      SharedPreference().saveMealPlanner(data);
      return data;
    } else {
      return json.decode(stringData);
    }
  }

  getMealSequence() async => mealSequence.value = (await dalgeurakService.getMealSequence())['content']['mealSequences'];

  getMealTime() async => mealTime.value = (await dalgeurakService.getMealTime())['content']['mealTimes'];

  getNowMealSequence() async => (await dalgeurakService.getNowSequenceClass());

  setDelayMealTime() async {
    int time = int.parse(mealDelayTextController.text);

    if (time.toString().length == 1 || time.toString().length == 2) {
      await dalgeurakService.setMealExtraTime(time);
      widgetReference.showToast("지연 설정이 정상적으로 완료되었습니다.");
      Get.back();
    } else {
      widgetReference.showToast("시간 포멧이 정상적이지 않습니다. 다시 시도해주세요.");
    }
  }

  getUserLeftMealTime() {
    MealStatusType mealStatus = userMealStatus.value;

    if (mealStatus == MealStatusType.beforeLunch && mealStatus == MealStatusType.beforeDinner) {
      int nowTimeHour = nowTime.hour;
      int nowTimeMinute = nowTime.minute;
      int leftTimeHour = int.parse(userMealTime.value.substring(0, 2)) - nowTimeHour;
      int leftTimeMinute = int.parse(userMealTime.value.substring(4, 6)) - nowTimeMinute;
      if (leftTimeHour == 0) { return "$leftTimeMinute분"; } else { return "$leftTimeHour시간 $leftTimeMinute분"; }
    } else {
      return "";
    }
  }

  getGradeLeftPeopleAmount() async {
    int result = 0;

    for (int grade=1; grade<=3; grade++) {
      int gradeLeftPeople = 0;
      classLeftPeople[grade] = {};
      for (int classNum=1; classNum<=6; classNum++) {
        classLeftPeople[grade][classNum] = (await firestoreDatabase.getLeftStudentAmount(grade, classNum));

        if (classLeftPeople[grade][classNum]["leftPeople"] != null) {
          result = result + (classLeftPeople[grade][classNum]["leftPeople"] as int);
          gradeLeftPeople = gradeLeftPeople + (classLeftPeople[grade][classNum]["leftPeople"] as int);
        }
      }

      classLeftPeople[grade]["totalPeople"] = gradeLeftPeople;
    }

    return result;
  }
}