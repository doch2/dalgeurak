import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../themes/color_theme.dart';
import '../themes/text_theme.dart';

class WidgetReference {
  late double? width, height;
  late BuildContext? context;
  WidgetReference({this.width, this.height, this.context});

  getWindowTitleWidget(String subTitle, String title) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subTitle, style: widgetReference_windowTitle_subTitle),
          Text(title, style: widgetReference_windowTitle_title)
        ],
      );

  getMenuBtnWidget(double sizeRatio, dynamic childWidget,
      bool includeInnerShadow, String backgroundType, dynamic background) {
    //backgroundType: color, gradient, image
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
    if (backgroundType == 'gradient') {
      boxDecoration = boxDecoration.copyWith(gradient: background);
    } else if (backgroundType == 'color') {
      boxDecoration = boxDecoration.copyWith(color: background);
    } else if (backgroundType == 'image') {
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
        width: width! * sizeRatio,
        height: width! * sizeRatio,
        decoration: boxDecoration,
        child: Center(child: childWidget),
      ),
    );
  }

  getHomeMenuBtnExplainWidget(String iconName, String title) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          child: SizedBox(width: width! * 0.282, height: height! * 0.282),
        ),
        Positioned(
          top: width! * 0.08,
          child: SvgPicture.asset(
            "assets/images/icons/$iconName.svg",
            width: width! * 0.1,
          ),
        ),
        Positioned(
          top: width! * 0.2,
          child: Text(
            title,
            style: homeMenuWidgetTitle,
          ),
        )
      ],
    );
  }

  getDialogBtnWidget(String content, bool isBottomDialog, bool isFill) {
    return Container(
      width: width! * (isBottomDialog ? 0.361 : 0.307),
      height: height! *
          (isBottomDialog ? 0.06 : 0.1), //TODO 바텀 DIalog가 아닐 시 Height 수정 필요
      decoration: BoxDecoration(
        color: isFill ? dalgeurakBlueOne : Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          width: isFill ? 2 : 0,
          color: dalgeurakBlueOne,
        ),
      ),
      child: Center(
          child: Text(content,
              style: (isFill
                  ? btnTitle2.copyWith(color: Colors.white)
                  : btnTitle2))),
    );
  }

  showBottomSheet(BuildContext context, dynamic childWidget) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.white,
        builder: (context) => Container(
          height: height! * 0.5,
          width: width!,
          child: childWidget,
        ),
      );

  showToast(String content) => Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xE6FFFFFF),
      textColor: Colors.black,
      fontSize: 13.0);

  showAlert(List content) async {
    OverlayEntry _overlay = OverlayEntry(builder: (_) => OverlayAlert(content: content));
    Navigator.of(context!).overlay!.insert(_overlay);
    await Future.delayed(const Duration(seconds: 2));
    _overlay.remove();
  }

  showStudentManageBottomSheet(BuildContext context) => showBottomSheet(
      context,
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(width: width, height: height! * 0.579),
        ],
      ));
}

class OverlayAlert extends StatefulWidget {
  late List content;
  OverlayAlert({Key? key, required this.content}) : super(key: key);

  @override
  _OverlayAlertState createState() => _OverlayAlertState(content: content);
}

class _OverlayAlertState extends State<OverlayAlert> with SingleTickerProviderStateMixin {
  _OverlayAlertState({required this.content});

  late List content;
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween<Offset>(begin: Offset(0.0, -8.0), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    List<InlineSpan> textWidgetList = [];
    int contentLength = 0;
    content.forEach((element) {
      textWidgetList.add(
          TextSpan(
            style: element['emphasis'] ? overlayAlert.copyWith(color: dalgeurakYellowOne, fontWeight: FontWeight.w800) : overlayAlert,
            text: element['content'],
          )
      );

      contentLength = contentLength + element['content'].toString().length;
    });

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: _height * 0.03),
          child: SlideTransition(
            position: _animation,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: _width * 0.794,
                height: _height * 0.065,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(7),
                      blurRadius: 20
                    )
                  ]
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: _height * 0.025,
                      child: SvgPicture.asset(
                        "assets/images/icons/alert.svg",
                        width: _width * 0.065,
                      ),
                    ),
                    Positioned(
                      left: _height * 0.2 - (contentLength * (_height * 0.00575)),
                      child:
                      Text.rich(
                        TextSpan(
                          children: textWidgetList,
                        ),
                        textAlign: TextAlign.center,
                        style: overlayAlert,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InnerShadow extends SingleChildRenderObjectWidget {
  const InnerShadow({
    Key? key,
    this.shadows = const <Shadow>[],
    Widget? child,
  }) : super(key: key, child: child);

  final List<Shadow> shadows;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final renderObject = _RenderInnerShadow();
    updateRenderObject(context, renderObject);
    return renderObject;
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderInnerShadow renderObject) {
    renderObject.shadows = shadows;
  }
}

class _RenderInnerShadow extends RenderProxyBox {
  late List<Shadow> shadows;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;
    final bounds = offset & size;

    context.canvas.saveLayer(bounds, Paint());
    context.paintChild(child!, offset);

    for (final shadow in shadows) {
      final shadowRect = bounds.inflate(shadow.blurSigma);
      final shadowPaint = Paint()
        ..blendMode = BlendMode.srcATop
        ..colorFilter = ColorFilter.mode(shadow.color, BlendMode.srcOut)
        ..imageFilter = ImageFilter.blur(
            sigmaX: shadow.blurSigma, sigmaY: shadow.blurSigma);
      context.canvas
        ..saveLayer(shadowRect, shadowPaint)
        ..translate(shadow.offset.dx, shadow.offset.dy);
      context.paintChild(child!, offset);
      context.canvas.restore();
    }

    context.canvas.restore();
  }
}
