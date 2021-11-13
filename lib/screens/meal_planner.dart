import 'package:dalgeurak/controllers/mealplanner_controller.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MealPlanner extends GetWidget<MealPlannerController> {
  MealPlanner({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
                future: controller.getMealPlanner(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      width: _width * 0.95,
                      height: _height * 0.83,
                      child: DefaultTabController(
                        length: 7,
                        initialIndex: (DateTime.now().weekday-1),
                        child: Scaffold(
                          appBar: PreferredSize(
                            preferredSize: Size.fromHeight(kToolbarHeight),
                            child: Container(
                              height: 50.0,
                              child: TabBar(
                                labelStyle: mealPlannerDate,
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
                    return Column(
                      children: [
                        Text("데이터를 정상적으로 불러오지 못했습니다. \n다시 시도해 주세요.", textAlign: TextAlign.center)
                      ],
                    );
                  } else { //데이터를 불러오는 중
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(child: CircularProgressIndicator()),
                      ],
                    );
                  }
                }
            ),
          ],
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
      result.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: _height * 0.02),
            Row(
              children: [
                SizedBox(width: _width * 0.025),
                Text(
                    "${DateTime.now().month}월 ${(DateTime.now().day - (DateTime.now().weekday - 1)) + (i-1)}일 ${controller.weekDay[i]}요일",
                    style: mealPlannerDate
                ),
              ],
            ),
            SizedBox(height: _height * 0.045),
            mealPlannerPannel(data, i, "breakfast", "아침"),
            SizedBox(height: _height * 0.06),
            mealPlannerPannel(data, i, "lunch", "점심"),
            SizedBox(height: _height * 0.06),
            mealPlannerPannel(data, i, "dinner", "저녁"),
          ],
        )
      );
    }

    return result;
  }

  Column mealPlannerPannel(Map data, int index, String engMealType, String korMealType) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: _width * 0.025),
            Container(
              width: _width * 0.0075,
              height: _height * 0.055,
              decoration: BoxDecoration(
                color: yellowOne,
              ),
            ),
            SizedBox(width: _width * 0.02),
            Text(
              korMealType,
              style: mealPlannerMealType,
            ),
          ],
        ),
        SizedBox(height: _height * 0.025),
        SizedBox(
            height: _height * 0.1,
            width: _width * 0.775,
            child: Text(data["$index"][engMealType], style: mealPlannerContent, textAlign: TextAlign.center)
        ),
      ],
    );
  }
}