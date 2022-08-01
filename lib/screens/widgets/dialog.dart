import 'package:dalgeurak/screens/widgets/blue_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../themes/text_theme.dart';

class DalgeurakDialog {
  showWarning(List message, String subMessage, dynamic executeFunc) {
    List<InlineSpan> textWidgetList = [];
    message.forEach((element) => textWidgetList.add(
        TextSpan(
          style: element['emphasis'] ? widgetReference_warningDialog_message.copyWith(fontWeight: FontWeight.w700) : widgetReference_warningDialog_message,
          text: element['content'],
        )
    ));

    Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          child: Container(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(width: Get.width * 0.851, height: Get.height * 0.258),
                Positioned(
                    top: Get.height * 0.025,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                            "assets/images/icons/warning.svg"
                        ),
                        Text("Warning", style: widgetReference_warningDialog_title)
                      ],
                    )
                ),
                Positioned(
                  top: Get.height * 0.085,
                  child:
                  Text.rich(
                    TextSpan(
                      children: textWidgetList,
                    ),
                    textAlign: TextAlign.center,
                    style: widgetReference_warningDialog_message,
                  ),
                ),
                Positioned(
                  top: Get.height * 0.12,
                  child: Text(subMessage, style: widgetReference_warningDialog_subMessage),
                ),
                Positioned(
                    bottom: Get.height * 0.025,
                    child: SizedBox(
                      width: Get.width * 0.665,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: BlueButton(content: "취소", isLong: false, isFill: false, isDialog: true),
                          ),
                          GestureDetector(
                            onTap: executeFunc,
                            child: BlueButton(content: "확인", isLong: false, isFill: true, isDialog: true),
                          )
                        ],
                      ),
                    )
                ),
              ],
            ),
          ),
        )
    );
  }
}