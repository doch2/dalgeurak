import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SignUpStudentInfo extends GetWidget<AuthController> {
  const SignUpStudentInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    final gradeTextController = TextEditingController();
    final classTextController = TextEditingController();
    final numberTextController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: _width * 0.2,
                  child: TextField(
                      controller: gradeTextController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '학년',
                      ),
                      style: signup_student_info
                  ),
                ),
                SizedBox(
                  width: _width * 0.2,
                  child: TextField(
                      controller: classTextController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '반',
                      ),
                      style: signup_student_info
                  ),
                ),
                SizedBox(
                  width: _width * 0.2,
                  child: TextField(
                      controller: numberTextController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '번호',
                      ),
                      style: signup_student_info
                  ),
                ),
              ],
            ),
            SizedBox(height: _height * 0.25),
            GestureDetector(
              onTap: () {
                controller.loginUserInfo["grade"] = int.parse(gradeTextController.text);
                controller.loginUserInfo["class"] = int.parse(classTextController.text);
                controller.loginUserInfo["number"] = int.parse(numberTextController.text);

                controller.writeAccountInfo();
                controller.addStudentInfo();
              },
              child: Container(
                height: _height * 0.075,
                width: _width * 0.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF2c2c2c).withOpacity(0.1),
                        spreadRadius: 4,
                        blurRadius: 10,
                      )
                    ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "가입하기",
                        style: TextStyle(
                            fontSize: 18, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900)
                    )
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
