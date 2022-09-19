import 'package:dalgeurak/services/shared_preference.dart';
import 'package:dalgeurak_widget_package/widgets/toast.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  DalgeurakToast dalgeurakToast = DalgeurakToast();
  DalgeurakService dalgeurakService = Get.find<DalgeurakService>();
  DimigoinAccount _dimigoinAccount = Get.find<DimigoinAccount>();

  Rxn<DimigoinUser?> _dimigoinUser = Rxn<DimigoinUser?>();

  DimigoinUser? get user => _dimigoinUser.value;
  set user(DimigoinUser? value) => _dimigoinUser.value = value;

  RxBool isAllowAlert = true.obs;
  RxList<DalgeurakWarning> warningList = [].cast<DalgeurakWarning>().obs;

  @override
  onInit() async {
    _dimigoinUser.bindStream(_dimigoinAccount.userChangeStream);

    _remoteConfig.setDefaults({"dienenManualUrl": "https://dimigo.in"});
    _remoteConfig.fetch();
    _remoteConfig.fetchAndActivate();
  }

  dynamic getProfileWidget(double _width) {
    if (user?.photos == null || user?.photos?.length == 0) {
      return Icon(Icons.person_rounded, size: _width * 0.12);
    } else {
      return ExtendedImage.network("${user?.photos![0]}", cache: true, width: _width * 0.3);
    }
  }

  getUserWarningList() async {
    Map result = await dalgeurakService.getMyWarningList();

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
