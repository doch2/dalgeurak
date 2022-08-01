import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DalgeurakToast {
  show(String content) => Fluttertoast.showToast(
    msg: content,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color(0xE6FFFFFF),
    textColor: Colors.black,
    fontSize: 13.0
  );
}