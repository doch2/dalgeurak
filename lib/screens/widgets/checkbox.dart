import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';

enum DalgeurakCheckBoxType {
  dialog, ///Dialog에 쓰이는 CheckBox
  window ///기타 여러 화면에 쓰이는 CheckBox
}

extension DalgeurakCheckBoxTypeExtension on DalgeurakCheckBoxType {
  TextStyle get textStyle {
    switch (this) {
      case DalgeurakCheckBoxType.dialog: return noticeDialog_menu;
      case DalgeurakCheckBoxType.window: return checkBox;
      default: return TextStyle();
    }
  }

  double get checkBoxSize {
    switch (this) {
      case DalgeurakCheckBoxType.dialog: return 18;
      case DalgeurakCheckBoxType.window: return 25;
      default: return 25;
    }
  }
}


class DalgeurakCheckBox extends StatelessWidget {
  final String content;
  final bool isOn;
  final DalgeurakCheckBoxType checkBoxType;
  DalgeurakCheckBox({required this.content, required this.isOn, required this.checkBoxType});

  @override
  Widget build(BuildContext context) {
    double _displayWidth = MediaQuery.of(context).size.width;


    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          "assets/images/icons/checkBox${checkBoxType == DalgeurakCheckBoxType.dialog && !isOn ? "_blank" : ""}.svg",
          color: (
            checkBoxType == DalgeurakCheckBoxType.window ?
              (isOn ? dalgeurakBlueOne : dalgeurakGrayTwo) :
              Colors.white
          ),
          width: checkBoxType.checkBoxSize,
        ),
        SizedBox(width: _displayWidth * (checkBoxType == DalgeurakCheckBoxType.dialog ? 0.02 : 0.03)),
        Text(
          content,
          style: checkBoxType.textStyle,
        )
      ],
    );
  }
}