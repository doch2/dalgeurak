import 'dart:ui';

import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:dalgeurak_widget_package/widgets/blue_button.dart';
import 'package:dalgeurak_widget_package/widgets/reason_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterNotice extends GetWidget<MealController> {
  RegisterNotice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueThree,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("공지사항을 등록하세요", style: pageTitle1),
              const SizedBox(height: 48),
              ReasonTextField(hintText: "등록할 공지사항을 입력해주세요.", textController: controller.noticeTextController, isBig: true, isEnable: true),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () => controller.setNotice(controller.noticeTextController.text),
                child: BlueButton(content: "등록", isLong: false, isSmall: false, isFill: true, isDisable: false),
              )
            ],
          )
      ),
    );
  }
}