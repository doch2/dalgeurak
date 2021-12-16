import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dalgeurak/services/check_text_validate.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SignUpStudentInfo extends GetWidget<AuthController> {
  SignUpStudentInfo({Key? key}) : super(key: key);

  static GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  final studentNumTextController = TextEditingController();
  final nameTextController = TextEditingController();

  final FocusNode studentNumFocus = new FocusNode();
  final FocusNode nameFocus = new FocusNode();

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SafeArea(
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
                      "정보를 입력해 주세요.",
                      style: signup_student_info_description,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: _height * 0.45,
                child: Form(
                    key: formKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: _width * 0.25,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: studentNumTextController,
                            focusNode: studentNumFocus,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                              labelText: "학번",
                              labelStyle: signup_student_info_textfield,
                            ),
                            validator: (value) {
                              CheckTextValidate().validateStudentNum(studentNumFocus, value!);
                              formKey.currentState!.save();
                            },
                          ),
                        ),
                        SizedBox(width: _width * 0.085),
                        SizedBox(
                          width: _width * 0.25,
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            controller: nameTextController,
                            focusNode: nameFocus,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                              labelText: "이름",
                              labelStyle: signup_student_info_textfield,
                            ),
                            validator: (value) => CheckTextValidate().validateName(nameFocus, value!),
                          ),
                        )
                      ],
                    )
                ),
              ),
              Positioned(
                top: _height * 0.825,
                child: GestureDetector(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      controller.loginUserInfo["grade"] = int.parse(studentNumTextController.text.substring(0, 1));
                      controller.loginUserInfo["class"] = int.parse(studentNumTextController.text.substring(1, 2));
                      controller.loginUserInfo["number"] = int.parse(studentNumTextController.text.substring(2));
                      controller.loginUserInfo["name"] = nameTextController.text;

                      controller.writeAccountInfo();
                      controller.addStudentInfo();
                    }
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
                    child: Center(child: Text("가입하기", style: signupNextBtn)),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
