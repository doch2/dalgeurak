import 'package:dalgeurak/controllers/notification_controller.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/screens/auth/login_success.dart';
import 'package:dalgeurak_widget_package/widgets/toast.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  UserController userController = Get.find<UserController>();
  NotificationController _notificationController = Get.find<NotificationController>();
  FirebaseAuth authInstance = FirebaseAuth.instance;
  DimigoinAccount _dimigoinAccount = Get.find<DimigoinAccount>();
  DalgeurakService _dalgeurakService = Get.find<DalgeurakService>();
  DalgeurakToast _dalgeurakToast = DalgeurakToast();

  Rxn<User> _firebaseUser = Rxn<User>();
  User? get user => _firebaseUser.value;

  final userIdTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  RxMap isTextFieldsEmpty = {"username": true, "password": true}.obs;
  RxDouble successCheckIconSize = 0.0.obs;
  RxMap successCheckIconPositioned = {"top": 0.0, "left": 0.0}.obs;
  RxDouble btnContainerPositioned = 0.0.obs;
  RxDouble helloTextPositioned = 0.0.obs;
  RxMap subTitlePositioned = {"top": 0.0, "left": 0.0}.obs;


  @override
  onInit() async {
    _firebaseUser.bindStream(authInstance.authStateChanges());
    _firebaseUser.value = authInstance.currentUser;
  }

  void logInWithDimigoinAccount() async {
    Map loginResult = await _dimigoinAccount.login(userIdTextController.text, passwordTextController.text, true);

    if (loginResult['success']) {
      await _dalgeurakService.registerFCMToken(await _notificationController.getFCMToken());

      if (loginResult['content']['dalgeurakFirstLogin'] ?? true) {
        Get.to(LoginSuccess());
      }
    } else {
      _dalgeurakToast.show("로그인에 실패하였습니다. 다시 시도해주세요.");
    }
  }

  void logOut() async {
    await _dimigoinAccount.logout();

    _dalgeurakToast.show("로그아웃 되었습니다.");
  }

  logOutFirebaseAccount() async => await authInstance.signOut();

  loginSuccessScreenAnimate(double height, double width) {
    btnContainerPositioned.value = -(height * 0.07);
    helloTextPositioned.value = height * 0.6;
    subTitlePositioned['top'] = height * 0.5;
    subTitlePositioned['left'] = width * 0.434;
    successCheckIconPositioned["top"] = (height * 0.5);
    successCheckIconPositioned["left"] = (width * 0.5);


    Future.delayed(
        Duration(milliseconds: 20),
            () {
          successCheckIconSize.value = 0.75;
          successCheckIconPositioned["top"] = (height * 0.5) - (width * 0.75) / 2;
          successCheckIconPositioned["left"] = (width * 0.5) - (width * 0.75) / 2;
        }
    );

    Future.delayed(
        Duration(milliseconds: 1400),
            () {
          successCheckIconSize.value = 0.1;
          successCheckIconPositioned['top'] = height * 0.39;
          successCheckIconPositioned['left'] = width * 0.335;

          subTitlePositioned['top'] = height * 0.4;
        }
    );

    Future.delayed(
        Duration(milliseconds: 1800),
            () { helloTextPositioned.value = height * 0.45; }
    );

    Future.delayed(
        Duration(milliseconds: 2200),
            () { btnContainerPositioned.value = height * 0.1; }
    );
  }
}
