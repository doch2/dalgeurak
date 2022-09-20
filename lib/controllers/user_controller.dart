import 'package:dalgeurak/models/user.dart';
import 'package:dalgeurak/services/firestore_database.dart';
import 'package:dalgeurak/services/shared_preference.dart';
<<<<<<< HEAD
=======
import 'package:dalgeurak_widget_package/widgets/toast.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
>>>>>>> 92c83953fd75001b4a696ac8f90034ff2b2f9a90
import 'package:extended_image/extended_image.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
<<<<<<< HEAD
  Rx<UserModel> _userModel = UserModel().obs;
  UserModel get user => _userModel.value;
=======
  FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  DalgeurakToast dalgeurakToast = DalgeurakToast();
  DalgeurakService dalgeurakService = Get.find<DalgeurakService>();
  DimigoinAccount _dimigoinAccount = Get.find<DimigoinAccount>();

  Rxn<DimigoinUser?> _dimigoinUser = Rxn<DimigoinUser?>();

  DimigoinUser? get user => _dimigoinUser.value;
  set user(DimigoinUser? value) => _dimigoinUser.value = value;
>>>>>>> 92c83953fd75001b4a696ac8f90034ff2b2f9a90

  RxBool isAllowAlert = true.obs;
  RxList<DalgeurakWarning> warningList = [].cast<DalgeurakWarning>().obs;

<<<<<<< HEAD
  set user(UserModel value) => this._userModel.value = value;

  void clear() {
    _userModel.value = UserModel();
=======
  @override
  onInit() async {
    _dimigoinUser.bindStream(_dimigoinAccount.userChangeStream);

    _remoteConfig.setDefaults({"dienenManualUrl": "https://dimigo.in"});
    _remoteConfig.fetch();
    _remoteConfig.fetchAndActivate();
>>>>>>> 92c83953fd75001b4a696ac8f90034ff2b2f9a90
  }

  dynamic getProfileWidget(double _width) {
    if (user.profileImg == "") {
      return Icon(Icons.person_rounded, size: _width * 0.12);
    } else {
      return ExtendedImage.network(user.profileImg!, cache: true);
    }
  }

<<<<<<< HEAD
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
=======
  getUserWarningList() async {
    Map result = await dalgeurakService.getMyWarningList();
>>>>>>> 92c83953fd75001b4a696ac8f90034ff2b2f9a90

    if (result['success']) {
      warningList.value = (result['content'] as List).cast<DalgeurakWarning>();
    } else {
      dalgeurakToast.show("경고 목록을 불러오는데 실패하였습니다.");
    }
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

  getDienenManualFileUrl() => _remoteConfig.getString("dienenManualUrl");
}
