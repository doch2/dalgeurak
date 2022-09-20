import 'package:dalgeurak/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dalgeurak/screens/auth/login.dart';

class Root extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    if (controller.user?.uid != null) { controller.isLogin.value = true; }
=======
    notiController.context = context;

    if (Get.find<AuthController>().user != null) { Get.find<AuthController>().logOutFirebaseAccount(); Future.delayed(Duration(milliseconds: 30), () => Get.to(VersionMigration())); }
>>>>>>> 92c83953fd75001b4a696ac8f90034ff2b2f9a90

    return Obx(
      () {
        if (controller.isLogin.value) {
          return MainScreen();
        } else {
          return Login();
        }
      },
    );
  }
}
