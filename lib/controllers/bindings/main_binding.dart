import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak/controllers/qrcode_controller.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dalgeurak/controllers/notification_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Dio());

    Get.put<UserController>(UserController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);

    Get.put<NotificationController>(NotificationController(), permanent: true);

    Get.put<QrCodeController>(QrCodeController());

    Get.lazyPut<MealController>(() => MealController());
  }
}
