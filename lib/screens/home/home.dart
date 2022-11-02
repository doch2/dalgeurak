import 'package:dalgeurak/screens/home/home_bottomsheet.dart';
import 'package:dalgeurak/screens/home/widgets/live_meal_sequence.dart';
import 'package:dalgeurak/screens/studentManage/convenience_food.dart';
import 'package:dalgeurak/screens/studentManage/meal_exception.dart';
import 'package:dalgeurak_meal_application/pages/teacher_meal_cancel/teacher_meal_cancel.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:dalgeurak_widget_package/widgets/window_title.dart';
import '../../controllers/meal_controller.dart';
import '../../controllers/qrcode_controller.dart';
import '../../controllers/user_controller.dart';
import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';
import '../studentManage/meal_cancel_confirm.dart';
import '../widgets/big_menu_button.dart';
import '../studentManage/student_search.dart';
import '../studentManage/qrcode_scan.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  late MealController mealController;
  late UserController userController;
  late QrCodeController qrCodeController;
  late HomeBottomSheet _homeBottomSheet;
  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    mealController = Get.find<MealController>();
    userController = Get.find<UserController>();
    qrCodeController = Get.find<QrCodeController>();
    _homeBottomSheet = HomeBottomSheet();

    if (!mealController.isCreateRefreshTimer) { mealController.refreshTimer(); mealController.isCreateRefreshTimer = true; }



    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: _width,
              height: _height,
              decoration: BoxDecoration(
                color: dalgeurakGrayOne
              ),
            ),
            Positioned(
              top: _height * 0.115,
              left: _width * 0.1,
              child: Obx(() {
                if (userController.user?.userType != DimigoinUserType.teacher && userController.user?.userType != DimigoinUserType.dormitoryTeacher) {
                  mealController.getMealTime();

                  return WindowTitle(
                    subTitle: "${Get.find<UserController>().user?.classNum}반 " + mealController.dalgeurakService.getMealKind(false).convertKorStr,
                    title: mealController.userMealTime.value,
                  );
                } else {
                  return WindowTitle(
                    subTitle: userController.user?.userType != DimigoinUserType.teacher ? "안녕하세요!" : "${userController.user?.teacherRole ?? "등록 부서 없음"}",
                    title: "${userController.user?.name}${userController.user?.userType != DimigoinUserType.teacher ? "님" : " 선생님"}",
                  );
                }
              }),
            ),
            Positioned(
              top: _height * 0.065,
              right: -(_width * 0.125),
              child: Image.asset(
                "assets/images/home_flowerpot.png",
                height: 124,
              ),
            ),
            Obx(() {
              bool? isDienen = userController.user?.permissions?.contains(DimigoinPermissionType.dalgeurak); isDienen ??= false;
              bool isStudent = userController.user?.userType != DimigoinUserType.teacher;

              return Positioned(
                top: _height * (isStudent ? 0.22 : 0.2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    (isStudent ? (isDienen ? getDienenMenuBtnWidget(context) : getQrCodeShowWidget(false)) : getTeacherMenuBtnWidget(context)),
                    (
                      isStudent ?
                          LiveMealSequence(mealSequenceMode: LiveMealSequenceMode.blue)
                        : Column(children: [
                            LiveMealSequence(mealSequenceMode: LiveMealSequenceMode.white, checkGradeNum: 2),
                            LiveMealSequence(mealSequenceMode: LiveMealSequenceMode.blue, checkGradeNum: 1),
                          ]
                        )
                    )
                  ],
                ),
              );
            }),
          ],
        )
      ),
    );
  }

  getQrCodeShowWidget(bool isDialog) => Obx(() {
    String qrCodeData = qrCodeController.qrImageData.value;
    dynamic userStatusInfo;
    if (mealController.userMealException.value == MealExceptionType.normal) {
      String leftTime = mealController.getUserLeftMealTime();

      userStatusInfo = Text(leftTime.isEmpty ? "내일 급식을 기대해주세요!" : "급식 입장까지 남은 시간은 $leftTime입니다.", style: homeQrCheckInStatusInfo);
    } else {
      userStatusInfo = Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "오늘 ${mealController.dalgeurakService.getMealKind(false).convertKorStr} ",
            ),
            TextSpan(
                text: mealController.userMealException.value == MealExceptionType.first ? "선밥" : "후밥",
                style: homeQrCheckInStatusInfo.copyWith(color: greenOne)
            ),
            TextSpan(
              text: " 입니다.",
            ),
          ],
        ),
        textAlign: TextAlign.center,
        style: homeQrCheckInStatusInfo,
      );
    }

    return Container(
      width: 350,
      height: _height * 0.45,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: _width * 0.05,
            right: _width * (isDialog ? 0.125 : 0.05),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: dalgeurakGrayTwo,
                      width: 1
                  )
              ),
              child: Center(
                child: Text(
                  "${mealController.refreshTime.value}",
                  style: homeQrRefreshTime,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("급식 QR 체크인", style: homeQrCheckInTitle),
              (qrCodeData == "initData") ?
              CircularProgressIndicator() :
              QrImage(
                data: qrCodeController.qrImageData.value,
                version: QrVersions.auto,
                size: 200,
              ),
              Text("${userController.user?.gradeNum}학년 ${userController.user?.classNum}반 ${userController.user?.name}", style: homeQrCheckInStudentInfo),
              SizedBox(height: _height * 0.005),
              Text(mealController.userMealStatus.value == MealStatusType.onTime ? "입장 가능" : "입장 불가능", style: homeQrCheckInStatus),
              SizedBox(height: _height * 0.01),
              userStatusInfo,
            ],
          )
        ],
      ),
    );
  });
  
  getDienenMenuBtnWidget(BuildContext context) => Column(
    children: [
      SizedBox(
        width: 350,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => _homeBottomSheet.showMealDelay(context),
              child: BigMenuButton(
                title: "급식 지연",
                iconName: "clock",
                isHome: true,
                containerSize: 110,
                includeInnerShadow: false,
                backgroundType: BigMenuButtonBackgroundType.image,
                background: ExtendedImage.asset("assets/images/homeMenu_clock.png"),
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(MealExceptionPage(pageMode: MealExceptionPageMode.list)),
              child: BigMenuButton(
                title: "선후밥 명단",
                iconName: "twoPeople",
                isHome: true,
                containerSize: 110,
                includeInnerShadow: true,
                backgroundType: BigMenuButtonBackgroundType.gradient,
                background: blueLinearGradientOne,
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(MealExceptionPage(pageMode: MealExceptionPageMode.confirm)),
              child: BigMenuButton(
                title: "선밥 컨펌",
                iconName: "checkCircle_round",
                isHome: true,
                containerSize: 110,
                includeInnerShadow: false,
                backgroundType: BigMenuButtonBackgroundType.gradient,
                background: pinkLinearGradientOne,
              ),
            )
          ],
        ),
      ),
      SizedBox(height: _height * 0.0175),
      SizedBox(
        width: 350,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => _homeBottomSheet.showChooseModifyMealInfoKind(),
              child: BigMenuButton(
                title: "급식 순서･장소",
                iconName: "table",
                isHome: true,
                containerSize: 110,
                includeInnerShadow: true,
                backgroundType: BigMenuButtonBackgroundType.gradient,
                background: purpleGreenLinearGradientOne,
              ),
            ),
            GestureDetector(
              onTap: () => showSearch(context: context, delegate: StudentSearch()),
              child: BigMenuButton(
                title: "학생 검색",
                iconName: "peopleSearch",
                isHome: true,
                containerSize: 110,
                includeInnerShadow: false,
                backgroundType: BigMenuButtonBackgroundType.color,
                background: blueNine,
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(QrCodeScan()),
              child: BigMenuButton(
                title: "QR 입장 스캐너",
                iconName: "qrCode",
                isHome: true,
                containerSize: 110,
                includeInnerShadow: false,
                backgroundType: BigMenuButtonBackgroundType.image,
                background: ExtendedImage.asset("assets/images/homeMenu_qrCode.png"),
              ),
            )
          ],
        ),
      ),
      GestureDetector(
        onTap: () => Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(width: _width * 0.925, height: _height * 0.625),
                    getQrCodeShowWidget(true),
                    Positioned(
                      top: _width * 0.075,
                      right: _width * 0.075,
                      child: GestureDetector(onTap: () => Get.back(), child: Icon(Icons.close_rounded, color: dalgeurakGrayThree, size: 20)),
                    )
                  ],
                ),
              ),
            )
        ),
        child: Container(
          height: _height * 0.1,
          width: 350,
          margin: EdgeInsets.only(top: _height * 0.02),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: dalgeurakBlueOne.withAlpha(20),
                    blurRadius: 10
                )
              ]
          ),
          child: Column(
            children: [
              SizedBox(height: _height * 0.02),
              SvgPicture.asset(
                "assets/images/icons/entrance.svg",
                width: 39,
              ),
              Text("급식실 입장", style: homeEntranceCafeteriaWidgetTitle)
            ],
          ),
        ),
      ),
    ],
  );

  getTeacherMenuBtnWidget(BuildContext context) => Column(
    children: [
      SizedBox(
        width: 350,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Get.to(ConvenienceFoodCheckInPage()),
              child: BigMenuButton(
                title: "간편식 체크인",
                iconName: "foodBucket",
                isHome: true,
                containerSize: 110,
                includeInnerShadow: false,
                backgroundType: BigMenuButtonBackgroundType.gradient,
                background: greenLinearGradientOne,
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(MealExceptionPage(pageMode: MealExceptionPageMode.list)),
              child: BigMenuButton(
                title: "선후밥 명단",
                iconName: "twoPeople",
                isHome: true,
                containerSize: 110,
                includeInnerShadow: true,
                backgroundType: BigMenuButtonBackgroundType.color,
                background: blueNine,
              ),
            ),
            GestureDetector(
              onTap: () => _homeBottomSheet.showExcelDownload(),
              child: BigMenuButton(
                title: "엑셀 다운",
                iconName: "excel",
                isHome: true,
                containerSize: 110,
                includeInnerShadow: true,
                backgroundType: BigMenuButtonBackgroundType.gradient,
                background: blueLinearGradientOne,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: _height * 0.0175),
      SizedBox(
        width: 350,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => _homeBottomSheet.showModifyMealPrice(),
              child: BigMenuButton(
                title: "급식 단가 수정",
                iconName: "signDocu",
                isHome: true,
                containerSize: 110,
                includeInnerShadow: false,
                backgroundType: BigMenuButtonBackgroundType.color,
                background: dalgeurakYellowOne,
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(MealCancelConfirm()),
              child: BigMenuButton(
                title: "급식 취소 컨펌",
                iconName: "checkCircle_round",
                isHome: true,
                containerSize: 110,
                includeInnerShadow: true,
                backgroundType: BigMenuButtonBackgroundType.color,
                background: purpleTwo,
              ),
            ),
            GestureDetector(
              onTap: () => TeacherMealCancel().showStudentChoicePage(),
              child: BigMenuButton(
                title: "급식 취소 신청",
                iconName: "cancelCircle",
                isHome: true,
                containerSize: 110,
                includeInnerShadow: true,
                backgroundType: BigMenuButtonBackgroundType.gradient,
                background: pinkLinearGradientOne,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}