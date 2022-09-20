import 'dart:ui';

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
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new ExactAssetImage('assets/images/adminpage_screenshot.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: new BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: new Container(
                    decoration: new BoxDecoration(color: Colors.black.withOpacity(0.5)),
                  ),
                ),
              ),
              Text("체크인 기능이 도입되지 않아,\n본 페이지는 현재 사용되지 않습니다.", textAlign: TextAlign.center, style: adminPageDescription),
            ],
          )
      ),
    );
  }
}