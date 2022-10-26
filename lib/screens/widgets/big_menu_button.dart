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
  double containerSize;
  final BigMenuButtonBackgroundType backgroundType;
  final bool includeInnerShadow;
  dynamic background;
  BigMenuButton({
    required this.title, required this.iconName, required this.isHome,
    required this.containerSize, required this.backgroundType,
    required this.includeInnerShadow,
    required this.background
  });

  @override
  Widget build(BuildContext context) {
    Widget childWidget = Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          child: SizedBox(width: (isHome ? 110 : 160), height: (isHome ? 110 : 160)),
        ),
        Positioned(
          top: (isHome ? 31 : 43),
          child: Column(
            children: [
              SvgPicture.asset(
                "assets/images/icons/$iconName.svg",
                color: Colors.white,
                width: (isHome ? 39 : 43),
              ),
            ],
          ),
        ),
        Positioned(
          top: (isHome ? 78 : 105),
          child: Text(
            title,
            style: isHome ? homeMenuWidgetTitle : homeMenuWidgetTitle.copyWith(fontSize: 18),
          ),
        )
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
        width: containerSize,
        height: containerSize,
        decoration: boxDecoration,
        child: Center(child: childWidget),
      ),
    );
  }
}