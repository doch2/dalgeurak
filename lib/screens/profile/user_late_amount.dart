import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserLateAmount extends GetWidget<UserController> {
  UserLateAmount({Key? key}) : super(key: key);

  late double _height, _width;
  late int userTardyAmount;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    userTardyAmount = 0;

    return Scaffold(
      backgroundColor: blueThree,
      body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  top: _height * 0.06,
                  left: _width * 0.025,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.chevron_left,
                      size: _width * 0.12,
                    ),
                  )
              ),
              Positioned(
                top: _height * 0.075,
                child: Text("지각 횟수", style: myProfileTitle),
              ),
              Positioned(
                top: _height * 0.17,
                child: Image.asset(
                  "assets/images/logo.png",
                  width: _width * 0.1,
                  height: _width * 0.1,
                ),
              ),
              Positioned(
                top: _height * 0.24,
                child: Obx(() => Text("누적 ${controller.userTardyAmount.value}회", style: myProfileSubTitle))
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: _width,
                    height: _height * 0.67,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13)),
                        color: Colors.white
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: _height * 0.03),
                        SizedBox(
                          width: _width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "세부 목록",
                                  style: myProfileDetailListTitle
                              ),
                              Icon(Icons.swap_vert_rounded, size: _width * 0.08)
                            ],
                          ),
                        ),
                        SizedBox(height: _height * 0.04),
                        FutureBuilder(
                            future: controller.dalgeurakService.getUserMealInfo(), //TODO 추후 적절한 API로 변경필요
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                List<Widget> logWidgetList = [];
                                Map logData = snapshot.data;

                                controller.getUserTotalTardyAmount(logData);

                                List<Color> boxColor = [greenThree, yellowSeven, blueSeven];
                                for (int monthIndex=0; monthIndex<logData.length; monthIndex++) {
                                  String month = logData.keys.elementAt(monthIndex);
                                  for (int dayIndex=0; dayIndex<logData[month].length; dayIndex++) {
                                    String day = logData[month].keys.elementAt(dayIndex);

                                    logWidgetList.add(dayLogWidget(month, day, logData, boxColor[dayIndex % 3]));
                                    logWidgetList.add(SizedBox(height: _height * 0.045));
                                  }
                                }

                                return Expanded(
                                  child: Scrollbar(
                                      child: SizedBox(
                                          width: _width,
                                          height: _height * 0.42,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: logWidgetList,
                                            ),
                                          )
                                      )
                                  ),
                                );
                              } else if (snapshot.data == null) { //데이터가 없을 때
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(width: _width, height: _height * 0.4),
                                    Center(child: Text("현재 기록된 지각 내역이 없습니다.", textAlign: TextAlign.center)),
                                  ],
                                );
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
                                    SizedBox(width: _width, height: _height * 0.4),
                                    Center(child: CircularProgressIndicator()),
                                  ],
                                );
                              }
                            }
                        ),
                      ],
                    ),
                  )
              )
            ],
          )
      ),
    );
  }

  SizedBox dayLogWidget(String month, String day, Map logData, Color boxColor) {
    DateTime date = DateTime(DateTime.now().year, int.parse(month), int.parse(day));
    List<Widget> logTimeText = [];

    List mealKind = ['lunch', 'dinner'];
    for (int i=0; i<mealKind.length; i++) {
      if (logData[month][day][mealKind[i]] != null && logData[month][day][mealKind[i]]['mealStatus'] == "tardy") {
        String time = logData[month][day][mealKind[i]]["time"];

        late String mealKindKor;
        if (mealKind[i] == 'lunch') { mealKindKor = "점심"; } else if (mealKind[i] == 'dinner') { mealKindKor = "저녁"; }

        userTardyAmount++;

        logTimeText.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: _width * 0.015,
                  height: _height * 0.09,
                  decoration: BoxDecoration(
                    color: boxColor,
                    borderRadius: BorderRadius.circular(2)
                  ),
                ),
                SizedBox(width: _width * 0.03),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "누적 $userTardyAmount회",
                        style: myProfileTardyAmountNum
                    ),
                    SizedBox(height: _height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.schedule_rounded, size: _width * 0.05, color: redThree),
                        SizedBox(width: _width * 0.01),
                        Text(
                            "$mealKindKor: ${time.substring(0, 2)}시 ${time.substring(2)}분",
                            style: myProfileQrLogTime.copyWith(color: redThree)
                        )
                      ],
                    )
                  ],
                )
              ],
            )
        );
      }
    }

    return SizedBox(
      height: _height * 0.15,
      width: _width * 0.75,
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "$month월 $day일 ${Get.find<MealController>().weekDay[date.weekday]}요일",
                  style: myProfileDate
              ),
              SizedBox(height: _height * 0.025),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: logTimeText,
              )
            ],
          )
      ),
    );
  }
}