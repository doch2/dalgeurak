import 'dart:async';

import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak/screens/widget_reference.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:uni_links_nfc_support/uni_links_nfc_support.dart';
import 'package:url_launcher/url_launcher.dart';

class DeepLinkController extends GetxController {
  DalgeurakService? _dalgeurakService;
  StreamSubscription? _sub;

  bool _initialUriIsHandled = false;


  initialize() async {
    // In this example app this is an almost useless guard, but it is here to
    // show we are not going to call getInitialUri multiple times, even if this
    // was a weidget that will be disposed of (ex. a navigation route change).
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;

      try { //앱이 꺼져있을 시에 딥링크가 이루어졌을 경우
        final uri = await getInitialUri();
        if (uri == null) {
          print('no initial uri');
        } else {
          print('got initial uri: $uri');
          if (uri.toString().contains("checkin")) {
            _mealCheckIn();
          }
        }
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        print('falied to get initial uri');
      } on FormatException catch (err) {
        print('malformed initial uri');
      }
    }

    _sub = uriLinkStream.listen((Uri? uri) { //앱이 켜져있을 시에 딥링크가 이루어졌을 경우
      print('got uri: $uri');
      if (uri.toString().contains("checkin")) { _mealCheckIn(); }
    }, onError: (Object err) {
      print('got err: $err');
    });
  }

  _mealCheckIn() async {
    _dalgeurakService ??= DalgeurakService();
    String jwtToken = (await _dalgeurakService?.getUserMealInfo())['content']['QRkey'];

    Map result = await _dalgeurakService?.mealCheckInWithJWT(jwtToken);
    print(result);
    WidgetReference().showToast(result['content']);
  }
}