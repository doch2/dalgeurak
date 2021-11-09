import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:jiffy/jiffy.dart';

class MealInfo {
  final Dio _dio = Get.find<Dio>();

  final String apiUrl = "https://www.dimigo.hs.kr/index.php?mid=school_cafeteria";
  DateTime nowTime = DateTime.now();

  Future<Map> getMealPlanner() async {
    Map result = {};

    int weekFirstDay = (nowTime.day - (nowTime.weekday - 1));

    for (int i=weekFirstDay; i<weekFirstDay+7; i++) {
      int tempWeekDay = (i - weekFirstDay) + 1;

      late int day, month;
      if (i < 1) {
        day = DateTime(nowTime.year, nowTime.month, 0).day - i.abs();
        month = (nowTime.month-1 < 1) ? 12 : nowTime.month-1;
      } else if (i > DateTime(nowTime.year, nowTime.month+1, 0).day) {
        day = i - DateTime(nowTime.year, nowTime.month+1, 0).day;
        month = (nowTime.month+1 > 12) ? 1 : nowTime.month+1;
      } else {
        day = i;
        month = nowTime.month;
      }

      Response response = await _dio.get(apiUrl, queryParameters: {"document_srl": await getMealPostNum(month, day)});

      String data = response.data.toString();

      result["$tempWeekDay"] = {};
      result["$tempWeekDay"]["breakfast"] = data.substring(data.indexOf('<meta name="description" content="*조식 : ') + 40, data.indexOf(" *중식")).replaceAll("/", ", ");
      result["$tempWeekDay"]["lunch"] = data.substring(data.indexOf("중식 : ") + 5, data.indexOf(" *석식")).replaceAll("/", ", ");
      result["$tempWeekDay"]["dinner"] = data.substring(data.indexOf("석식 : ") + 5, data.indexOf('" />', data.indexOf("석식 : "))).replaceAll("/", ", ");
    }

    result["weekNo"] = "${Jiffy().week}";
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