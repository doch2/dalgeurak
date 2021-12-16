import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserLateAmount extends GetWidget<UserController> {
  UserLateAmount({Key? key}) : super(key: key);

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
                child: Text("누적 0회", style: myProfileSubTitle)
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: _width,
                    height: _height * 0.62,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13)),
                        color: Colors.white
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      ],
                    ),
                  )
              )
            ],
          )
      ),
    );
  }

  SizedBox menuWidget(List<Widget> childWidget) {
    return
      SizedBox(
        height: _height * 0.1,
        width: _width * 0.8,
        child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: childWidget,
            )
        ),
      );
  }
}