import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../themes/text_theme.dart';

class WidgetReference {
  late double? width, height;
  WidgetReference({this.width, this.height});

  getWindowTitleWidget(String subTitle, String title) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(subTitle, style: widgetReference_windowTitle_subTitle),
      Text(title, style: widgetReference_windowTitle_title)
    ],
  );

  showToast(String content) => Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xE6FFFFFF),
      textColor: Colors.black,
      fontSize: 13.0
  );
}