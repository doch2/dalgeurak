import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DalgeurakBottomSheet {
  show(double heightSize, Widget childWidget) => Get.bottomSheet(
    _BottomSheetWidget(childWidget: childWidget, heightSize: heightSize),
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
  );
}

class _BottomSheetWidget extends StatelessWidget {
  Widget childWidget;
  double heightSize;
  _BottomSheetWidget({required this.childWidget, required this.heightSize});

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Container(
      height: _height * heightSize,
      width: _width,
      child: childWidget,
    );
  }

}