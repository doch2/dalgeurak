import 'package:dalgeurak_widget_package/widgets/blue_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/auth_controller.dart';
import '../../themes/text_theme.dart';

class LoginSuccess extends GetWidget<AuthController> {
  LoginSuccess({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    controller.loginSuccessScreenAnimate(_height, _width);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Obx(() => Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(width: _width, height: _height),
            AnimatedPositioned(
              top: controller.helloTextPositioned.value,
              duration: Duration(milliseconds: 600),
              curve: Curves.fastOutSlowIn,
              child: Text(
                "${controller.userController.user?.name}님,\n반갑습니다!",
                textAlign: TextAlign.center,
                style: (controller.helloTextPositioned.value == _height * 0.6) ? loginSuccessTitle.copyWith(color: Colors.white) : loginSuccessTitle,
              ),
            ),
            AnimatedPositioned(
              top: controller.subTitlePositioned['top'],
              left: controller.subTitlePositioned['left'],
              duration: Duration(milliseconds: 600),
              curve: Curves.fastOutSlowIn,
              child: Text("가입 완료", style: (controller.subTitlePositioned['top'] == _height * 0.5) ? loginSuccessSubtitle.copyWith(color: Colors.white) : loginSuccessSubtitle),
            ),
            AnimatedPositioned(
              top: controller.successCheckIconPositioned['top'],
              left: controller.successCheckIconPositioned['left'],
              duration: Duration(milliseconds: 600),
              curve: Curves.fastOutSlowIn,
              child: AnimatedContainer(
                width: _width * controller.successCheckIconSize.value,
                height: _width * controller.successCheckIconSize.value,
                duration: Duration(milliseconds: 600),
                curve: Curves.fastOutSlowIn,
                child: Lottie.asset('assets/lotties/successCircle.json', repeat: false),
              ),
            ),
            AnimatedPositioned(
              bottom: controller.btnContainerPositioned.value,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: BlueButton(content: "서비스로 돌아가기", isLong: true, isFill: true, isSmall: false, isDisable: false)
              )
            )
          ],
        )),
      ),
    );
  }
}
