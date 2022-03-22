import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminPage extends GetWidget<MealController> {
  AdminPage({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor: blueThree,
      body: Center(
          child: FutureBuilder(
              future: controller.getGradeLeftPeopleAmount(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: _height * 0.1,
                        left: _width * 0.1,
                        child: Text("남은인원", style: adminPageLeftPeopleTitle),
                      ),
                      Positioned(
                        top: _height * 0.14,
                        left: _width * 0.1,
                        child: Text("${snapshot.data}명", style: adminPageLeftPeopleAmount),
                      ),
                      Positioned(
                        top: _height * 0.225,
                        left: _width * 0.1,
                        child: SizedBox(
                          width: _width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "세부 현황",
                                  style: adminPageLeftPeopleDetailTitle
                              ),
                              Icon(Icons.swap_vert_rounded, size: _width * 0.08)
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: _height * 0.275,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            gradeDetailBox(1, controller.classLeftPeople),
                            SizedBox(height: _height * 0.0275),
                            gradeDetailBox(2, controller.classLeftPeople),
                            SizedBox(height: _height * 0.0275),
                            gradeDetailBox(3, controller.classLeftPeople),
                          ],
                        ),
                      ),
                    ],
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
      ),
    );
  }

  Container gradeDetailBox(int grade, Map studentNumData) {
    return Container(
      width: _width * 0.898,
      height: _height * 0.192,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        color: Colors.white
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: _height * 0.025,
            left: _width * 0.07,
            child: Text(
              "$grade학년",
              style: adminPageGradeBoxTitle,
            ),
          ),
          Positioned(
            top: _height * 0.025,
            right: _width * 0.07,
            child: Text(
              "남은 인원 ${studentNumData[grade]["totalPeople"]}명",
              style: adminPageGradeBoxLeftPeople,
            ),
          ),
          Positioned(
            top: _height * 0.075,
            left: _width * 0.06,
            child: SizedBox(
              width: _width * 0.65,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  classBoxInGradeContainer(grade, 1, studentNumData),
                  classBoxInGradeContainer(grade, 3, studentNumData),
                  classBoxInGradeContainer(grade, 5, studentNumData),
                ],
              )
            )
          ),
          Positioned(
            top: _height * 0.13,
            left: _width * 0.2,
            child: SizedBox(
                width: _width * 0.65,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    classBoxInGradeContainer(grade, 2, studentNumData),
                    classBoxInGradeContainer(grade, 4, studentNumData),
                    classBoxInGradeContainer(grade, 6, studentNumData),
                  ],
                )
            )
          )
        ],
      ),
    );
  }

  Container classBoxInGradeContainer(int grade, int classNum, Map studentNumData) {
    late double percentage;
    if (studentNumData[grade][classNum]["totalAmount"] != null) {
      percentage = studentNumData[grade][classNum]["leftPeople"] / studentNumData[grade][classNum]["totalAmount"];
    } else {
      percentage = 1;
    }

    return Container(
      width: _width * 0.11,
      height: _width * 0.11,
      decoration: BoxDecoration(
          color: grayThree,
          borderRadius: BorderRadius.circular(5)
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text("$classNum반", style: adminPageClassBoxTitle),
          Positioned(
            bottom: 0,
            child: Container(
                width: _width * 0.11,
                height: (_width * 0.11) * percentage,
                decoration: BoxDecoration(
                    color: percentage == 1 ? blueOne : yellowFive,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: grayShadowFour,
                        blurRadius: 20,
                        offset: Offset(0, 5)
                      )
                    ]
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text("$classNum반", style: adminPageClassBoxTitle),
                  ],
                )
            ),
          )
        ],
      )
    );
  }
}