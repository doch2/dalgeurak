import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/screens/profile/myprofile_bottomsheet.dart';
import 'package:dalgeurak_meal_application/routes/routes.dart';
import 'package:dalgeurak_widget_package/widgets/dialog.dart';
import 'package:dalgeurak_widget_package/widgets/toast.dart';
import 'package:dalgeurak_widget_package/widgets/window_title.dart';
import 'package:dalgeurak/screens/widgets/medium_menu_button.dart';
import 'package:dalgeurak/screens/widgets/simple_list_button.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';

class MyProfile extends GetWidget<UserController> {
  MyProfile({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    AuthController authController = Get.find<AuthController>();

    MyProfileBottomSheet myProfileBottomSheet = MyProfileBottomSheet();
    DalgeurakDialog dalgeurakDialog = DalgeurakDialog();

    controller.getUserWarningList();


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
                                  Obx(() {
                                    int warningAmount = controller.warningList.length;

                                    return MediumMenuButton(
                                      iconName: "noticeCircle", title: "경고 횟수", subTitle: "$warningAmount회",
                                      clickAction: () => dalgeurakDialog.showList(
                                          "경고",
                                          "누적 $warningAmount회",
                                          "경고 기록",
                                          ListView.builder(
                                            itemCount: warningAmount,
                                            itemBuilder: (context, index) {
                                              DalgeurakWarning warning = controller.warningList[index];

                                              String warningTypeStr = "";
                                              warning.warningTypeList?.forEach((element) => warningTypeStr = warningTypeStr + element.convertKorStr + ", ");
                                              warningTypeStr = warningTypeStr.substring(0, warningTypeStr.length-2);

                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("${Jiffy(warning.date).format("MM.dd (E) a hh:mm")}", style: myProfile_warning_date),
                                                  SizedBox(height: 2),
                                                  Text("$warningTypeStr(${warning.reason})", style: myProfile_warning_reason),
                                                  SizedBox(height: 20),
                                                ],
                                              );
                                            }
                                          )
                                      ),
                                    );
                                  }),
                                  MediumMenuButton(
                                    iconName: "foodBucket", title: "간편식", subTitle: "신청",
                                    clickAction: () => Get.toNamed(DalgeurakMealApplicationRoutes.CONVENIENCEFOOD),
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
                                    clickAction: () => dalgeurakDialog.showList(
                                        "${controller.user?.name}", 
                                        "입장 기록", 
                                        "입장 기록", 
                                        null
                                    ),
                                  ),
                                  MediumMenuButton(
                                    iconName: "signDocu", title: "선/후밥", subTitle: "신청",
                                    clickAction: () => Get.toNamed(DalgeurakMealApplicationRoutes.MEALEXCEPTION),
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
                                    clickAction: () => DalgeurakToast().show("선밥권 기능은 현재 지원하지 않습니다."),
                                  ),
                                  MediumMenuButton(
                                    iconName: "cancel", title: "급식 취소", subTitle: "신청",
                                    clickAction: () => Get.toNamed(DalgeurakMealApplicationRoutes.MEALCANCEL),
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
                        SimpleListButton(title: "디넌 규정집", iconName: "page", clickAction: () => _launchURL(controller.getDienenManualFileUrl())),
                        SimpleListButton(title: "문의하기", iconName: "headset", clickAction: () => dalgeurakDialog.showInquiry()),
                        SimpleListButton(title: "앱 정보", iconName: "info", clickAction: () => myProfileBottomSheet.showApplicationInfo()),
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

  void _launchURL(String _url) async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}