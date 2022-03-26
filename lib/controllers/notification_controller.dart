import 'package:dalgeurak/screens/widget_reference.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();

  late BuildContext context;
  Rx<FGBGType> serviceWorkType = FGBGType.foreground.obs;

  final Rxn<RemoteMessage> message = Rxn<RemoteMessage>();
  FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<bool> initialize() async {
    await _messaging.setAutoInitEnabled(true);

    await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: true,
    );



    // Android용 새 Notification Channel
    const AndroidNotificationChannel androidNotificationChannel = AndroidNotificationChannel(
      'dalgeurak_noti_channel',
      '어플리케이션 공지',
      description: "서비스의 공지를 위해 사용되는 알림 채널입니다.",
      importance: Importance.max,
    );

    // Notification Channel을 디바이스에 생성
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);

    await flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
            android: AndroidInitializationSettings('@drawable/logo'), iOS: IOSInitializationSettings()),
        onSelectNotification: (String? payload) async {});

    FirebaseMessaging.onMessage.listen((RemoteMessage rm) {
      message.value = rm;


      RemoteNotification? notification = rm.notification;
      AndroidNotification? android = rm.notification?.android;
      AppleNotification? apple = rm.notification?.apple;
      print(rm);

      if (notification != null && (android != null || apple != null)) {
        List content = json.decode(notification.body!);

        if (serviceWorkType.value == FGBGType.background) {
          String onlyMessage = "";
          content.forEach((element) => onlyMessage = onlyMessage + element['content']);

          flutterLocalNotificationsPlugin.show(
            0,
            notification.title,
            onlyMessage,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'dalgeurak_noti_channel',
                '어플리케이션 공지',
              ),
            ),
          );
        } else {
          showOverlayAlertWidget(content);
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data["type"] == "open_url") {
        _launchURL(message.data["content"]);
      }
    });

    _messaging.getInitialMessage().then((message) {
      try {
        if (message!.data["type"] == "open_url") {
          _launchURL(message.data["content"]);
        }
      } catch(e) {}
    });

    return true;
  }

  getFCMToken() async => await _messaging.getToken();

  showOverlayAlertWidget(List content) => WidgetReference(context: context).showAlert(content);

  void _launchURL(String _url) async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}