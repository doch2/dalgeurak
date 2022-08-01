import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';

class CheckBox extends StatelessWidget {
  final String content;
  final bool isOn;
  CheckBox({required this.content, required this.isOn});

  @override
  Widget build(BuildContext context) {
    double _displayWidth = MediaQuery.of(context).size.width;


    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          "assets/images/icons/checkBox.svg",
          color: isOn ? dalgeurakBlueOne : dalgeurakGrayTwo,
          width: _displayWidth * 0.064,
        ),
        SizedBox(width: _displayWidth * 0.03),
        Text(
          content,
          style: widgetReference_checkBox,
        )
      ],
    );
  }
}