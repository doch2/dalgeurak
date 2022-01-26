import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak/controllers/qrcode_controller.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/screens/qrcode_scan.dart';
import 'package:dalgeurak/services/firestore_database.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  late MealController mealController;
  late UserController userController;
  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    if (!Get.find<QrCodeController>().isCreateRefreshTimer) { Get.find<QrCodeController>().refreshTimer(); Get.find<QrCodeController>().isCreateRefreshTimer = true; }

    mealController = Get.find<MealController>();
    userController = Get.find<UserController>();

    late GetBuilder<QrCodeController> qrCodeScanBtn;
    late SizedBox mealSequenceSettingBtn;
    late SizedBox mealWaitStatusSettingBtn;
    if (userController.user.group != "student") {
      qrCodeScanBtn = GetBuilder<QrCodeController>(
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

      mealSequenceSettingBtn = SizedBox(
        child: GestureDetector(
          onTap: () => Get.dialog(setMealSequenceDialog()),
          child: Icon(Icons.settings_rounded, color: yellowFive),
        ),
      );

      mealWaitStatusSettingBtn = SizedBox(
        child: GestureDetector(
          onTap: () => Get.dialog(setMealWaitStatusDialog()),
          child: Icon(Icons.settings_rounded),
        ),
      );
    } else {
      qrCodeScanBtn = GetBuilder<QrCodeController>(
        init: QrCodeController(),
        builder: (qrCodeController) => SizedBox(),
      );

      mealSequenceSettingBtn = SizedBox(width: 24);
      mealWaitStatusSettingBtn = SizedBox(width: 24);
    }

    late Column studentMealTimeWidget;
    late GetBuilder<QrCodeController> studentQrCodeWidget;
    if (userController.user.group != "teacher") {
      studentMealTimeWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() {
                if (userController.user.studentId != null) {
                  return Text(
                    "${Get.find<UserController>().user.studentId!.substring(1, 2)}반 " + mealController.getMealKind("kor", false),
                    style: homeMealTitle,
                  );
                } else {
                  return SizedBox(
                    width: _width * 0.055,
                    height: _width * 0.055,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              }),
              SizedBox(width: _width * 0.015),
              Image.asset(
                "assets/images/logo.png",
                width: _width * 0.05,
                height: _width * 0.05,
              ),
            ],
          ),
          Obx(() {
            if (userController.user.studentId != null) {
              mealController.getMealTime();
            }

            return Text(
              mealController.userMealTime.value,
              style: homeMealTime,
            );
          }),
        ],
      );

      studentQrCodeWidget = GetBuilder<QrCodeController> (
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
      studentMealTimeWidget = Column(
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
          Obx(() {
            if (userController.user.name != null) {
              return Text(
                "${userController.user.name}님",
                style: homeMealTime,
              );
            } else {
              return SizedBox(
                width: _width * 0.055,
                height: _width * 0.055,
                child: Center(child: CircularProgressIndicator()),
              );
            }
          }),
        ],
      );

      studentQrCodeWidget = GetBuilder<QrCodeController>(
        init: QrCodeController(),
        builder: (qrCodeController) => SizedBox(),
      );
    }


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
              child: qrCodeScanBtn,
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
              child: studentMealTimeWidget
            ),
            Positioned(
              top: _height * 0.22,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  studentQrCodeWidget,
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
                                    SizedBox(
                                      width: _width * 0.17,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          mealSequenceSettingBtn,
                                          GestureDetector(
                                            onTap: () => Get.dialog(setUserNotEatMealDialog()),
                                            child: Icon(Icons.warning_amber_rounded, color: yellowFive),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: _height * 0.0225),
                              SizedBox(
                                width: _width * 0.65,
                                child: Obx(() {
                                  mealController.getMealSequence();
                                  int mealSequence = mealController.mealSequence.value;

                                  List<Widget> widgetList = [];
                                  for (int i=1; i<=6; i++) {
                                    widgetList.add(mealSequenceClassBox(i, ((mealSequence == i) ? true : false), false));
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
                                    width: ((_width * 0.63) / 6) * mealController.mealSequence.value,
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
                  Container(
                    height: _height * 0.17,
                    width: _width * 0.9,
                    margin: EdgeInsets.only(top: _height * 0.02),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: _width * 0.775,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "대기 상태",
                                  style: homeWaitingStatusTitle
                              ),
                              SizedBox(
                                width: _width * 0.17,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    mealWaitStatusSettingBtn,
                                    GestureDetector(
                                      onTap: () => Get.dialog(statusTrafficLightInfoDialog()),
                                      child: Icon(Icons.help_outline_rounded),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: _height * 0.015),
                        SizedBox(
                          width: _width * 0.65,
                          height: _height * 0.08,
                          child: Obx(() {
                            mealController.getMealWaitStatus();
                            String waitStatus = mealController.mealWaitStatus.value;

                            return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  mealStatusTrafficLightWidget((waitStatus == "red"), "정체"),
                                  mealStatusTrafficLightWidget((waitStatus == "yellow"), "혼잡"),
                                  mealStatusTrafficLightWidget((waitStatus == "green"), "원활")
                                ],
                            );
                          }),
                        )
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

  Container mealStatusTrafficLightWidget(bool isOn, String status) {
    TextStyle textStyle = homeStatusTrafficLightOff;
    Color containerColor = grayThree;
    Color containerShadowColor = grayShadowOne;
    if (isOn) {
      if (status == "정체") {
        textStyle = homeStatusTrafficLightOn_congest;
        containerColor = redOne;
        containerShadowColor = redShadowOne;
      } else if (status == "혼잡") {
        textStyle = homeStatusTrafficLightOn_confusion;
        containerColor = yellowTwo;
        containerShadowColor = yellowTwoShadow;
      } else if (status == "원활") {
        textStyle = homeStatusTrafficLightOn_smoothly;
        containerColor = greenOne;
        containerShadowColor = greenShadowOne;
      }
    }

    return Container(
      height: _width * 0.16,
      width: _width * 0.16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: containerColor,
        boxShadow: [
          BoxShadow(
            color: containerShadowColor,
            offset: Offset(4, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Center(child: Text(status, style: textStyle)),
    );
  }

  Dialog setMealWaitStatusDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(21))
      ),
      child: Container(
        width: _width * 0.784,
        height: _height * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          color: grayTwo,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: _height * 0.023,
              left: _width * 0.07,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Icon(Icons.arrow_back_sharp),
              ),
            ),
            Positioned(
                top: _height * 0.0225,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("대기 상태 설정", style: homeDialogTitle),
                    SizedBox(height: _height * 0.017),
                    Text("현재 급식실 앞의 대기 줄 상태를\n설정해주세요!", style: homeNotEatMealDialogTitle, textAlign: TextAlign.center),
                  ],
                )
            ),
            Positioned(
                top: _height * 0.175,
                child: Obx(() {
                  String waitStatus = mealController.mealWaitStatusInSetDialog.value;

                  return SizedBox(
                    width: _width * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => mealController.mealWaitStatusInSetDialog.value = "red",
                          child: mealStatusTrafficLightWidget((waitStatus == "red"), "정체"),
                        ),
                        GestureDetector(
                          onTap: () => mealController.mealWaitStatusInSetDialog.value = "yellow",
                          child: mealStatusTrafficLightWidget((waitStatus == "yellow"), "혼잡"),
                        ),
                        GestureDetector(
                          onTap: () => mealController.mealWaitStatusInSetDialog.value = "green",
                          child: mealStatusTrafficLightWidget((waitStatus == "green"), "원활"),
                        )
                      ],
                    ),
                  );
                }),
            ),
            Positioned(
              top: _height * 0.32,
              child: GestureDetector(
               onTap: () {
                  mealController.setMealWaitStatus(mealController.mealWaitStatusInSetDialog.value);
                  Get.back();
                },
                child: Container(
                  width: _width * 0.4,
                  height: _height * 0.05,
                  decoration: BoxDecoration(
                      color: blueOne,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: blueOne,
                          blurRadius: 2,
                        )
                      ]
                  ),
                  child: Center(child: Text("확인", style: homeDialogOkBtn)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Dialog setMealSequenceDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(21))
      ),
      child: Container(
        width: _width * 0.784,
        height: _height * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          color: grayTwo,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: _height * 0.023,
              left: _width * 0.07,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Icon(Icons.arrow_back_sharp),
              ),
            ),
            Positioned(
                top: _height * 0.0225,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("급식 순서 설정", style: homeDialogTitle),
                    SizedBox(height: _height * 0.017),
                    Text("현재 입장 완료한 반을\n선택해주세요!", style: homeNotEatMealDialogTitle, textAlign: TextAlign.center),
                  ],
                )
            ),
            Positioned(
              top: _height * 0.175,
              child: Obx(() {
                int mealSequence = mealController.mealClassSequenceInSetDialog.value;

                List<Widget> classBoxList = [];
                for (int i=1; i<=6; i++) {
                  classBoxList.add(
                    GestureDetector(
                      onTap: () => mealController.mealClassSequenceInSetDialog.value = i,
                      child: mealSequenceClassBox(i, (mealSequence == i), true),
                    ),
                  );
                }

                return SizedBox(
                  width: _width * 0.65,
                  height: _height * 0.08,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: classBoxList,
                  ),
                );
              }),
            ),
            Positioned(
              top: _height * 0.32,
              child: GestureDetector(
                onTap: () {
                  mealController.setMealSequence(mealController.mealClassSequenceInSetDialog.value);
                  Get.back();
                },
                child: Container(
                  width: _width * 0.4,
                  height: _height * 0.05,
                  decoration: BoxDecoration(
                      color: blueOne,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: blueOne,
                          blurRadius: 2,
                        )
                      ]
                  ),
                  child: Center(child: Text("확인", style: homeDialogOkBtn)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Dialog setUserNotEatMealDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))
      ),
      child: Container(
        width: _width * 0.784,
        height: _height * 0.24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: grayTwo,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: _height * 0.018,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_rounded,
                        color: yellowFive,
                      ),
                      SizedBox(width: _width * 0.015),
                      Text("Warning", style: homeNotEatMealDialogWarning)
                    ],
                  ),
                  SizedBox(height: _height * 0.017),
                  Text("점심 급식을 드시지 않을 건가요?", style: homeNotEatMealDialogTitle),
                  SizedBox(height: _height * 0.004),
                  Text("신중하게 결정해주세요.", style: homeNotEatMealDialogDescription)
                ],
              )
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Material(
                color: grayTwo,
                borderRadius:  BorderRadius.only(bottomLeft: Radius.circular(16)),
                child: InkWell(
                  onTap: () {
                    mealController.setUserIsNotEatMeal(true);
                    Get.back();
                  },
                  child: Container(
                    width: _width * 0.392,
                    height: _height * 0.075,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Center(child: Text("네", style: homeNotEatMealDialogBtn)),
                  ),
                ),
              )
            ),
            Positioned(
                right: 0,
                bottom: 0,
                child: Material(
                  color: grayTwo,
                  borderRadius:  BorderRadius.only(bottomRight: Radius.circular(16)),
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      width: _width * 0.392,
                      height: _height * 0.075,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Center(child: Text("아니요", style: homeNotEatMealDialogBtn)),
                    ),
                  ),
                )
            ),
            Positioned(
              bottom: _height * 0.075,
              child: Container(
                width: _width * 0.784,
                height: 2,
                color: grayNine,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: 2,
                height: _height * 0.075,
                color: grayNine,
              ),
            )
          ],
        ),
      ),
    );
  }

  Dialog statusTrafficLightInfoDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(21))
      ),
      child: Container(
        width: _width * 0.784,
        height: _height * 0.65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          color: grayTwo,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: _height * 0.0475,
              left: _width * 0.07,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Icon(Icons.arrow_back_sharp),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    "대기 상태",
                    style: homeDialogTitle
                ),
                SizedBox(height: _height * 0.03),
                Text(
                  "현재 급식실 앞의 대기 줄 상태를\n알 수 있어요!",
                  style: homeDialogDescription,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: _height * 0.07),
                SizedBox(
                  width: _width * 0.57,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      mealStatusTrafficLightWidget(true, "정체"),
                      SizedBox(width: _width * 0.05),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              style: homeStatusTrafficLightHelpDetailDescription,
                              text: "대기 줄이 너무 길어요!\n",
                            ),
                            TextSpan(
                              style: homeStatusTrafficLightHelpDetailDescription.copyWith(
                                  color: redTwo,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11
                              ),
                              text: "5분 이상",
                            ),
                            TextSpan(
                              style: homeStatusTrafficLightHelpDetailDescription.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11
                              ),
                              text: " 대기해야 해요.",
                            ),
                          ],
                        ),
                        style: homeStatusTrafficLightHelpDetailDescription,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: _height * 0.045),
                SizedBox(
                  width: _width * 0.57,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      mealStatusTrafficLightWidget(true, "혼잡"),
                      SizedBox(width: _width * 0.05),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              style: homeStatusTrafficLightHelpDetailDescription,
                              text: "대기가 필요해요!\n",
                            ),
                            TextSpan(
                              style: homeStatusTrafficLightHelpDetailDescription.copyWith(
                                  color: yellowThree,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11
                              ),
                              text: "5분 안에",
                            ),
                            TextSpan(
                              style: homeStatusTrafficLightHelpDetailDescription.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11
                              ),
                              text: " 입장 할 수 있어요.",
                            ),
                          ],
                        ),
                        style: homeStatusTrafficLightHelpDetailDescription,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: _height * 0.045),
                SizedBox(
                  width: _width * 0.57,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      mealStatusTrafficLightWidget(true, "원활"),
                      SizedBox(width: _width * 0.05),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              style: homeStatusTrafficLightHelpDetailDescription,
                              text: "대기 줄이 없어요!\n",
                            ),
                            TextSpan(
                              style: homeStatusTrafficLightHelpDetailDescription.copyWith(
                                  color: greenTwo,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11
                              ),
                              text: "바로",
                            ),
                            TextSpan(
                              style: homeStatusTrafficLightHelpDetailDescription.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11
                              ),
                              text: " 입장할 수 있어요.",
                            ),
                          ],
                        ),
                        style: homeStatusTrafficLightHelpDetailDescription,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}