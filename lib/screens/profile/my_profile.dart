import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/screens/profile/qr_checkin_log.dart';
import 'package:dalgeurak/screens/profile/user_late_amount.dart';
import 'package:dalgeurak/screens/profile/application_info.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class MyProfile extends GetWidget<UserController> {
  MyProfile({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    AuthController authController = Get.find<AuthController>();

    List<Widget> menuWidgetList = [
      menuWidget([Text("알림허용", style: myProfileMenuTitle),
        FutureBuilder(
            future: controller.checkUserAllowAlert(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Obx(() => FlutterSwitch(
                  height: _height * 0.0325,
                  width: _width * 0.12,
                  padding: 2.0,
                  toggleSize: _width * 0.04,
                  borderRadius: 16.0,
                  activeColor: yellowOne,
                  value: controller.isAllowAlert.value,
                  onToggle: (value) => controller.setUserAllowAlert(value),
                ));
              } else if (snapshot.hasError) { //데이터를 정상적으로 불러오지 못했을 때
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(width: _width, height: _height * 0.4),
                    Center(child: Text("데이터를 정상적으로 불러오지 못했습니다. \n다시 시도해 주세요.", textAlign: TextAlign.center)),
                  ],
                );
              } else { //데이터를 불러오는 중
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(width: _width * 0.1, height: _height * 0.03),
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              }
            }
        )
      ]),
      Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => Get.to(ApplicationInfo(), transition: Transition.rightToLeft),
          child: menuWidget([Text("어플리케이션 정보", style: myProfileMenuTitle), Icon(Icons.navigate_next_sharp, size: _width * 0.09)]),
        ),
      ),
      Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => authController.deleteAccount(),
          child: menuWidget([Text("회원 탈퇴", style: myProfileMenuTitle), SizedBox()]),
        ),
      ),
      Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => authController.logOut(),
          child: menuWidget([Text("로그아웃", style: myProfileMenuTitle.copyWith(color: redThree)), SizedBox()]),
        ),
      )
    ];

    if (controller.user.group != "teacher") {
      menuWidgetList.insert(1, Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => Get.to(UserLateAmount(), transition: Transition.rightToLeft),
          child: menuWidget([Text("지각 횟수", style: myProfileMenuTitle), Icon(Icons.navigate_next_sharp, size: _width * 0.09)]),
        ),
      ));
      menuWidgetList.insert(2, Material(
          color: Colors.white,
          child: InkWell(
            onTap: () => Get.to(QrCheckInLog(), transition: Transition.rightToLeft),
            child: menuWidget([Text("QR 로그", style: myProfileMenuTitle), Icon(Icons.navigate_next_sharp, size: _width * 0.09)]),
          ),
        )
      );
    }

    return Scaffold(
      backgroundColor: blueThree,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: _height * 0.075,
              left: _width * 0.05,
              child: Text("내 정보", style: myProfileTitle),
            ),
            Positioned(
              top: _height * 0.165,
              left: _width * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: _width * 0.095,
                    child: ClipRRect(
                      child: controller.getProfileWidget(_width),
                      borderRadius: BorderRadius.circular(180.0),
                    ),
                  ),
                  SizedBox(width: _width * 0.04),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.user.name!,
                        style: myProfileName,
                      ),
                      Text(
                        controller.user.studentId == '000' ? '선생님' : "${controller.user.studentId!.substring(0, 1)}학년 ${controller.user.studentId!.substring(1, 2)}반 ${controller.user.studentId!.substring(2)}번",
                        style: myProfileStudentId
                      )
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: _width,
                height: _height * 0.62,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13)),
                  color: Colors.white
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: menuWidgetList
                )
              )
            )
          ],
        )
      ),
    );
  }

  SizedBox menuWidget(List<Widget> childWidget) {
    return
      SizedBox(
        height: _height * 0.1,
        width: _width * 0.8,
        child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: childWidget,
            )
        ),
      );
  }
}