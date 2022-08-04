import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';

class BlueButton extends StatelessWidget {
  final String content;
  final bool isLong;
  final bool isFill;
  BlueButton({required this.content, required this.isLong, required this.isFill});

  @override
  Widget build(BuildContext context) {
    double _displayWidth = MediaQuery.of(context).size.width;
    double _displayHeight = MediaQuery.of(context).size.height;


    TextStyle textStyle = isLong ? btnTitle1 : btnTitle2;

    return Container(
      width: _displayWidth * (isLong ? 0.846 : 0.361),
      height: _displayHeight * 0.06,
      decoration: BoxDecoration(
        color: isFill ? dalgeurakBlueOne : Colors.white,
        borderRadius: BorderRadius.circular(isLong ? 15 : 5),
        border: Border.all(
          width: isFill ? 2 : 1,
          color: dalgeurakBlueOne,
        ),
      ),
      child: Center(
          child: Text(content, style: (isFill ? textStyle.copyWith(color: Colors.white) : textStyle))),
    );
  }
}