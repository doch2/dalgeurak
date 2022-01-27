import 'package:dalgeurak/controllers/bindings/main_binding.dart';
import 'package:dalgeurak/controllers/notification_controller.dart';
import 'package:dalgeurak/services/shared_preference.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/utils/root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreference();

  NotificationController _notiController = Get.put<NotificationController>(NotificationController(), permanent: true);
  await _notiController.initialize();


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));

    return GetMaterialApp(
      theme: ThemeData(
        accentColor: yellowFive,
        scrollbarTheme: ScrollbarThemeData(
            isAlwaysShown: true,
            thickness: MaterialStateProperty.all(6),
            thumbColor: MaterialStateProperty.all(yellowOne.withOpacity(0.8)),
            radius: Radius.circular(10),
            minThumbLength: 60),
      ),
        builder: (context, child) => Scaffold(
          // 화면 클릭 시, 키보드 숨기기
          body: GestureDetector(
            onTap: () {
              hideKeyboard(context);
            },
            child: child,
          ),
        ),
        initialBinding: MainBinding(),
        home: Root());
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
