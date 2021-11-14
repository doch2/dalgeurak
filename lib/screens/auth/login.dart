import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Login extends GetWidget<AuthController> {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: _width * 0.336,
              height: _width * 0.336,
            ),
            SizedBox(height: _height * 0.05),
            Text("달그락", style: loginTitle),
            SizedBox(height: _height * 0.175),
            GestureDetector(
              onTap: () => {controller.signInWithGoogle()},
              child: Container(
                width: _width * 0.842,
                height: _height * 0.08,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xF000000), width: 1),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: _width * 0.1),
                    SvgPicture.asset(
                      'assets/images/googleIcon.svg',
                      width: _width * 0.08,
                    ),
                    SizedBox(width: _width * 0.15),
                    Text("Google로 로그인", style: loginBoxTitle)
                  ],
                ),
              ),
            ),
            SizedBox(height: _height * 0.01),
            GestureDetector(
              onTap: () => Get.snackbar('애플 로그인 오류', '현재 애플 로그인은 지원되지 않습니다.', snackPosition: SnackPosition.BOTTOM),
              child: Container(
                width: _width * 0.842,
                height: _height * 0.08,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xF000000), width: 1),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: _width * 0.1),
                    SvgPicture.asset(
                      'assets/images/appleIcon.svg',
                      width: _width * 0.08,
                    ),
                    SizedBox(width: _width * 0.15),
                    Text("Apple로 로그인", style: loginBoxTitle)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
