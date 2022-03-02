import 'package:dalgeurak/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/screens/auth/login.dart';

class Root extends GetWidget<UserController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.user?.id != null) {
          return MainScreen();
        } else {
          return Login();
        }
      },
    );
  }
}
