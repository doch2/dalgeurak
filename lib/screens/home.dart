import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak/controllers/qrcode_controller.dart';
import 'package:dalgeurak/screens/qrcode_scan.dart';
import 'package:dalgeurak/services/firestore_database.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  late MealController mealController;
  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    if (!Get.find<QrCodeController>().isCreateRefreshTimer) { Get.find<QrCodeController>().refreshTimer(); Get.find<QrCodeController>().isCreateRefreshTimer = true; }

    mealController = Get.find<MealController>();
    mealController.getMealTime();

    AuthController authController = Get.find<AuthController>();


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
              top: _height * 0.025,
              child: GetBuilder<QrCodeController> (
                init: QrCodeController(),
                builder: (qrCodeController) => GestureDetector(onTap: () => Get.to(QrCodeScan()), child: Text("<임시버튼> QR코드 스캔하러 가기")),
              ),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                      future: FirestoreDatabase().getUser(authController.user?.uid),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) { //데이터를 정상적으로 받았을때
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${snapshot.data.studentId.substring(1, 2)}반 " + mealController.getMealKind("kor", false),
                                style: homeMealTitle,
                              ),
                              SizedBox(width: _width * 0.015),
                              Image.asset(
                                "assets/images/logo.png",
                                width: _width * 0.05,
                                height: _width * 0.05,
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) { //데이터를 정상적으로 불러오지 못했을 때
                          return Text("데이터 로드 오류", textAlign: TextAlign.center);
                        } else { //데이터를 불러오는 중
                          return SizedBox(
                            width: _width * 0.055,
                            height: _width * 0.055,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      }
                  ),
                  Obx(() => Text(
                    mealController.userMealTime.value,
                    style: homeMealTime,
                  )),
                ],
              )
            ),
            Positioned(
              top: _height * 0.22,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GetBuilder<QrCodeController> (
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
                  ),
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
                                    GestureDetector(
                                      onTap: () => Get.dialog(setUserNotEatMealDialog()),
                                      child: Icon(Icons.warning_amber_rounded, color: yellowFive),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: _height * 0.0225),
                              SizedBox(
                                width: _width * 0.65,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    mealSequenceClassBox(1, false),
                                    mealSequenceClassBox(2, true),
                                    mealSequenceClassBox(3, false),
                                    mealSequenceClassBox(4, false),
                                    mealSequenceClassBox(5, false),
                                    mealSequenceClassBox(6, false),
                                  ],
                                ),
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
                                  Container(
                                    width: ((_width * 0.63) / 6) * 2,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        color: yellowFive,
                                        borderRadius: BorderRadius.circular(14.5)
                                    ),
                                  ),
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
                              GestureDetector(
                                onTap: () => Get.dialog(statusTrafficLightInfoDialog()),
                                child: Icon(Icons.help_outline_rounded),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: _height * 0.015),
                        SizedBox(
                          width: _width * 0.65,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              mealStatusTrafficLightWidget(true, "정체"),
                              mealStatusTrafficLightWidget(false, "혼잡"),
                              mealStatusTrafficLightWidget(false, "원활")
                            ],
                          ),
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

  Container mealSequenceClassBox(int classNum, bool isOn) {
    Color color = emptyColor;
    if (isOn) { color = blueSix; }

    return Container(
      width: _width * 0.084,
      height: _width * 0.084,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(child: Text("$classNum반", style: homeMealSequenceClass)),
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
                    style: homeStatusTrafficLightHelpTitle
                ),
                SizedBox(height: _height * 0.03),
                Text(
                  "현재 급식실 앞의 대기 줄 상태를\n알 수 있어요!",
                  style: homeStatusTrafficLightHelpDescription,
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