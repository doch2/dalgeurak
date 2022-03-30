import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
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

  getMenuBtnWidgetTwo(bool isBig, String iconName, String title) {
    return Column(
      children: [
        SvgPicture.asset(
          "assets/images/icons/$iconName.svg",
          width: width! * (isBig ? 0.1 : 0.0769),
        ),
        SizedBox(height: height! * 0.007),
        Text(
          title,
          style: isBig ? homeMenuWidgetTwoTitle : homeMenuWidgetTwoTitle,
        )
      ],
    );
  }

  getMenuBtnExplainWidget(bool isHome, String iconName, String title) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          child: SizedBox(width: width! * (isHome ? 0.282 : 0.579), height: height! * (isHome ? 0.282 : 0.579)),
        ),
        Positioned(
          top: width! * (isHome ? 0.08 : 0.11),
          child: SvgPicture.asset(
            "assets/images/icons/$iconName.svg",
            width: width! * (isHome ? 0.1 : 0.11),
          ),
        ),
        Positioned(
          top: width! * (isHome ? 0.2 : 0.27),
          child: Text(
            title,
            style: isHome ? homeMenuWidgetTitle : homeMenuWidgetTitle.copyWith(fontSize: 18),
          ),
        )
      ],
    );
  }

  getDialogBtnWidget(String content, bool isLong, bool isFill) {
    TextStyle textStyle = isLong ? btnTitle1 : btnTitle2;

    return Container(
      width: width! * (isLong ? 0.846 : 0.361),
      height: height! * 0.06,
      decoration: BoxDecoration(
        color: isFill ? dalgeurakBlueOne : Colors.white,
        borderRadius: BorderRadius.circular(isLong ? 15 : 5),
        border: Border.all(
          width: isFill ? 2 : 0,
          color: dalgeurakBlueOne,
        ),
      ),
      child: Center(
          child: Text(content, style: (isFill ? textStyle.copyWith(color: Colors.white) : textStyle))),
    );
  }

  showBottomSheet(BuildContext context, double heightSize, dynamic childWidget) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.white,
        builder: (context) => Container(
          height: height! * heightSize,
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
    Vibrate.vibrate();

    OverlayEntry _overlay = OverlayEntry(builder: (_) => OverlayAlert(content: content));
    Navigator.of(context!).overlay!.insert(_overlay);
    await Future.delayed(const Duration(seconds: 5));
    _overlay.remove();
  }

  showStudentManageBottomSheet(DimigoinUser student, BuildContext context) => showBottomSheet(
      context,
      0.579,
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(width: width, height: height! * 0.579),
          Positioned(
            top: height! * 0.075,
            left: width! * 0.0925,
            child: Text(student.studentId.toString(), style: studentManageDialogId),
          ),
          Positioned(
            top: height! * 0.105,
            left: width! * 0.0925,
            child: Text(student.name!, style: studentManageDialogName),
          ),
          Positioned(
            top: height! * 0.155,
            left: width! * 0.0925,
            child: Text("디넌으로 임명하기", style: studentManageDialogSetDienen),
          ),
          Positioned(
              top: height! * 0.1175,
              right: width! * 0.075,
              child: SizedBox(
                width: width! * 0.356,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: getMenuBtnWidgetTwo(
                        false,
                        "onePage",
                        "경고 횟수"
                      ),
                    ),
                    GestureDetector(
                      child: getMenuBtnWidgetTwo(
                        false,
                        "logPage",
                        "입장 기록"
                      ),
                    ),
                  ],
                ),
              )
          ),
          Positioned(
            top: height! * 0.185,
            child: Container(width: width! * 0.82, child: Divider(color: dalgeurakGrayOne, thickness: 1.0))
          ),
          Positioned(
            top: height! * 0.215,
            child: SizedBox(
              width: width! * 0.846,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: getMenuBtnWidget(
                      0.41,
                      getMenuBtnExplainWidget(false, "noticeCircle", "경고 부여"),
                      true,
                      "gradient",
                      blueLinearGradientOne,
                    ),
                  ),
                  GestureDetector(
                    child: getMenuBtnWidget(
                      0.41,
                      getMenuBtnExplainWidget(false, "checkCircle", "입장 처리"),
                      true,
                      "color",
                      purpleTwo,
                    ),
                  ),
                ],
              ),
            )
          ),
          Positioned(
            bottom: height! * 0.08,
            child: getDialogBtnWidget("확인", true, true)
          ),
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
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 550),
        reverseDuration: Duration(milliseconds: 750)
    );
    _animation = Tween<Offset>(begin: Offset(0.0, -8.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    _controller.forward();
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds : 3000), () => _controller.reverse());
      }
    });
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
