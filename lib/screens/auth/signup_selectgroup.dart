import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dalgeurak/screens/auth/signup_studentinfo.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpSelectGroup extends GetWidget<AuthController> {
  const SignUpSelectGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(width: _width, height: _height),
            Positioned(
              top: _height * 0.1,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: _width * 0.15,
                    height: _width * 0.15,
                  ),
                  SizedBox(height: _height * 0.04),
                  Text(
                    "본인 소속을 선택해 주세요.",
                    style: signup_student_info_description,
                  ),
                ],
              ),
            ),
            Positioned(
              top: _height * 0.875,
              child: GestureDetector(
                onTap: () {
                  controller.loginUserInfo["group"] = controller.selectGroupName.value;
                  Get.off(SignUpStudentInfo());
                },
                child: Container(
                  width: _width * 0.861,
                  height: _height * 0.075,
                  decoration: BoxDecoration(
                      color: blueOne,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: blueTwo,
                            blurRadius: 10
                        )
                      ]
                  ),
                  child: Center(child: Text("다음", style: signupNextBtn)),
                ),
              ),
            ),
            Positioned(
              top: _height * 0.235,
              child: Column(
                children: [
                  SizedBox(height: _height * 0.15),
                  Obx(() => groupSelectBtn("학생", "student", _height, _width)),
                  SizedBox(height: _height * 0.05),
                  Obx(() => groupSelectBtn("디넌", "dienen", _height, _width)),
                  SizedBox(height: _height * 0.05),
                  Obx(() => groupSelectBtn("선생님", "teacher", _height, _width)),
                  SizedBox(height: _height * 0.15),
                ],
              ),
            )
          ],
        )
      ),
    );
  }

  GestureDetector groupSelectBtn(String btnText, String group, double _height, double _width) {
    Color shapeColor = graySix;
    Color shadowColor = grayShadowThree;
    TextStyle textStyle = signupGroupSelectBtn;

    if (controller.selectGroupName.value == group) {
      shapeColor = yellowFive;
      shadowColor = yellowSix;

      textStyle = textStyle.copyWith(color: Colors.white);
    }

    return GestureDetector(
      onTap: () {
        controller.selectGroupName.value = group;
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(_width * 0.746, (_width * 0.141).toDouble()),
            painter: groupBtnCustomShape(shapeColor: shapeColor, shadowColor: shadowColor),
          ),
          Text(
              btnText,
              style: textStyle
          )
        ],
      ),
    );
  }
}

class groupBtnCustomShape extends CustomPainter {
  Color shapeColor, shadowColor;

  groupBtnCustomShape({required this.shapeColor, required this.shadowColor});

  @override
  void paint(Canvas canvas, Size size) {

    Path path_0 = Path();
    path_0.moveTo(size.width*0.9018536,0);
    path_0.lineTo(0,0);
    path_0.lineTo(0,size.height);
    path_0.lineTo(size.width*0.9018536,size.height);
    path_0.lineTo(size.width,size.height*0.4687500);
    path_0.lineTo(size.width*0.9018536,0);

    canvas.drawShadow(path_0, shadowColor, 6.0, false);

    path_0.close();

    Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
    paint_0_fill.color = shapeColor.withOpacity(1.0);
    canvas.drawPath(path_0,paint_0_fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
