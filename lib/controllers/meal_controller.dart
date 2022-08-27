import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dalgeurak/controllers/qrcode_controller.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/services/meal_info.dart';
import 'package:dalgeurak/services/shared_preference.dart';
import 'package:dalgeurak_widget_package/widgets/toast.dart';
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

  UserController _userController = Get.find<UserController>();
  QrCodeController _qrCodeController = Get.find<QrCodeController>();
  DalgeurakService dalgeurakService = Get.find<DalgeurakService>();
  DalgeurakToast _dalgeurakToast = DalgeurakToast();
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
    List mealTime = this.mealTime["extra${mealType[0].toUpperCase()}${mealType.substring(1)}"][(_userController.user?.gradeNum)!-1];
    String userMealTempTime = mealTime[mealSequence.indexOf(_userController.user?.classNum)].toString();
    userMealTime.value = "${userMealTempTime.substring(0, 2)}시 ${userMealTempTime.substring(2)}분";
    nowClassMealSequence.value = mealSequence.indexOf((await getNowMealSequence())['content']) + 1;

    Map userInfo = await dalgeurakService.getUserMealInfo();
    if (userInfo['success']) {
      userMealStatus.value = userInfo['content']['mealStatus'];
      userMealException.value = userInfo['content']['exception'];
      _qrCodeController.setQrCodeData(userInfo['content']['QRkey']);
    } else {
      _dalgeurakToast.show("현재 정보를 불러오는데 실패했습니다. \n인터넷에 연결되어있는지 확인해주세요.");
    }
  }

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

  getMealSequence() async => mealSequence.value = (await dalgeurakService.getMealSequence())['content']['mealSequences'];

  getMealTime() async => mealTime.value = (await dalgeurakService.getMealExtraTime())['content'];

  getNowMealSequence() async => (await dalgeurakService.getNowSequenceClass());

  setDelayMealTime() async {
    int time = int.parse(mealDelayTextController.text);

    if (time <= 30) {
      await dalgeurakService.setMealExtraTime(time);
      await getMealTime();

      return true;
    } else {
      return false;
    }
  }

  setMealSequence(MealType mealType, Map sequenceMap) async {
    Map result1 = await dalgeurakService.setMealSequence(1, mealType, sequenceMap[1]);
    Map result2 = await dalgeurakService.setMealSequence(2, mealType, sequenceMap[1]);

    Get.back();
    _dalgeurakToast.show("급식 순서 수정에 ${result1['success'] && result2['success'] ? "성공" : "실패"}하였습니다.");
  }

  setMealWaitingPlace(MealWaitingPlaceType placeType) async {
    Map result = await dalgeurakService.setMealWaitingPlace(placeType);

    Get.back();
    _dalgeurakToast.show("급식 대기 장소 수정에 ${result['success'] ? "성공" : "실패"}하였습니다.");
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

  getStudentList(bool isMust) async {
    String? stringData = SharedPreference().getStudentList();
    int weekFirstDay = (nowTime.day - (nowTime.weekday - 1));

    if (isMust || stringData == null || (json.decode(stringData))["weekFirstDay"] != mealInfo.getCorrectDate(weekFirstDay)['day']) {
      Map data = await dalgeurakService.getAllStudentList();

      if (data['success']) {
        SharedPreference().saveStudentList({"studentList": data['content'], "weekFirstDay": mealInfo.getCorrectDate(weekFirstDay)['day']});
        return data['content'];
      } else {
        _dalgeurakToast.show(data['content']);
      }
    } else {
      List originalData = (json.decode(stringData))['studentList'];
      List formattingData = [];
      originalData.forEach((element) => formattingData.add(DimigoinUser.fromJson(element)));

      return formattingData;
    }
  }

  giveStudentWarning(String studentObjId, List warningType, String reason) async {
    Map result = await dalgeurakService.giveWarningToStudent(studentObjId, warningType, reason);

    if (result['success']) {
      _dalgeurakToast.show("경고 등록에 성공하였습니다!");
      Get.back();
    } else {
      _dalgeurakToast.show("경고 등록에 실패하였습니다. ${result['message']}");
    }
  }
}