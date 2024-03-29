import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/screens/profile/myprofile_bottomsheet.dart';
import 'package:dalgeurak/screens/studentManage/application_blacklist.dart';
import 'package:dalgeurak/screens/studentManage/application_status.dart';
import 'package:dalgeurak/screens/studentManage/student_manage_dialog.dart';
import 'package:dalgeurak/services/remote_config.dart';
import 'package:dalgeurak_meal_application/pages/meal_cancel/page.dart';
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
    StudentManageDialog studentManageDialog = StudentManageDialog();

    controller.getUserWarningList();


    return Scaffold(
      backgroundColor: dalgeurakGrayOne,
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SizedBox(width: Get.width, height: 140),
                    Positioned(
                      top: _height * 0.05,
                      left: _width * 0.1,
                      child: WindowTitle(
                        subTitle: controller.user?.userType != DimigoinUserType.teacher ? "${controller.user?.gradeNum}학년 ${controller.user?.classNum}반" : (controller.user?.teacherRole ?? "등록 부서 없음"),
                        title: "${controller.user?.name}${controller.user?.userType != DimigoinUserType.teacher ? "" : " 선생님"}",
                      ),
                    ),
                    Positioned(
                      right: -(_width * 0.125),
                      child: Image.asset(
                        "assets/images/home_flowerpot.png",
                        height: 124,
                      ),
                    ),
                  ],
                ),
                Column(
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
                    (
                        controller.user?.userType! != DimigoinUserType.teacher ?
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
                                                clickAction: () => studentManageDialog.showWarningDialog(controller.warningList)
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
                                            clickAction: () => studentManageDialog.showCheckInRecordDialog(controller.user!.name!),
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
                                            clickAction: () => controller.dalgeurakToast.show("현재 공개된 기능이 아닙니다. 추후 공개 예정입니다."),//Get.toNamed(DalgeurakMealApplicationRoutes.MEALCANCEL, arguments: {"pageMode": MealCancelPageMode.application}),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ) : SizedBox()
                    ),
                    Container(
                        width: _width * 0.897,
                        height: (getTeacherMenu().length + getStudentMenu().length + 5) * 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ...getTeacherMenu(),
                            SimpleListButton(title: "디넌 규정집", iconName: "page", clickAction: () => _launchURL(Get.find<RemoteConfigService>().getDienenManualFileUrl())),
                            SimpleListButton(title: "문의하기", iconName: "headset", clickAction: () => dalgeurakDialog.showInquiry()),
                            SimpleListButton(title: "급식실 인스타그램 보러가기", iconName: "instagram", clickAction: () => _launchURL("https://www.instagram.com/ara__dmigo/")),
                            SimpleListButton(title: "앱 정보", iconName: "info", clickAction: () => myProfileBottomSheet.showApplicationInfo()),
                            SimpleListButton(title: "로그아웃", iconName: "logout", color: Colors.red, clickAction: () => authController.logOut()),
                          ],
                        )
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ),
    );
  }

  List<Widget> getTeacherMenu() {
    if (controller.user?.userType! == DimigoinUserType.teacher) {
      return [
        SimpleListButton(title: "차주 간편식, 선후밥 신청 현황", iconName: "foodBucket", clickAction: () => Get.to(ApplicationStatus())),
        SimpleListButton(title: "학생 식사 여부 통계", iconName: "graph", clickAction: () => print("onClick")),
        SimpleListButton(title: "학생 신청 금지 설정", iconName: "setting", clickAction: () => showSearch(context: Get.context!, delegate: ApplicationBlackList())),
        SimpleListButton(title: "학생 급식비 납부금", iconName: "coin", clickAction: () => print("onClick")),
      ];
    } else {
      return [];
    }
  }

  List<Widget> getStudentMenu() {
    if (controller.user?.userType! == DimigoinUserType.student) {
      return [
        SimpleListButton(title: "간편식, 선후밥 신청 현황", iconName: "signDocu", clickAction: () => Get.to(ApplicationStatus())),
      ];
    } else {
      return [];
    }
  }

  void _launchURL(String _url) async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}