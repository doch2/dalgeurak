import 'dart:convert';

import 'package:dalgeurak/services/firestore_database.dart';
import 'package:dalgeurak/services/meal_info.dart';
import 'package:dalgeurak/services/shared_preference.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
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
  RxInt studentClassMealSequence = 1.obs;
  Map classLeftPeople = {};

  FirestoreDatabase firestoreDatabase = FirestoreDatabase();
  DalgeurakService dalgeurakService = DalgeurakService();
  MealInfo mealInfo = MealInfo();
  DateTime nowTime = DateTime.now();

  RxInt refreshTime = 0.obs;
  bool isCreateRefreshTimer = false;

  Future<void> refreshTimer() async {
    try {
      while (true) {
        await Future.delayed(
            Duration(seconds: 1),
                () async {
              if (refreshTime.value == 0) {
                await getMealSequence();
                refreshTime.value = 60;
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

  getMealTime() async {
    String mealKind = dalgeurakService.getMealKind(false).convertEngStr;

    userMealTime.value = "1365"; //TODO API 추가되면 변경필요
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