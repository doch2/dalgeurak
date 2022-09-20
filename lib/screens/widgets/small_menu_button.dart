import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../themes/text_theme.dart';

class SmallMenuButton extends StatelessWidget {
  final String title;
  final String iconName;
  final bool isBig;
  SmallMenuButton({
    required this.title, required this.iconName, required this.isBig
  });

  @override
  Widget build(BuildContext context) {
    double _displayHeight = MediaQuery.of(context).size.height;
    double _displayWidth = MediaQuery.of(context).size.width;


    return Column(
      children: [
        SvgPicture.asset(
          "assets/images/icons/$iconName.svg",
          width: _displayWidth * (isBig ? 0.1 : 0.0769),
        ),
        SizedBox(height: _displayHeight * 0.007),
        Text(
          title,
          style: isBig ? homeMenuWidgetTwoTitle : homeMenuWidgetTwoTitle,
        )
      ],
    );
  }
}