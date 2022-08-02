import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/screens/widgets/medium_menu_button.dart';
import 'package:dalgeurak/screens/widgets/simple_list_button.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

import '../widgets/window_title.dart';

class MyProfile extends GetWidget<UserController> {
  MyProfile({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: dalgeurakGrayOne,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: _height * 0.115,
              left: _width * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  WindowTitle(
                    subTitle: "${controller.user?.studentId}",
                    title: "${controller.user?.name}",
                  ),
                  SizedBox(width: 3),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => authController.logOut(),
                        child: SvgPicture.asset("assets/images/icons/logout.svg", width: 24, color: grayThree)
                      ),
                      SizedBox(height: 3)
                    ],
                  )
                ],
              )
            ),
            Positioned(
              top: _height * 0.065,
              right: -(_width * 0.125),
              child: Image.asset(
                "assets/images/home_flowerpot.png",
              ),
            ),
            Positioned(
              top: _height * 0.215,
              child: Column(
                children: [
                  Container(
                    width: _width * 0.897,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)
                    ),
                    margin: EdgeInsets.only(bottom: 15),
                    child: Center(
                      child: SizedBox(
                        width: _width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("알림 허용", style: myProfileAlert),
                            FutureBuilder(
                                future: controller.checkUserAllowAlert(),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return Obx(() => FlutterSwitch(
                                      height: 20,
                                      width: 41,
                                      padding: 3.0,
                                      toggleSize: 14,
                                      borderRadius: 21,
                                      activeColor: dalgeurakBlueOne,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: _width * 0.897,
                    height: 240,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    margin: EdgeInsets.only(bottom: 15),
                    child: Center(
                      child: SizedBox(
                        width: _width * 0.68,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  MediumMenuButton(
                                    iconName: "noticeCircle", title: "경고 횟수", subTitle: "3회",
                                    clickAction: () => print("onCLick"),
                                  ),
                                  MediumMenuButton(
                                    iconName: "foodBucket", title: "간편식", subTitle: "신청",
                                    clickAction: () => print("onCLick"),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  MediumMenuButton(
                                    iconName: "checkCircle_round", title: "입장 기록", subTitle: "체크",
                                    clickAction: () => print("onCLick"),
                                  ),
                                  MediumMenuButton(
                                    iconName: "signDocu", title: "선/후밥", subTitle: "신청",
                                    clickAction: () => print("onCLick"),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  MediumMenuButton(
                                    iconName: "twoTicket", title: "선밥권", subTitle: "사용",
                                    clickAction: () => print("onCLick"),
                                  ),
                                  MediumMenuButton(
                                    iconName: "cancel", title: "급식 취소", subTitle: "신청",
                                    clickAction: () => print("onCLick"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                  ),
                  Container(
                    width: _width * 0.897,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    margin: EdgeInsets.only(bottom: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SimpleListButton(title: "디넌 규정집", iconName: "page", clickAction: () => print("onClick")),
                        SimpleListButton(title: "문의하기", iconName: "headset", clickAction: () => print("onClick")),
                        SimpleListButton(title: "앱 정보", iconName: "info", clickAction: () => print("onClick")),
                      ],
                    )
                  ),
                ],
              ),
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