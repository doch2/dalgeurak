import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';


class SimpleListButton extends StatelessWidget {
  final String title;
  final String iconName;
  dynamic clickAction;
  SimpleListButton({required this.title, required this.iconName, required this.clickAction});

  @override
  Widget build(BuildContext context) {
    final double _displayHeight = MediaQuery.of(context).size.height;
    final double _displayWidth = MediaQuery.of(context).size.width;

    return Material(
      color: Colors.white,
      child: InkWell(
          onTap: clickAction,
          child: Container(
            height: 50,
            width: _displayWidth * 0.82,
            child: Center(
                child: SizedBox(
                  width: _displayWidth * 0.77,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset("assets/images/icons/$iconName.svg", width: 20),
                          SizedBox(width: 15),
                          Text(title, style: simpleListButtonTitle)
                        ],
                      ),
                      Icon(Icons.chevron_right_rounded, color: Colors.black, size: 15)
                    ],
                  ),
                )
            ),
          )
      ),
    );
  }
}