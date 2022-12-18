import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak/screens/meal_planner/meal_planner_tabbar.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:flutter/material.dart';
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: FutureBuilder(
              future: controller.getMealPlanner(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return MealPlannerTabBar(plannerData: (snapshot.data as Map));
                } else if (snapshot.hasError) { //데이터를 정상적으로 불러오지 못했을 때
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(width: _width, height: _height * 0.835),
                      Center(child: Text("데이터를 정상적으로 불러오지 못했습니다. \n다시 시도해 주세요.", textAlign: TextAlign.center)),
                    ],
                  );
                } else { //데이터를 불러오는 중
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(width: _width, height: _height * 0.835),
                      Center(child: CircularProgressIndicator()),
                    ],
                  );
                }
              }
          ),
        ),
      )
    );
  }
}