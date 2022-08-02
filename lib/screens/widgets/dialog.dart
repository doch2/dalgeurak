import 'package:dalgeurak/screens/widgets/blue_button.dart';
import 'package:dalgeurak/screens/widgets/checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';

class DalgeurakDialog {
  RxBool isNoticeDialogNeverShow = false.obs;

  showWarning(String message, String subMessage, dynamic executeFunc) {
    Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          child: Container(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(width: Get.width * 0.851, height: Get.height * 0.2),
                Positioned(
                  top: Get.height * 0.02,
                  child: Text("Warning", style: dialogTitle)
                ),
                Positioned(
                  top: Get.height * 0.07,
                  child: Text(
                    message,
                    style: warningDialog_message,
                  ),
                ),
                Positioned(
                  top: Get.height * 0.105,
                  child: Text(subMessage, style: warningDialog_subMessage),
                ),
                Positioned(
                    bottom: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            width: Get.width * 0.4,
                            height: 44,
                            decoration: BoxDecoration(
                                color: dalgeurakGrayThree,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16))
                            ),
                            child: Center(child: Text("취소", style: dialogBtn)),
                          ),
                        ),
                        GestureDetector(
                          onTap: executeFunc,
                          child: Container(
                            width: Get.width * 0.4,
                            height: 44,
                            decoration: BoxDecoration(
                                color: dalgeurakBlueOne,
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(16))
                            ),
                            child: Center(child: Text("확인", style: dialogBtn)),
                          ),
                        ),
                      ],
                    ),
                ),
              ],
            ),
          ),
        )
    );
  }

  showNotice(String message, String btnName, dynamic executeFunc) => Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: SizedBox(
          height: Get.height * 0.27,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16))
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(width: Get.width * 0.851, height: Get.height * 0.23),
                    Positioned(
                        top: Get.height * 0.02,
                        child: Text("Notice", style: dialogTitle)
                    ),
                    Positioned(
                      top: Get.height * 0.07,
                      child: Text(
                        message,
                        style: noticeDialog_message,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: GestureDetector(
                        onTap: executeFunc,
                        child: Container(
                          width: Get.width * 0.8,
                          height: 44,
                          decoration: BoxDecoration(
                              color: dalgeurakBlueOne,
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))
                          ),
                          child: Center(child: Text(btnName, style: dialogBtn)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: Get.width * 0.755,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => GestureDetector(
                          onTap: () => isNoticeDialogNeverShow.value = !(isNoticeDialogNeverShow.value),
                          child: DalgeurakCheckBox(content: "다시 보지않기", isOn: isNoticeDialogNeverShow.value, checkBoxType: DalgeurakCheckBoxType.dialog))),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text("닫기", style: noticeDialog_menu.copyWith(decoration: TextDecoration.underline))
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
  );

  showInquiry() => Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))
      ),
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(width: Get.width * 0.851, height: Get.height * 0.26),
            Positioned(
              top: Get.height * 0.03,
              left: Get.width * 0.08,
              child: Text("문의하기", style: dialogTitle)
            ),
            Positioned(
              top: Get.height * 0.06,
              child: Container(width: Get.width * 0.64, child: Divider(color: dalgeurakGrayOne, thickness: 1.0))
            ),
            Positioned(
              top: Get.height * 0.09,
              left: Get.width * 0.08,
              child: Text("문의사항은 아래 연락처로 보내주시면\n빠른 시일 내로 답변 드리도록 하겠습니다."),
            ),
            Positioned(
              top: Get.height * 0.145,
              left: Get.width * 0.08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("E-mail", style: inquiryDialog_emailTitle),
                  SizedBox(width: 4),
                  Text("dimigoin2022@dimigo.hs.kr", style: inquiryDialog_emailAddress)
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: Get.width * 0.8,
                  height: 44,
                  decoration: BoxDecoration(
                    color: dalgeurakBlueOne,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))
                  ),
                  child: Center(child: Text("확인", style: dialogBtn)),
                ),
              ),
            )
          ],
        ),
      ),
    )
  );
}