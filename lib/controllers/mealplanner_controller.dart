import 'dart:convert';

import 'package:dalgeurak/services/meal_info.dart';
import 'package:dalgeurak/services/shared_preference.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class MealPlannerController extends GetxController {
  Map weekDay = {
    1: "월",
    2: "화",
    3: "수",
    4: "목",
    5: "금",
    6: "토",
    7: "일"
  };

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

}