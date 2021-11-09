import 'package:dalgeurak/controllers/mealplanner_controller.dart';
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
                      width: _width,
                      height: _height * 0.8,
                      child: DefaultTabController(
                        length: 7,
                        child: Scaffold(
                          appBar: PreferredSize(
                            preferredSize: Size.fromHeight(kToolbarHeight),
                            child: Container(
                              height: 50.0,
                              child: TabBar(
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
        Tab(child: Text(controller.weekDay[i], style: mealPlannerTabText)),
      );
    }

    return result;
  }

  List<Widget> mealPlannerView(Map data) {
    List<Widget> result = [];

    for (int i=1; i<=7; i++) {
      result.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${DateTime.now().month}월 ${(DateTime.now().day - (DateTime.now().weekday - 1)) + (i-1)}일 ${controller.weekDay[i]}요일 급식이에요!",
              style: mealPlannerTitle
            ),
            SizedBox(
                height: _height * 0.1,
                width: _width,
                child: Text(data["$i"]["breakfast"])
            ),
            SizedBox(
                height: _height * 0.1,
                width: _width,
                child: Text(data["$i"]["lunch"])
            ),
            SizedBox(
                height: _height * 0.1,
                width: _width,
                child: Text(data["$i"]["dinner"])
            ),
          ],
        )
      );
    }

    return result;
  }
}