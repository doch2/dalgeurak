import 'dart:convert';

import 'package:dalgeurak/services/firestore_database.dart';
import 'package:dalgeurak/services/meal_info.dart';
import 'package:dalgeurak/services/shared_preference.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

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
  RxBool userNotEatMeal = false.obs;
  RxString mealWaitStatus = "initData".obs;
  RxString mealWaitStatusInSetDialog = "initData".obs;
  RxInt mealSequence = 0.obs;
  RxInt mealClassSequenceInSetDialog = 0.obs;
  Map classLeftPeople = {};

  FirestoreDatabase firestoreDatabase = FirestoreDatabase();
  MealInfo mealInfo = MealInfo();
  DateTime nowTime = DateTime.now();

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

  getMealKind(String resultKind, bool includeBreakfast) { //kor, eng
    String nowMinute = DateTime.now().minute.toString(); if (int.parse(nowMinute) < 10) { nowMinute = "0$nowMinute"; }
    int nowTime = int.parse("${DateTime.now().hour}$nowMinute");

    String mealKind = "";
    if ((nowTime < 0830 || nowTime >= 2000) && includeBreakfast) {
      if (resultKind == "kor") {
        mealKind = "아침";
      } else {
        mealKind = "breakfast";
      }
    } else if (nowTime < 1400 || nowTime >= 2000) {
      if (resultKind == "kor") {
        mealKind = "점심";
      } else {
        mealKind = "lunch";
      }
    } else if (nowTime < 2000) {
      if (resultKind == "kor") {
        mealKind = "저녁";
      } else {
        mealKind = "dinner";
      }
    }

    return mealKind;
  }

  getMealTime() async {
    String mealKind = getMealKind("eng", false);

    userMealTime.value = await firestoreDatabase.getUserMealTime(mealKind);
  }

  isUserNotEatMeal() async => await firestoreDatabase.getStudentIsNotEatMeal();

  setUserIsNotEatMeal(bool value) async {
    userNotEatMeal.value = value;
    FirestoreDatabase().setStudentIsNotEatMeal();
  }

  getMealWaitStatus() async => mealWaitStatus.value = (await firestoreDatabase.getMealWaitStatus());

  setMealWaitStatus(String mealStatus) async {
    await firestoreDatabase.setMealWaitStatus(mealStatus);
    mealWaitStatus.value = mealStatus;
  }

  getMealSequence() async => mealSequence.value = (await firestoreDatabase.getMealSequence());

  setMealSequence(int mealSequence) async {
    await firestoreDatabase.setMealSequence(mealSequence);
    this.mealSequence.value = mealSequence;
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