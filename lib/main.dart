import 'package:dalgeurak/controllers/bindings/main_binding.dart';
import 'package:dalgeurak/controllers/notification_controller.dart';
import 'package:dalgeurak/services/shared_preference.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/token_reference.dart';
import 'package:dalgeurak/utils/root.dart';
<<<<<<< HEAD
=======
import 'package:dalgeurak_meal_application/routes/pages.dart';
import 'package:dalgeurak_widget_package/dalgeurak_widget_package.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
>>>>>>> 92c83953fd75001b4a696ac8f90034ff2b2f9a90
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
<<<<<<< HEAD
  KakaoSdk.init(nativeAppKey: TokenReference().kakaoNativeKey);
=======
  await DimigoinFlutterPlugin().initializeApp();
  DalgeurakWidgetPackage().initializeApp();
>>>>>>> 92c83953fd75001b4a696ac8f90034ff2b2f9a90
  SharedPreference();
  await Jiffy.locale("ko");

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
<<<<<<< HEAD
        ),
        initialBinding: MainBinding(),
        home: Root());
=======
          initialBinding: MainBinding(),
          getPages: DalgeurakMealApplicationPages.pages,
          home: Root(notiController: notiController)),
    );
>>>>>>> 92c83953fd75001b4a696ac8f90034ff2b2f9a90
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
