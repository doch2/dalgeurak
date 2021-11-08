import 'package:dalgeurak/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/screens/auth/login.dart';

class Root extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        Get.put<UserController>(UserController());
        if (Get.find<AuthController>().user?.uid != null) {
          return MainScreen();
        } else {
          return Login();
        }
      },
    );
  }
}
