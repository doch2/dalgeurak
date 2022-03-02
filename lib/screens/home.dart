import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak/controllers/qrcode_controller.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/screens/qrcode_scan.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

    if (!qrCodeController.isCreateRefreshTimer) { qrCodeController.refreshTimer(); qrCodeController.isCreateRefreshTimer = true; }
    if (!mealController.isCreateRefreshTimer) { mealController.refreshTimer(); mealController.isCreateRefreshTimer = true; }



    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: _width,
              height: _height,
              decoration: BoxDecoration(
                color: blueThree
              ),
            ),
            Positioned(
              top: _height * 0.12,
              right: _width * 0.15,
              child: Obx(() {
                if (userController.user?.userType != DimigoinUserType.student) {
                  return GetBuilder<QrCodeController>(
                    init: QrCodeController(),
                    builder: (qrCodeController) => GestureDetector(
                        onTap: () => Get.to(QrCodeScan()),
                        child: SizedBox(
                          height: _height * 0.0425,
                          width: _width * 0.175,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/qrCodeScan_btnEdge.svg',
                                width: _width * 0.175,
                              ),
                              Text(
                                "QR 스캔",
                                style: homeMealSequenceWidgetOn.copyWith(color: blueOne, fontSize: 14),
                              )

                            ],
                          ),
                        )
                    ),
                  );
                } else {
                  return GetBuilder<QrCodeController>(
                    init: QrCodeController(),
                    builder: (qrCodeController) => SizedBox(),
                  );
                }
              }),
            ),
            Positioned(
              top: _height * 0.055,
              right: _width * 0.02,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  userMealSequenceWidget(true, "선밥"),
                  SizedBox(width: _width * 0.02),
                  userMealSequenceWidget(false, "후밥")
                ],
              ),
            ),
            Positioned(
              top: _height * 0.1,
              left: _width * 0.1,
              child: Obx(() {
                if (userController.user?.userType != DimigoinUserType.teacher && userController.user?.userType != DimigoinUserType.dormitoryTeacher) {
                  mealController.getMealTime();

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${Get.find<UserController>().user?.classNum}반 " + mealController.dalgeurakService.getMealKind(false).convertKorStr,
                            style: homeMealTitle,
                          ),
                          SizedBox(width: _width * 0.015),
                          Image.asset(
                            "assets/images/logo.png",
                            width: _width * 0.05,
                            height: _width * 0.05,
                          ),
                        ],
                      ),
                      Text(
                        mealController.userMealTime.value,
                        style: homeMealTime,
                      ),
                    ],
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "안녕하세요!",
                            style: homeMealTitle,
                          ),
                        ],
                      ),
                      Text(
                        "${userController.user?.name}님",
                        style: homeMealTime,
                      )
                    ],
                  );
                }
              }),
            ),
            Positioned(
              top: _height * 0.22,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Obx(() {
                    if (userController.user?.userType != DimigoinUserType.teacher) {
                      return GetBuilder<QrCodeController> (
                        init: QrCodeController(),
                        builder: (qrCodeController) => Obx(() {
                          String data = qrCodeController.qrImageData.value;
                          if (data == "initData") {
                            return CircularProgressIndicator();
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                QrImage(
                                  data: qrCodeController.qrImageData.value,
                                  version: QrVersions.auto,
                                  size: _width * 0.5,
                                ),
                                Text(
                                  "남은 시간 : ${qrCodeController.refreshTime.value}",
                                  style: homeQrRefreshTime,
                                )
                              ],
                            );
                          }
                        }),
                      );
                    } else {
                      return GetBuilder<QrCodeController>(
                        init: QrCodeController(),
                        builder: (qrCodeController) => SizedBox(height: _height * 0.15),
                      );
                    }
                  }),
                  SizedBox(
                    height: _height * 0.19,
                    width: _width * 0.9,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: _height * 0.7,
                          width: _width * 0.9,
                          margin: EdgeInsets.only(top: _height * 0.04),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(27),
                              color: blueOne,
                              boxShadow: [
                                BoxShadow(
                                  color: grayEight,
                                  offset: Offset(0, 5),
                                  blurRadius: 20,
                                )
                              ]
                          ),
                        ),
                        Container(
                          height: _height * 0.18,
                          width: _width * 0.9,
                          margin: EdgeInsets.only(top: _height * 0.02),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: blueOne,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: _height * 0.02),
                              SizedBox(
                                width: _width * 0.775,
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
                              SizedBox(height: _height * 0.0225),
                              SizedBox(
                                width: _width * 0.65,
                                child: Obx(() {
                                  Map mealSequence = mealController.mealSequence;

                                  if (mealSequence.isEmpty) { return Center(child: Text("로딩중입니다..", style: TextStyle(color: Colors.white))); }

                                  List<Widget> widgetList = [];
                                  for (int i=1; i<=6; i++) {
                                    widgetList.add(
                                        mealSequenceClassBox(
                                            i,
                                            ((mealSequence
                                            [mealController.dalgeurakService.getMealKind(false).convertEngStr]
                                            [(userController.user?.gradeNum)!-1]
                                            [i-1] == i) ? true : false), false));
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
                                    width: _width * 0.67,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        color: blueFive,
                                        borderRadius: BorderRadius.circular(14.5)
                                    ),
                                  ),
                                  Obx(() => Container(
                                    width: ((_width * 0.63) / 6) * mealController.studentClassMealSequence.value,
                                    height: 5,
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
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }

  Container mealSequenceClassBox(int classNum, bool isOn, bool isDialog) {
    Color color = emptyColor;
    TextStyle textStyle = homeMealSequenceClass;
    if (isDialog) { textStyle = textStyle.copyWith(color: Colors.black); }
    if (isOn) { color = blueSix; if (isDialog) { textStyle = textStyle.copyWith(color: Colors.white); }}

    return Container(
      width: _width * 0.084,
      height: _width * 0.084,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(child: Text("$classNum반", style: textStyle)),
    );
  }

  Container userMealSequenceWidget(bool isOn, String sequence) {
    TextStyle textStyle = homeMealSequenceWidgetOff;
    Color containerColor = emptyColor;
    Color shadowColor = emptyColor;

    if (isOn) {
      textStyle = homeMealSequenceWidgetOn;
      containerColor = blueOne;
      shadowColor = blueFour;
    }

    return Container(
      height: _height * 0.032,
      width: _width * 0.138,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.5),
        color: containerColor,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: Offset(0, 0),
            blurRadius: 2,
          ),
        ],
      ),
      child: Center(child: Text(sequence, style: textStyle)),
    );
  }
}