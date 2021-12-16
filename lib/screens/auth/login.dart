import 'dart:io';

import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dalgeurak/themes/color_theme.dart';
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: _width,
              height: _height,
              decoration: BoxDecoration(
                color: blueOne,
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                width: _width,
                height: _height * 0.93,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      width: _width * 0.25,
                      height: _width * 0.25,
                    ),
                    SizedBox(height: _height * 0.01),
                    Text("달그락", style: loginTitle),
                    Text("편리한 급식 시간의 시작", style: loginSubTitle),
                    SizedBox(height: _height * 0.125),
                    GestureDetector(
                      onTap: () => {controller.signInWithGoogle()},
                      child: Container(
                        width: _width * 0.842,
                        height: _height * 0.08,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: grayShadowTwo,
                                  blurRadius: 10,
                                  offset: Offset(0, -1)
                              ),
                              BoxShadow(
                                  color: grayShadowTwo,
                                  blurRadius: 10,
                                  offset: Offset(0, 5)
                              )
                            ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: _width * 0.1),
                            SvgPicture.asset(
                              'assets/images/googleIcon.svg',
                              width: _width * 0.07,
                            ),
                            SizedBox(width: _width * 0.15),
                            Text("구글로 로그인", style: loginBoxTitle)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: _height * 0.025),
                    GestureDetector(
                      onTap: () {
                        if (Platform.isAndroid) {
                          Get.snackbar('애플 로그인 오류', '현재 안드로이드 기기에서 \n애플 로그인은 지원되지 않습니다.', snackPosition: SnackPosition.BOTTOM);
                        } else if (Platform.isIOS) {
                          controller.signInWithApple();
                        }
                      },
                      child: Container(
                        width: _width * 0.842,
                        height: _height * 0.08,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: grayShadowTwo,
                                  blurRadius: 10,
                                  offset: Offset(0, -1)
                              ),
                              BoxShadow(
                                  color: grayShadowTwo,
                                  blurRadius: 10,
                                  offset: Offset(0, 5)
                              )
                            ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: _width * 0.1),
                            SvgPicture.asset(
                              'assets/images/appleIcon.svg',
                              width: _width * 0.07,
                            ),
                            SizedBox(width: _width * 0.15),
                            Text("Apple로 로그인", style: loginBoxTitle)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: _height * 0.025),
                    GestureDetector(
                      onTap: () => controller.signInWithKakao(),
                      child: Container(
                        width: _width * 0.842,
                        height: _height * 0.08,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: yellowFour,
                            boxShadow: [
                              BoxShadow(
                                  color: grayShadowTwo,
                                  blurRadius: 10,
                                  offset: Offset(0, -1)
                              ),
                              BoxShadow(
                                  color: grayShadowTwo,
                                  blurRadius: 10,
                                  offset: Offset(0, 5)
                              )
                            ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: _width * 0.1),
                            SvgPicture.asset(
                              'assets/images/kakaoIcon.svg',
                              width: _width * 0.07,
                            ),
                            SizedBox(width: _width * 0.15),
                            Text("카카오톡으로 로그인", style: loginBoxTitle)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
