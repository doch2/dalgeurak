import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dalgeurak/controllers/qrcode_controller.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/services/meal_info.dart';
import 'package:dalgeurak/services/shared_preference.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak_widget_package/widgets/dialog.dart';
import 'package:dalgeurak_widget_package/widgets/toast.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tab_bar/indicator/custom_indicator.dart';
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
  RxMap<int, int> nowClassMealSequence = (Map<int, int>.from({})).obs;
  bool isCreateRefreshTimer = false;
  final mealDelayTextController = TextEditingController();
  final mealPriceTextController = TextEditingController();
  late PageController mealPlannerPageController = PageController(initialPage: (DateTime.now().weekday-1));
  CustomTabBarController mealPlannerTabBarController = CustomTabBarController();
  Map<String, CustomTabBarController> managePageTabBarController = Map<String, CustomTabBarController>.from({});
  Map<String, PageController> managePagePageController = Map<String, PageController>.from({});
  RxMap<String, RxMap<int, Color>> managePageStudentListTileBtnColor = ({}.cast<String, RxMap<int, Color>>()).obs;
  RxMap<String, RxMap<int, Color>> managePageStudentListTileBtnTextColor = ({}.cast<String, RxMap<int, Color>>()).obs;
  List mealExceptionConfirmPageData = [].obs;
  RxBool isMealExceptionConfirmPageDataLoading = false.obs;
  Map<ConvenienceFoodType, List<DalgeurakConvenienceFood>> convenienceFoodCheckInPageData = {
    ConvenienceFoodType.sandwich: [],
    ConvenienceFoodType.salad: [],
    ConvenienceFoodType.misu: []
  };
  RxBool isConvenienceFoodCheckInPageDataLoading = false.obs;
  Rx<MealType> nowMealType = MealType.none.obs;

  UserController _userController = Get.find<UserController>();
  QrCodeController _qrCodeController = Get.find<QrCodeController>();
  DalgeurakService dalgeurakService = Get.find<DalgeurakService>();
  DalgeurakToast _dalgeurakToast = DalgeurakToast();
  DalgeurakDialog _dalgeurakDialog = DalgeurakDialog();
  MealInfo mealInfo = MealInfo();
  DateTime nowTime = DateTime.now();

  RxInt refreshTime = 0.obs;
  RxInt refreshMealTypeTime = 0.obs;

  @override
  onInit() {
    super.onInit();

    nowClassMealSequence.value = {
      1: 0,
      2: 0,
      3: 0,
    };


    refreshMealType();
  }

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

  refreshMealType() async {
    while (true) {
      await Future.delayed(
          Duration(seconds: 1),
              () async {
            if (refreshMealTypeTime.value == 0) {
              nowMealType.value = dalgeurakService.getMealKind(true);

              refreshMealTypeTime.value = 30;
            } else {
              refreshMealTypeTime.value = refreshMealTypeTime.value - 1;
            }
          }
      );
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

    Map nowMealSequenceData = await getNowMealSequence();
    nowClassMealSequence.forEach((key, value) {
      List mealSequence = this.mealSequence[mealType][key-1];

      if (key == nowMealSequenceData['content']['grade']) {
        nowClassMealSequence[key] = mealSequence.indexOf(nowMealSequenceData['content']['nowSequence']) + 1;
      } else {
        nowClassMealSequence[key] = 0;
      }
    });


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
      Map correctFirstDay = dalgeurakService.getCorrectDate(weekFirstDay);
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
        result = result.isNotEmpty ? result.substring(0, (result.length - 2)) : "급식 정보가 없습니다.";
        return result;
      }

      List dataResponse = await mealInfo.getMealPlannerFromDimigoin();
      Map result = {};
      if (dataResponse.isEmpty) { //디미고인 서버에 급식 정보가 없을 경우
        if (stringData == null || (json.decode(stringData))["weekFirstDay"] != dalgeurakService.getCorrectDate(weekFirstDay)['day']) {
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

  getConvenienceFoodStudentList() async {
    isConvenienceFoodCheckInPageDataLoading.value = true;

    Map result = await dalgeurakService.getConvenienceFoodStudentList();

    if (!result['success']) {
      _dalgeurakToast.show("간편식 명단 불러오기에 실패하였습니다.\n사유: ${result['content']}");
      isConvenienceFoodCheckInPageDataLoading.value = false;
      convenienceFoodCheckInPageData = {
        ConvenienceFoodType.sandwich: [],
        ConvenienceFoodType.salad: [],
        ConvenienceFoodType.misu: []
      };
      return;
    }

    Map<ConvenienceFoodType, List<dynamic>> tempData = Map<ConvenienceFoodType, List<dynamic>>.from(result['content']);
    tempData.forEach((key, value) => convenienceFoodCheckInPageData[key] = value.cast<DalgeurakConvenienceFood>());

    convenienceFoodCheckInPageData.forEach((key, value) {
      managePageStudentListTileBtnColor[key.convertKor] = Map<int, Color>.from({}).obs;
      managePageStudentListTileBtnTextColor[key.convertKor] = Map<int, Color>.from({}).obs;
      convenienceFoodCheckInPageData[key]?.forEach((e) {
        managePageStudentListTileBtnColor[key.convertKor]![e.student!.id!] = (e.isCheckin! ? dalgeurakGrayOne : dalgeurakBlueOne);
        managePageStudentListTileBtnTextColor[key.convertKor]![e.student!.id!] = (e.isCheckin! ? dalgeurakGrayFour : Colors.white);
      });
    });


    isConvenienceFoodCheckInPageDataLoading.value = false;
  }

  checkInConvenienceFood(String tabBarMenuStr, int studentUid) async {
    Map result = await dalgeurakService.checkInConvenienceFood(studentUid);

    _dalgeurakToast.show("간편식 체크인에 ${result['success'] ? "성공" : "실패"}하였습니다.${result['success'] ? "" : "\n실패 사유: ${result['content']}"}");

    getConvenienceFoodStudentList();
  }

  registerFridayHomecoming(int studentUid) async {
    Map result = await dalgeurakService.registerFridayHomecomingInConvenienceFood(studentUid);

    _dalgeurakToast.show("금요귀가 등록에 ${result['success'] ? "성공" : "실패"}하였습니다.${result['success'] ? "" : "\n실패 사유: ${result['content']}"}");
  }

  getMealExceptionStudentList(bool isEnterPage) async {
    isMealExceptionConfirmPageDataLoading.value = true;
    Map result = await dalgeurakService.getAllUserMealException(isEnterPage);

    if (!result['success']) { _dalgeurakToast.show("선후밥 명단 불러오기에 실패하였습니다. 인터넷 연결을 확인해주세요."); return; }

    List<DalgeurakMealException> originalData = (result['content'] as List).cast<DalgeurakMealException>();
    List<DalgeurakMealException> formattingData = [].cast<DalgeurakMealException>();
    originalData.forEach((element) {
      if (isEnterPage) {
        if (element.groupApplierUserList!.isNotEmpty) {
          element.groupApplierUserList!.forEach((element2) {
            Map exceptionContent = element.toJson();
            exceptionContent['applier'] = element2.toJson();
            exceptionContent['appliers'] = [];
            formattingData.add(DalgeurakMealException.fromJson(exceptionContent));
          });
        } else {
          Map exceptionContent = element.toJson();
          formattingData.add(DalgeurakMealException.fromJson(exceptionContent));
        }
      } else {
        if (element.statusType == MealExceptionStatusType.waiting) { formattingData.add(element); }
      }
    });

    mealExceptionConfirmPageData = formattingData;
    isMealExceptionConfirmPageDataLoading.value = false;
  }

  enterMealException(String tabBarMenuStr, int studentUid) async {
    Map result = await dalgeurakService.enterStudentMealException(studentUid);

    _dalgeurakToast.show("선후밥 입장 처리에 ${result['success'] ? "성공" : "실패"}하였습니다.${result['success'] ? "" : "\n실패 사유: ${result['content']}"}");

    if (result['success']) {
      managePageStudentListTileBtnColor[tabBarMenuStr]![studentUid] = dalgeurakBlueOne;
      managePageStudentListTileBtnTextColor[tabBarMenuStr]![studentUid] = Colors.white;
    }
  }

  changeMealExceptionStatus(String exceptionModelId, MealExceptionStatusType statusType, bool isEnterPage) async {
    Map result = {};
    if (statusType == MealExceptionStatusType.approve) {
      result = await dalgeurakService.changeMealExceptionStatus(statusType, exceptionModelId, "<수락시엔 클라이언트에서 사유를 받지 않습니다>");

      _dalgeurakToast.show("선밥 컨펌 처리에 ${result['success'] ? "성공" : "실패"}하였습니다.${result['success'] ? "" : "\n실패 사유: ${result['content']}"}");

      if (result['success']) { getMealExceptionStudentList(isEnterPage); }
    } else {
      _dalgeurakDialog.showTextField((reasonText) async {
        result = await dalgeurakService.changeMealExceptionStatus(statusType, exceptionModelId, reasonText);

        _dalgeurakToast.show("선밥 컨펌 처리에 ${result['success'] ? "성공" : "실패"}하였습니다.${result['success'] ? "" : "\n실패 사유: ${result['content']}"}");

        if (result['success']) { getMealExceptionStudentList(isEnterPage); }
      });
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
    Map result2 = await dalgeurakService.setMealSequence(2, mealType, sequenceMap[2]);

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

  getStudentWarningList(int studentUid) async {
    Map result = await dalgeurakService.getStudentWarningList(studentUid);

    if (result['success']) {
      return (result['content'] as List).cast<DalgeurakWarning>();
    } else {
      _dalgeurakToast.show("경고 목록을 불러오는데 실패하였습니다."); return;
    }
  }

  giveStudentWarning(int studentUid, List warningType, String reason) async {
    Map result = await dalgeurakService.giveWarningToStudent(studentUid, warningType, reason);

    if (result['success']) {
      _dalgeurakToast.show("경고 등록에 성공하였습니다!");
      Get.back();
    } else {
      _dalgeurakToast.show("경고 등록에 실패하였습니다. ${result['message']}");
    }
  }
}