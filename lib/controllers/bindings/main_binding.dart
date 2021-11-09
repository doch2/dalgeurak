import 'package:dalgeurak/controllers/mealplanner_controller.dart';
import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);

    Get.lazyPut(() => Dio());

    Get.lazyPut<MealPlannerController>(() => MealPlannerController());
  }
}
