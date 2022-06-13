import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dalgeurak/services/firestore_database.dart';
import 'package:dalgeurak/services/meal_info.dart';
import 'package:dalgeurak/services/shared_preference.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
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
  DalgeurakService dalgeurakService = DalgeurakService();
  MealInfo mealInfo = MealInfo();
  DateTime nowTime = DateTime.now();

  getMealPlanner() async {
    String? stringData = SharedPreference().getMealPlanner();
    ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());

    int weekFirstDay = (nowTime.day - (nowTime.weekday - 1));

    if (connectivityResult == ConnectivityResult.none) {
      Map correctFirstDay = mealInfo.getCorrectDate(weekFirstDay);
      correctFirstDay['month'] = correctFirstDay['month'].toString().length == 2 ? correctFirstDay['month'] : "0${correctFirstDay['month']}";
      correctFirstDay['day'] = correctFirstDay['day'].toString().length == 2 ? correctFirstDay['day'] : "0${correctFirstDay['day']}";

      if (stringData == null ||
        (json.decode(stringData))["1"]["date"] == null ||
        !((json.decode(stringData))["1"]["date"] as String).contains("${correctFirstDay['month']}-${correctFirstDay['day']}")) {
          Map data = await mealInfo.getMealPlannerFromDimigoHomepage(); //급식 정보 없다고 표시하기 위한 코드. 인터넷 연결 안되어 있으면 함수 Return 값이 급식 정보 없다고 뜸.
          return data;
      } else {
          return json.decode(stringData);
      }
    } else {
      mealListToStr(list) {
        String result = "";
        (list as List).forEach((element) => result = result + element + ", ");
        result = result.substring(0, (result.length - 2));
        return result;
      }

      List dataResponse = await mealInfo.getMealPlannerFromDimigoin();
      Map result = {};
      if (dataResponse.isEmpty) { //디미고인 서버에 급식 정보가 없을 경우
        if (stringData == null || (json.decode(stringData))["weekFirstDay"] != mealInfo.getCorrectDate(weekFirstDay)['day']) {
          result = await mealInfo.getMealPlannerFromDimigoHomepage(); //디미고 홈페이지에서 급식 정보 로딩
        } else {
          result = json.decode(stringData);
        }
      } else { //디미고인 서버에 급식 정보가 있을 경우
        dataResponse.forEach((element) => result[(dataResponse.indexOf(element)+1).toString()] = element);
        result.forEach((key, value) {
          result[key]['breakfast'] = mealListToStr(result[key]['breakfast']);
          result[key]['lunch'] = mealListToStr(result[key]['lunch']);
          result[key]['dinner'] = mealListToStr(result[key]['dinner']);
        });
      }


      SharedPreference().saveMealPlanner(result);

      return result;
    }
  }

  getMealKind(String lang, bool includeBreakfast) {
    MealType typeResult = dalgeurakService.getMealKind(includeBreakfast);
    return lang == "kor" ? typeResult.convertKorStr : typeResult.convertEngStr;
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