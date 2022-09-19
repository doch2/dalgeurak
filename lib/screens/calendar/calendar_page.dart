import 'dart:ui';

import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends GetWidget<MealController> {
  CalendarPage({Key? key}) : super(key: key);

  RxList<Map> items = [
    {
      "date": DateTime.utc(2022, 09, 05),
      "breakfast": "위탁",
      "lunch": "직영",
      "dinner": "위탁"
    },
    {
      "date": DateTime.utc(2022, 09, 06),
      "breakfast": "위탁",
      "lunch": "직영",
      "dinner": "위탁"
    },
    {
      "date": DateTime.utc(2022, 09, 07),
      "breakfast": "위탁",
      "lunch": "직영",
      "dinner": "위탁"
    },
    {
      "date": DateTime.utc(2022, 09, 08),
      "breakfast": "위탁",
      "lunch": "직영",
      "dinner": "위탁"
    },
    {
      "date": DateTime.utc(2022, 09, 09),
      "breakfast": "위탁",
      "lunch": "직영",
      "dinner": "위탁"
    },
    {
      "date": DateTime.utc(2022, 09, 10),
      "breakfast": "위탁",
      "lunch": "직영",
      "dinner": "전체귀가"
    },
  ].obs;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    items.insert(0, {
      "date": (items[0]['date'] as DateTime).add(Duration(days: -1)),
      "breakfast": "위탁",
      "lunch": "직영",
      "dinner": "전체귀가"
    } as Map);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add({
      "date": (items[items.length-1]['date'] as DateTime).add(Duration(days: 1)),
      "breakfast": "위탁",
      "lunch": "직영",
      "dinner": "전체귀가"
    } as Map);
    _refreshController.loadComplete();
  }


  @override
  Widget build(BuildContext context) {
    Rx<CalendarFormat> _calendarFormat = CalendarFormat.month.obs;
    Rx<DateTime> _focusedDay = DateTime.now().obs;
    Rx<DateTime> _selectedDay = _focusedDay.value.obs;


    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(width: Get.width, height: Get.height * 0.51),
                  Positioned(
                    top: 105,
                    child: Obx(() => SizedBox(
                      width: Get.width * 0.9,
                      child: TableCalendar(
                        focusedDay: _focusedDay.value,
                        firstDay: DateTime.utc(2010, 1, 1),
                        lastDay: DateTime.utc(2030, 1, 1),
                        calendarBuilders: CalendarBuilders(
                          headerTitleBuilder: (context, dateTime) {
                            return Row(
                              children: [
                                Text("${dateTime.year}년 ", style: calendar_headerTitle),
                                Text("${dateTime.month}월", style: calendar_headerTitle.copyWith(fontWeight: FontWeight.w700))
                              ],
                            );
                          }
                        ),
                        calendarStyle: CalendarStyle(
                          defaultTextStyle: calendar_dateNum,
                          selectedTextStyle: calendar_dateNum.copyWith(color: Colors.white),
                          selectedDecoration: BoxDecoration(
                              color: dalgeurakBlueOne,
                              borderRadius: BorderRadius.circular(5)
                          ),
                          defaultDecoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                          weekendDecoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                          outsideDecoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                        ),
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay.value, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          _selectedDay.value = selectedDay;
                          _focusedDay.value = focusedDay;
                        },
                        calendarFormat: _calendarFormat.value,
                        onFormatChanged: (format) {
                          _calendarFormat.value = format;
                        },
                      ),
                    )),
                  ),
                  Positioned(
                    top: 120,
                    child: Container(
                      width: Get.width,
                      height: 0,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: Get.width,
                    height: 115,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                        color: dalgeurakBlueOne
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          bottom: 20,
                          child: SizedBox(
                            width: Get.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Text("1학년", style: calendar_headerTitle.copyWith(color: Colors.white)),
                                    Icon(Icons.arrow_drop_down_rounded, color: Colors.white, size: 36)
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => print("onClick"),
                                  child: Container(
                                    width: 75,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(2)
                                    ),
                                    child: Center(
                                      child: Text("일정 만들기", style:  calendar_makeScheduleButton),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                ],
              ),
              Container(
                width: Get.width,
                height: 30,
                decoration: BoxDecoration(
                  color: dalgeurakGrayOne
                ),
                child: Row(
                  children: [
                    SizedBox(width: 24),
                    Text("${_selectedDay.value.year}년 ${_selectedDay.value.month}월 조식 급식비 : 72,930원 석식 급식비 : 61,710원")
                  ],
                ),
              ),
              SizedBox(height: 4),
              SizedBox(
                width: Get.width,
                height: 300,
                child: Obx(() => SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: WaterDropHeader(
                    idleIcon: Icon(Icons.arrow_upward_rounded, size: 15, color: Colors.white),
                    completeDuration: Duration(),
                    complete: SizedBox(),
                  ),
                  footer: ClassicFooter(),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: ListView.builder(
                    itemBuilder: (c, i) {
                      Map info = items[i];

                      return Column(
                        children: [
                          Container(
                            width: Get.width,
                            height: 65,
                            color: Colors.white,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  left: Get.width * 0.1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${(info['date'] as DateTime).day}", style: calendar_todayBox_dayNum),
                                      Text("${controller.weekDay[(info['date'] as DateTime).weekday]}요일", style: calendar_todayBox_dayWeekStr)
                                    ],
                                  ),
                                ),
                                Positioned(
                                  left: (Get.width * 0.35) - ((info['breakfast'] as String).length * 3.5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("조식", style: calendar_todayBox_mealType),
                                      Text("${info['breakfast']}", style: calendar_todayBox_schedule),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  left: (Get.width * 0.55) - ((info['lunch'] as String).length * 3.5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("중식", style: calendar_todayBox_mealType),
                                      Text("${info['lunch']}", style: calendar_todayBox_schedule),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  left: (Get.width * 0.75) - ((info['dinner'] as String).length * 3.5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("석식", style: calendar_todayBox_mealType),
                                      Text("${info['dinner']}", style: calendar_todayBox_schedule),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(color: Colors.white, width: Get.width, child: Divider(color: dalgeurakGrayOne, thickness: 1.0))
                        ],
                      );
                    },
                    itemCount: items.length,
                  ),
                )),
              ),
            ],
          )
      ),
    );
  }
}