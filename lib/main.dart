import 'package:dalgeurak/controllers/bindings/main_binding.dart';
import 'package:dalgeurak/controllers/notification_controller.dart';
import 'package:dalgeurak/services/remote_config.dart';
import 'package:dalgeurak/services/shared_preference.dart';
import 'package:dalgeurak/services/upgrader.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/token_reference.dart';
import 'package:dalgeurak/utils/root.dart';
import 'package:dalgeurak_meal_application/routes/pages.dart';
import 'package:dalgeurak_widget_package/dalgeurak_widget_package.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(options: FIREBASEOPTION);
  } else {
    await Firebase.initializeApp();
  }
  Get.put<RemoteConfigService>(RemoteConfigService());
  await DimigoinFlutterPlugin().initializeApp(dimigoStudentAPIAuthToken: DIMIGO_STUDENTAPI_AUTHTOKEN);
  DalgeurakWidgetPackage().initializeApp();
  SharedPreference();
  await Jiffy.locale("ko");
  if (!kIsWeb) { await Get.putAsync<UpgraderService>(() => UpgraderService().init()); }

  NotificationController _notiController = Get.put<NotificationController>(NotificationController(), permanent: true);
  await _notiController.initialize();

  if (!kIsWeb) { await Get.putAsync<UpgraderService>(() => UpgraderService().init()); }


  runApp(MyApp(notiController: _notiController));
}

class MyApp extends StatelessWidget {
  late NotificationController notiController;
  MyApp({required this.notiController});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));

    return FlutterWebFrame(
      builder: (context) => FGBGNotifier(
        onEvent: (event) {
          notiController.serviceWorkType.value = event;
        },
        child: GetMaterialApp(
            title: "달그락",
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
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
            ],
            initialBinding: MainBinding(),
            getPages: DalgeurakMealApplicationPages.pages,
            home: Root(notiController: notiController)),
      ),
      maximumSize: Size(475.0, 812.0),
      enabled: false,
      backgroundColor: Colors.white,
    );
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
