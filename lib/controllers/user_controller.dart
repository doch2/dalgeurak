import 'package:dalgeurak/services/shared_preference.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  DalgeurakService dalgeurakService = Get.find<DalgeurakService>();

  DimigoinAccount _dimigoinAccount = Get.find<DimigoinAccount>();
  Rxn<DimigoinUser?> _dimigoinUser = Rxn<DimigoinUser?>();

  DimigoinUser? get user => _dimigoinUser.value;
  set user(DimigoinUser? value) => _dimigoinUser.value = value;

  RxBool isAllowAlert = true.obs;
  RxInt userTardyAmount = 0.obs;

  @override
  onInit() async {
    _dimigoinUser.bindStream(_dimigoinAccount.userChangeStream);
  }

  dynamic getProfileWidget(double _width) {
    if (user?.photos == null || user?.photos?.length == 0) {
      return Icon(Icons.person_rounded, size: _width * 0.12);
    } else {
      return ExtendedImage.network("${user?.photos![0]}", cache: true, width: _width * 0.3);
    }
  }

  getUserTotalTardyAmount(Map logData) {
    int result = 0;

    for (int monthIndex=0; monthIndex<logData.length; monthIndex++) {
      String month = logData.keys.elementAt(monthIndex);
      for (int dayIndex=0; dayIndex<logData[month].length; dayIndex++) {
        String day = logData[month].keys.elementAt(dayIndex);

        List mealKind = ['lunch', 'dinner'];
        for (int i=0; i<mealKind.length; i++) {
          if (logData[month][day][mealKind[i]] != null && logData[month][day][mealKind[i]]['mealStatus'] == "tardy") {
            result++;
          }
        }
      }
    }

    userTardyAmount.value = result;
  }

  checkUserAllowAlert() async {
    bool? isAllow = await SharedPreference().getAllowAlert();

    if (isAllow == null) {
      setUserAllowAlert(true);
    } else {
      isAllowAlert.value = isAllow;
    }

    return true;
  }

  setUserAllowAlert(bool isAllow) {
    SharedPreference().saveAllowAlert(isAllow);
    isAllowAlert.value = isAllow;
  }
}
