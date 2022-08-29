import 'package:dalgeurak/screens/home/home_bottomsheet.dart';
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
import '../widgets/big_menu_button.dart';
import '../studentManage/student_search.dart';
import '../studentManage/qrcode_scan.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  late MealController mealController;
  late UserController userController;
  late QrCodeController qrCodeController;
  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    mealController = Get.find<MealController>();
    userController = Get.find<UserController>();
    qrCodeController = Get.find<QrCodeController>();
    HomeBottomSheet _homeBottomSheet = HomeBottomSheet();

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
                    subTitle: "안녕하세요!",
                    title: "${userController.user?.name}님",
                  );
                }
              }),
            ),
            Positioned(
              top: _height * 0.065,
              right: -(_width * 0.125),
              child: Image.asset(
                "assets/images/home_flowerpot.png",
              ),
            ),
            Obx(() {
              bool? isDienen = userController.user?.permissions?.contains(DimigoinPermissionType.dalgeurak); isDienen ??= false;
              bool isStudent = userController.user?.userType != DimigoinUserType.teacher && !isDienen;

              return Positioned(
                top: _height * (isStudent ? 0.22 : 0.23),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    (isStudent ?
                      getQrCodeShowWidget(false) :
                      Column(
                        children: [
                          SizedBox(
                            width: _width * 0.897,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => _homeBottomSheet.showMealDelay(context),
                                  child: BigMenuButton(
                                    title: "급식 지연",
                                    iconName: "clock",
                                    isHome: true,
                                    sizeRatio: 0.282,
                                    includeInnerShadow: false,
                                    backgroundType: BigMenuButtonBackgroundType.image,
                                    background: ExtendedImage.asset("assets/images/homeMenu_clock.png"),
                                  ),
                                ),
                                GestureDetector(
                                  child: BigMenuButton(
                                    title: "남은 인원",
                                    iconName: "twoPeople",
                                    isHome: true,
                                    sizeRatio: 0.282,
                                    includeInnerShadow: true,
                                    backgroundType: BigMenuButtonBackgroundType.gradient,
                                    background: blueLinearGradientOne,
                                  ),
                                ),
                                GestureDetector(
                                  child: BigMenuButton(
                                    title: "학생 관리",
                                    iconName: "peopleClip",
                                    isHome: true,
                                    sizeRatio: 0.282,
                                    includeInnerShadow: false,
                                    backgroundType: BigMenuButtonBackgroundType.color,
                                    background: dalgeurakYellowOne,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: _height * 0.0175),
                          SizedBox(
                            width: _width * 0.897,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => _homeBottomSheet.showChooseModifyMealInfoKind(),
                                  child: BigMenuButton(
                                    title: "급식 순서･장소",
                                    iconName: "table",
                                    isHome: true,
                                    sizeRatio: 0.282,
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
                                    sizeRatio: 0.282,
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
                                    sizeRatio: 0.282,
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
                                          child: GestureDetector(onTap: () => Get.back(), child: Icon(Icons.close_rounded, color: dalgeurakGrayThree, size: _width * 0.08)),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                            ),
                            child: Container(
                              height: _height * 0.1,
                              width: _width * 0.897,
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
                                    width: _width * 0.1,
                                  ),
                                  Text("급식실 입장", style: homeEntranceCafeteriaWidgetTitle)
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                    Container(
                      height: _height * 0.18,
                      width: _width * 0.897,
                      margin: EdgeInsets.only(top: _height * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: dalgeurakBlueOne,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: _height * 0.02),
                          SizedBox(
                            width: _width * 0.725,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "급식 순서",
                                    style: homeMealSequenceTitle
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: _height * 0.016),
                          SizedBox(
                            width: _width * 0.65,
                            child: Obx(() {
                              Map mealSequence = mealController.mealSequence;
                              Map mealTime = mealController.mealTime;

                              if (mealSequence.isEmpty) { return Center(child: Text("로딩중입니다..", style: TextStyle(color: Colors.white))); }
                              String mealType = mealController.dalgeurakService.getMealKind(false).convertEngStr;
                              List userGradeMealSequence = mealSequence[mealType][(userController.user?.gradeNum)!-1];
                              List userGradeMealTime = mealTime["extra${mealType[0].toUpperCase()}${mealType.substring(1)}"][(userController.user?.gradeNum)!-1];

                              List<Widget> widgetList = [];
                              for (int i=1; i<=6; i++) {
                                bool isOn = ((mealController.nowClassMealSequence.value == i) ? true : false);

                                widgetList.add(Container(
                                  width: _width * 0.1,
                                  height: _width * 0.15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Positioned(
                                        top: -9,
                                        child: isOn ? Icon(Icons.arrow_drop_down, color: Colors.white) : SizedBox(),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("${userGradeMealSequence[i-1]}반", style: homeMealSequenceClass),
                                          SizedBox(height: 3),
                                          Text(isOn ? "배식중" : "${userGradeMealTime[i-1].toString().substring(0, 2)}:${userGradeMealTime[i-1].toString().substring(2)}", style: homeMealSequenceClassTime)
                                        ],
                                      ),
                                    ]
                                  )
                                ));
                              }

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: widgetList,
                              );
                            }),
                          ),
                          SizedBox(height: _height * 0.0075),
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                width: _width * 0.725,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: blueFive,
                                    borderRadius: BorderRadius.circular(14.5)
                                ),
                              ),
                              Obx(() => AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                width: ((_width * 0.75) / 6) * mealController.nowClassMealSequence.value,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: yellowFive,
                                    borderRadius: BorderRadius.circular(14.5)
                                ),
                              )),
                            ],
                          )
                        ],
                      ),
                    ),
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
      width: _width * 0.897,
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
              width: _width * 0.055,
              height: _width * 0.055,
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
                size: _width * 0.512,
              ),
              Text("${userController.user?.studentId} ${userController.user?.name}", style: homeQrCheckInStudentInfo),
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
}