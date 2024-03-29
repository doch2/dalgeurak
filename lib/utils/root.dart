import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dalgeurak/screens/main_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/screens/auth/login.dart';
import 'package:upgrader/upgrader.dart';

import '../controllers/notification_controller.dart';
import '../screens/version_migration.dart';
import '../services/upgrader.dart';

class Root extends GetWidget<UserController> {
  late NotificationController notiController;
  Root({required this.notiController});

  @override
  Widget build(BuildContext context) {
    notiController.context = context;

    if (Get.find<AuthController>().user != null) { Get.find<AuthController>().logOutFirebaseAccount(); Future.delayed(Duration(milliseconds: 30), () => Get.to(VersionMigration())); }

    Widget rootWidget = Obx(
          () {
        if (controller.user?.id != null) {
          return MainScreen();
        } else {
          return Login();
        }
      },
    );

    return (kIsWeb ? rootWidget : UpgradeAlert(upgrader: Get.find<UpgraderService>().upgrader, child: rootWidget));
  }
}
