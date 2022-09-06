import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../themes/text_theme.dart';
import 'inner_shadow.dart';

enum BigMenuButtonBackgroundType {
  gradient,
  color,
  image
}

class BigMenuButton extends StatelessWidget {
  final String title;
  final String iconName;
  final bool isHome;
  bool? isTeacherHome;
  double sizeRatio;
  final BigMenuButtonBackgroundType backgroundType;
  final bool includeInnerShadow;
  dynamic background;
  BigMenuButton({
    required this.title, required this.iconName, required this.isHome, this.isTeacherHome,
    required this.sizeRatio, required this.backgroundType,
    required this.includeInnerShadow,
    required this.background
  });

  @override
  Widget build(BuildContext context) {
    double _displayHeight = MediaQuery.of(context).size.height;
    double _displayWidth = MediaQuery.of(context).size.width;

    isTeacherHome ??= false;


    Widget childWidget = Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          child: SizedBox(width: _displayWidth * (isHome ? 0.282 : 0.579), height: _displayHeight * (isHome ? 0.282 : 0.579)),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/icons/$iconName.svg",
              color: Colors.white,
              width: _displayWidth * (isHome ? (isTeacherHome! ? 0.08 : 0.1) : 0.11),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: isHome ? homeMenuWidgetTitle : homeMenuWidgetTitle.copyWith(fontSize: 18),
            ),
          ],
        ),
      ],
    );

    List<Shadow> innerShadow = [];
    if (includeInnerShadow) {
      innerShadow.add(Shadow(
          color: Colors.white.withAlpha(10),
          offset: Offset(10, 10),
          blurRadius: 20));
      innerShadow.add(Shadow(
          color: Colors.black.withAlpha(10),
          offset: Offset(-10, -10),
          blurRadius: 20));
    }

    BoxDecoration boxDecoration = BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10)
        ]);
    if (backgroundType == BigMenuButtonBackgroundType.gradient) {
      boxDecoration = boxDecoration.copyWith(gradient: background);
    } else if (backgroundType == BigMenuButtonBackgroundType.color) {
      boxDecoration = boxDecoration.copyWith(color: background);
    } else if (backgroundType == BigMenuButtonBackgroundType.image) {
      childWidget = Stack(
        alignment: Alignment.center,
        children: [
          background,
          childWidget,
        ],
      );
    }

    return InnerShadow(
      shadows: innerShadow,
      child: Container(
        width: _displayWidth * sizeRatio,
        height: _displayWidth * sizeRatio,
        decoration: boxDecoration,
        child: Center(child: childWidget),
      ),
    );
  }
}