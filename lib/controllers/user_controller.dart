import 'package:dalgeurak/models/user.dart';
import 'package:dalgeurak/services/firestore_database.dart';
import 'package:dalgeurak/services/shared_preference.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  Rx<UserModel> _userModel = UserModel().obs;
  UserModel get user => _userModel.value;

  RxBool isAllowAlert = true.obs;
  RxInt userTardyAmount = 0.obs;

  set user(UserModel value) => this._userModel.value = value;

  void clear() {
    _userModel.value = UserModel();
  }

  dynamic getProfileWidget(double _width) {
    if (user.profileImg == "") {
      return Icon(Icons.person_rounded, size: _width * 0.12);
    } else {
      return ExtendedImage.network(user.profileImg!, cache: true);
    }
  }

  String getModifyStudentId() { //수정된 학번 불러오기 ex) 161 -> 1601
    String result = user.studentId!.substring(0, 2);
    if (user.studentId!.substring(2).length > 1) { result = result + user.studentId!.substring(2); } else { result = result + "0${user.studentId!.substring(2)}"; }

    return result;
  }

  Future<Map<String, dynamic>?> getStudentQrCodeLog() async {
    return await FirestoreDatabase().getStudentQrCodeLog(user.id);
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
