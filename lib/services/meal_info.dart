import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:jiffy/jiffy.dart';

class MealInfo {
  final Dio _dio = Get.find<Dio>();
  DimigoinMeal _dimigoinMeal = DimigoinMeal();
  DalgeurakService _dalgeurakService = DalgeurakService();

  final String apiUrl = "https://www.dimigo.hs.kr/index.php?mid=school_cafeteria";
  DateTime nowTime = DateTime.now();

  getMealPlannerFromDimigoin() async => await _dimigoinMeal.getWeeklyMeal();

  Future<Map> getMealPlannerFromDimigoHomepage() async {
    preprocessingText(MealType mealType, String mealInfo) {
      if (mealInfo.contains("<")) { mealInfo = mealInfo.substring(0, mealInfo.indexOf("<")); }
      if (mealType == MealType.lunch && mealInfo.contains("석식")) { mealInfo = "급식 정보가 없습니다."; }

      return mealInfo
          .replaceAll("/", ", ")
          .replaceAll("&amp;amp;", ", ")
          .replaceAll("&amp;", ", ")
          .replaceAll("&lt;", "<")
          .replaceAll("&gt;", ">");
    }


    Map result = {};

    int weekFirstDay = (nowTime.day - (nowTime.weekday - 1));

    for (int i=weekFirstDay; i<weekFirstDay+7; i++) {
      int tempWeekDay = (i - weekFirstDay) + 1;
      Map correctDate = _dalgeurakService.getCorrectDate(i);

      try {
        Response response = await _dio.get(apiUrl, queryParameters: {"document_srl": await getMealPostNum(correctDate["month"], correctDate["day"])});

        String data = response.data.toString();

        result["$tempWeekDay"] = {};
        result["$tempWeekDay"]["breakfast"] = preprocessingText(MealType.breakfast, data.substring(data.lastIndexOf('xe_content"><p>') + 20, data.lastIndexOf("*중식")));
        result["$tempWeekDay"]["lunch"] = preprocessingText(MealType.lunch, data.substring(data.lastIndexOf("중식 : ") + 5, data.lastIndexOf("*석식")));
        result["$tempWeekDay"]["dinner"] = preprocessingText(MealType.dinner, data.substring(data.lastIndexOf("석식 : ") + 5, data.lastIndexOf('</p></div> </div>')));
      } catch (e) {
        if (result["$tempWeekDay"] == null) { result["$tempWeekDay"] = {}; }
        if (result["$tempWeekDay"]["breakfast"] == null) { result["$tempWeekDay"]["breakfast"] = "급식 정보가 없습니다."; }
        if (result["$tempWeekDay"]["lunch"] == null) { result["$tempWeekDay"]["lunch"] = "급식 정보가 없습니다."; }
        if (result["$tempWeekDay"]["dinner"] == null) { result["$tempWeekDay"]["dinner"] = "급식 정보가 없습니다."; }
      }
    }

    result["weekFirstDay"] = _dalgeurakService.getCorrectDate(weekFirstDay)['day'];

    return result;
  }

  Future<String> getMealPostNum(int month, int day) async {
    Response response = await _dio.get(apiUrl, queryParameters: {"page": 1});

    String data = response.data.toString();
    int strIndex = data.indexOf("$month월 $day일 식단입니다");
    
    String postUrl = response.data.toString().substring(data.indexOf('https', strIndex-125), strIndex-2);
    
    return postUrl.substring(postUrl.indexOf("&document_srl=") + 14);
  }
}