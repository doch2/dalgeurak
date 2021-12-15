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

  getMealPlanner() async {
    String? stringData = SharedPreference().getMealPlanner();
    if (stringData == null || json.decode(stringData)["weekNo"] != "${Jiffy().week}") {
      Map data = await MealInfo().getMealPlanner();

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
    if (nowTime < 0830 || nowTime >= 2000) {
      if (resultKind == "kor") {
        mealKind = "아침";
      } else {
        mealKind = "breakfast";
      }
    } else if (nowTime < 1400) {
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

    userMealTime.value = await FirestoreDatabase().getUserMealTime(mealKind);
  }

  isUserNotEatMeal() async => await FirestoreDatabase().getStudentIsNotEatMeal();

  setUserIsNotEatMeal(bool value) async {
    userNotEatMeal.value = value;
    FirestoreDatabase().setStudentIsNotEatMeal();
  }
}