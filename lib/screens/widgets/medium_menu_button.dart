import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../themes/text_theme.dart';

class MediumMenuButton extends StatelessWidget {
  final String iconName;
  final String title;
  final String subTitle;
  dynamic clickAction;
  MediumMenuButton({
    required this.iconName, required this.title,
    required this.subTitle, required this.clickAction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: clickAction,
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            SvgPicture.asset(
              "assets/images/icons/$iconName.svg",
              width: 40,
            ),
            SizedBox(height: 6),
            Text(title, style: mediumMenuButtonTitle),
            SizedBox(height: 4),
            Text(subTitle, style: mediumMenuButtonSubTitle)
          ],
        ),
      ),
    );
  }
}