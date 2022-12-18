import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak_widget_package/widgets/window_title.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tab_bar/library.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../services/meal_info.dart';
import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';

class MealPlannerTabBar extends StatefulWidget {
  Map plannerData;
  MealPlannerTabBar({Key? key, required this.plannerData}) : super(key: key);

  @override
  _MealPlannerTabBarState createState() => _MealPlannerTabBarState(plannerData: plannerData);
}

class _MealPlannerTabBarState extends State<MealPlannerTabBar> {
  Map plannerData;
  _MealPlannerTabBarState({required this.plannerData});


  late MealController _mealController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _mealController = Get.find<MealController>();

    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 36),
        Obx(() {
          int index = _mealController.mealPlannerCurrentPageIndex.value;
          Map correctDate = Get.find<MealController>().dalgeurakService.getCorrectDate((DateTime.now().day - (DateTime.now().weekday - 1)) + index);

          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: Get.width * 0.1),
              WindowTitle(subTitle: "급식", title: "${correctDate["month"]}월 ${correctDate["day"]}일"),
            ],
          );
        }),
        const SizedBox(height: 32),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25)
          ),
          width: Get.width * 0.897,
          height: 45,
          child: Center(
            child: CustomTabBar(
              itemCount: 7,
              tabBarController: _mealController.mealPlannerTabBarController,
              pageController: _mealController.mealPlannerPageController,
              height: 40,
              width: Get.width * 0.9,
              indicator: RoundIndicator(
                color: dalgeurakBlueOne,
                top: 2.5,
                bottom: 2.5,
                left: 2.5,
                right: 2.5,
                radius: BorderRadius.circular(21),
              ),
              builder: getTabBarChild,
            ),
          ),
        ),
        const SizedBox(height: 26),
        SizedBox(
          width: Get.width,
          height: Get.height,
          child: PageView.builder(
            controller: _mealController.mealPlannerPageController,
            itemCount: 7,
            onPageChanged: (index) => _mealController.mealPlannerCurrentPageIndex.value = index,
            itemBuilder: (context, index) {
              return Center(child: mealPlannerView((index+1)));
            },
          ),
        ),
      ],
    );
  }

  Widget getTabBarChild(BuildContext context, int index) {
    return TabBarItem(
      transform: ColorsTransform(
          highlightColor: Colors.white,
          normalColor: dalgeurakGrayTwo,
          builder: (context, color) {
            return Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(minWidth: (Get.width / 7.8)),
              child: Text(
                _mealController.weekDay[(index+1)],
                style: mealPlannerTabDate.copyWith(color: color),
              ),
            );
          }),
      index: index
    );
  }

  Widget mealPlannerView(int index) {
    Map correctDate = Get.find<MealController>().dalgeurakService.getCorrectDate((DateTime.now().day - (DateTime.now().weekday - 1)) + (index-1));

    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        mealPlannerPanel(plannerData, index, MealType.breakfast),
        SizedBox(height: Get.height * 0.0165),
        mealPlannerPanel(plannerData, index, MealType.lunch),
        SizedBox(height: Get.height * 0.0165),
        mealPlannerPanel(plannerData, index, MealType.dinner),
      ],
    ));
  }

  Stack mealPlannerPanel(Map data, int index, MealType mealType) {
    Color smallBoxColor = emptyColor;
    Color bigBoxColor = Colors.white;
    TextStyle mealTextStyle = mealPlannerContent;

    if (mealType == MealType.breakfast) {
      smallBoxColor = greenThree;
    } else if (mealType == MealType.lunch) {
      smallBoxColor = yellowSeven;
    } else if (mealType == MealType.dinner) {
      smallBoxColor = blueSeven;
    }

    if (_mealController.nowMealType.value == mealType) {
      bigBoxColor = dalgeurakBlueOne;
      mealTextStyle = mealTextStyle.copyWith(color: Colors.white);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: Get.width * 0.897,
          height: kIsWeb ? Get.height * 0.21 : 164,
          decoration: BoxDecoration(
              color: bigBoxColor,
              borderRadius: BorderRadius.circular(13)
          ),
          child: Center(
            child: SizedBox(
              width: Get.width * 0.76,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 70,
                    height: 25,
                    decoration: BoxDecoration(
                        color: smallBoxColor,
                        borderRadius: BorderRadius.circular(4)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/mealPlanner_${mealType.convertEngStr}.svg',
                          width: 18,
                        ),
                        SizedBox(width: 8),
                        Text(mealType.convertKorStr, style: mealPlannerMealType)
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(data["$index"][mealType.convertEngStr], style: mealTextStyle.copyWith(fontSize: (Get.width > 1000 ? 15 : 13)), textAlign: TextAlign.start)
                ],
              ),
            ),
          )
        ),
      ],
    );
  }
}
