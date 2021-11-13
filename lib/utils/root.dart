import 'package:dalgeurak/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dalgeurak/screens/auth/login.dart';

class Root extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.user?.uid != null) { controller.isLogin.value = true; }

        if (controller.isLogin.value) {
          return MainScreen();
        } else {
          return Login();
        }
      },
    );
  }
}
