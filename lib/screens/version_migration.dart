import 'package:dalgeurak/screens/widgets/blue_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/meal_controller.dart';
import '../controllers/qrcode_controller.dart';
import '../controllers/user_controller.dart';
import '../themes/text_theme.dart';

class VersionMigration extends StatelessWidget {
  VersionMigration({Key? key}) : super(key: key);

  late MealController mealController;
  late UserController userController;
  late QrCodeController qrCodeController;
  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(width: _width, height: _height),
              Positioned(
                top: _height * 0.1,
                left: -(_width * 0.1),
                child: RotationTransition(
                  turns: AlwaysStoppedAnimation(36 / 360),
                  child: Lottie.asset(
                    'assets/lotties/waveBackground.json',
                    repeat: true,
                    width: _width
                  )
                ),
              ),
              Positioned(
                top: _height * 0.7,
                child: RotationTransition(
                    turns: AlwaysStoppedAnimation(36 / 360),
                    child: Lottie.asset(
                        'assets/lotties/waveBackground.json',
                        repeat: true,
                        width: _width
                    )
                ),
              ),
              Positioned(
                bottom: _height * 0.15,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: _width * 0.9,
                      height: _height * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("알림", style: migrationTitle),
                            SizedBox(height: _height * 0.03),
                            Text("달그락 어플리케이션이 리뉴얼 되었습니다.\n확인을 누르면 디미고인\n계정 로그인 페이지로 돌아갑니다.", style: migrationDescription),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: _height * 0.25),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: BlueButton(content: "확인", isLong: true, isFill: true),
                    )
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}