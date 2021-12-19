import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak/services/meal_info.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MealPlanner extends GetWidget<MealController> {
  MealPlanner({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: blueThree,
      body: SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: _width,
                height: _height,
                color: blueThree
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FutureBuilder(
                      future: controller.getMealPlanner(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return SizedBox(
                            width: _width * 0.95,
                            height: _height * 0.837,
                            child: DefaultTabController(
                              length: 7,
                              initialIndex: (DateTime.now().weekday-1),
                              child: Scaffold(
                                backgroundColor: Colors.transparent,
                                appBar: PreferredSize(
                                  preferredSize: Size.fromHeight(kToolbarHeight),
                                  child: Container(
                                    height: 50.0,
                                    child: TabBar(
                                      labelStyle: mealPlannerTabDate,
                                      labelColor: Colors.black,
                                      unselectedLabelColor: grayOne,
                                      indicatorWeight: _width * 0.0075,
                                      tabs: mealPlannerTab(),
                                    ),
                                  ),
                                ),
                                body: TabBarView(
                                  children: mealPlannerView(snapshot.data),
                                ),
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) { //데이터를 정상적으로 불러오지 못했을 때
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(width: _width, height: _height * 0.87),
                              Center(child: Text("데이터를 정상적으로 불러오지 못했습니다. \n다시 시도해 주세요.", textAlign: TextAlign.center)),
                            ],
                          );
                        } else { //데이터를 불러오는 중
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(width: _width, height: _height * 0.87),
                              Center(child: CircularProgressIndicator()),
                            ],
                          );
                        }
                      }
                  ),
                ],
              ),
            ],
          )
        ),
      ),
    );
  }

  List<Widget> mealPlannerTab() {
    List<Widget> result = [];

    for (int i=1; i<=7; i++) {
      result.add(
        Tab(child: Text(controller.weekDay[i])),
      );
    }

    return result;
  }

  List<Widget> mealPlannerView(Map data) {
    List<Widget> result = [];

    for (int i=1; i<=7; i++) {
      Map correctDate = MealInfo().getCorrectDate((DateTime.now().day - (DateTime.now().weekday - 1)) + (i-1));

      result.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: _height * 0.02),
            Image.asset(
              "assets/images/logo.png",
              width: _width * 0.085,
              height: _width * 0.085,
            ),
            Text(
                "${correctDate["month"]}월 ${correctDate["day"]}일",
                style: mealPlannerDate
            ),
            SizedBox(height: _height * 0.018),
            mealPlannerPanel(data, i, "breakfast", "아침"),
            SizedBox(height: _height * 0.018),
            mealPlannerPanel(data, i, "lunch", "점심"),
            SizedBox(height: _height * 0.018),
            mealPlannerPanel(data, i, "dinner", "저녁"),
          ],
        )
      );
    }

    return result;
  }

  Stack mealPlannerPanel(Map data, int index, String engMealType, String korMealType) {
    Color smallBoxColor = emptyColor;
    Color bigBoxColor = Colors.white;
    TextStyle mealTextStyle = mealPlannerContent;
    List<BoxShadow> boxShadow = [];

    if (korMealType == '아침') {
      smallBoxColor = greenThree;
    } else if (korMealType == '점심') {
      smallBoxColor = yellowSeven;
    } else if (korMealType == '저녁') {
      smallBoxColor = blueSeven;
    }

    if (controller.getMealKind("eng", true) == engMealType) {
      bigBoxColor = blueOne;
      mealTextStyle = mealTextStyle.copyWith(color: Colors.white);
      boxShadow = [
        BoxShadow(
          offset: Offset(0, 5),
          blurRadius: 20,
          color: grayEight,
        ),
      ];
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: _width * 0.866,
          height: _height * 0.21,
        ),
        Positioned(
          top: _height * 0.1,
          child: Container(
            width: _width * 0.866,
            height: _height * 0.07,
            decoration: BoxDecoration(
              color: bigBoxColor,
              borderRadius: BorderRadius.circular(13),
              boxShadow: boxShadow,
            ),
          ),
        ),
        Container(
          width: _width * 0.866,
          height: _height * 0.17,
          decoration: BoxDecoration(
            color: bigBoxColor,
            borderRadius: BorderRadius.circular(13)
          ),
          child: Center(
              child: SizedBox(
                width: _width * 0.77,
                child: Text(data["$index"][engMealType], style: mealTextStyle, textAlign: TextAlign.center),
              )
          ),
        ),
        Positioned(
          top: 0,
          left: _height * 0.04,
          child: Container(
            width: _width * 0.2,
            height: _height * 0.04,
            decoration: BoxDecoration(
                color: smallBoxColor,
                borderRadius: BorderRadius.circular(4)
            ),
            child: Row(
              children: [
                SizedBox(width: _width * 0.02),
                SvgPicture.asset(
                  'assets/images/mealPlanner_$engMealType.svg',
                  width: _width * 0.06,
                ),
                SizedBox(width: _width * 0.02),
                Text(korMealType, style: mealPlannerMealType)
              ],
            ),
          ),
        ),
      ],
    );
  }
}