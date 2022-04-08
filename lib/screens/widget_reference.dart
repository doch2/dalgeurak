import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

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
          width: isFill ? 2 : 1,
          color: dalgeurakBlueOne,
        ),
      ),
      child: Center(
          child: Text(content, style: (isFill ? textStyle.copyWith(color: Colors.white) : textStyle))),
    );
  }

  getCheckBoxWidget(String content, bool isOn) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          "assets/images/icons/checkBox.svg",
          color: isOn ? dalgeurakBlueOne : dalgeurakGrayTwo,
          width: width! * 0.064,
        ),
        SizedBox(width: width! * 0.03),
        Text(
          content,
          style: widgetReference_checkBox,
        )
      ],
    );
  }

  showBottomSheet(BuildContext context, double heightSize, dynamic childWidget) => showModalBottomSheet(
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
}

class StudentManageWidgetReference {
  late WidgetReference widgetReference;
  late DimigoinUser student;
  StudentManageWidgetReference({required this.widgetReference, required this.student});

  RxMap warningList = {
    "지각": false,
    "욕설": false,
    "통로 사용": false,
    "순서 무시": false,
    "기타": false,
  }.obs;
  TextEditingController warningReasonTextController = TextEditingController();
  MealController mealController = Get.find<MealController>();

  showStudentManageBottomSheet() => widgetReference.showBottomSheet(
      widgetReference.context!,
      0.579,
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(width: widgetReference.width, height: widgetReference.height! * 0.579),
          Positioned(
            top: widgetReference.height! * 0.075,
            left: widgetReference.width! * 0.0925,
            child: Text(student.studentId.toString(), style: studentManageDialogId),
          ),
          Positioned(
            top: widgetReference.height! * 0.105,
            left: widgetReference.width! * 0.0925,
            child: Text(student.name!, style: studentManageDialogName),
          ),
          Positioned(
            top: widgetReference.height! * 0.155,
            left: widgetReference.width! * 0.0925,
            child: Text("디넌으로 임명하기", style: studentManageDialogSetDienen),
          ),
          Positioned(
              top: widgetReference.height! * 0.1175,
              right: widgetReference.width! * 0.075,
              child: SizedBox(
                width: widgetReference.width! * 0.356,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: widgetReference.getMenuBtnWidgetTwo(
                          false,
                          "onePage",
                          "경고 횟수"
                      ),
                    ),
                    GestureDetector(
                      child: widgetReference.getMenuBtnWidgetTwo(
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
              top: widgetReference.height! * 0.185,
              child: Container(width: widgetReference.width! * 0.82, child: Divider(color: dalgeurakGrayOne, thickness: 1.0))
          ),
          Positioned(
              top: widgetReference.height! * 0.215,
              child: SizedBox(
                width: widgetReference.width! * 0.846,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => showStudentWarningTypeBottomSheet(),
                      child: widgetReference.getMenuBtnWidget(
                        0.41,
                        widgetReference.getMenuBtnExplainWidget(false, "noticeCircle", "경고 부여"),
                        true,
                        "gradient",
                        blueLinearGradientOne,
                      ),
                    ),
                    GestureDetector(
                      child: widgetReference.getMenuBtnWidget(
                        0.41,
                        widgetReference.getMenuBtnExplainWidget(false, "checkCircle", "입장 처리"),
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
              bottom: widgetReference.height! * 0.08,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: widgetReference.getDialogBtnWidget("확인", true, true),
              )
          ),
        ],
      )
  );

  showStudentWarningTypeBottomSheet() => widgetReference.showBottomSheet(
      widgetReference.context!,
      0.579,
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(width: widgetReference.width, height: widgetReference.height! * 0.579),
          Positioned(
            top: widgetReference.height! * 0.075,
            left: widgetReference.width! * 0.0925,
            child: Text(student.studentId.toString(), style: studentManageDialogId),
          ),
          Positioned(
            top: widgetReference.height! * 0.105,
            left: widgetReference.width! * 0.0925,
            child: Text(student.name!, style: studentManageDialogName),
          ),
          Positioned(
              top: widgetReference.height! * 0.1475,
              child: Container(width: widgetReference.width! * 0.82, child: Divider(color: dalgeurakGrayOne, thickness: 1.0))
          ),
          Positioned(
              top: widgetReference.height! * 0.18,
              left: widgetReference.width! * 0.0925,
              child: Text("경고 항목", style: widgetReference_detailTitle)
          ),
          Positioned(
              top: widgetReference.height! * 0.22,
              left: widgetReference.width! * 0.0925,
              child: SizedBox(
                height: widgetReference.height! * 0.20,
                child: Obx(() {
                  List<Widget> widgetList = [];
                  warningList.keys.forEach(
                          (element) => widgetList.add(
                            GestureDetector(
                              onTap: () =>  warningList[element] = !warningList[element],
                              child: widgetReference.getCheckBoxWidget(element, warningList[element]),
                            )
                          )
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: widgetList
                  );
                }),
              )
          ),
          Positioned(
              bottom: widgetReference.height! * 0.06,
              child: SizedBox(
                width: widgetReference.width! * 0.82,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: widgetReference.getDialogBtnWidget("취소", false, false),
                    ),
                    GestureDetector(
                      onTap: () async { 
                        if (warningList.containsValue(true)) {
                          Get.back(); 
                          await Future.delayed(Duration(milliseconds: 50)); 
                          showStudentWarningReasonBottomSheet();
                        } else {
                          widgetReference.showToast("경고 항목을 체크하고 진행해주세요.");
                        }
                      },
                      child: widgetReference.getDialogBtnWidget("다음", false, true),
                    )
                  ],
                ),
              )
          ),
        ],
      )
  );

  showStudentWarningReasonBottomSheet() => widgetReference.showBottomSheet(
      widgetReference.context!,
      0.579,
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(width: widgetReference.width, height: widgetReference.height! * 0.579),
          Positioned(
            top: widgetReference.height! * 0.075,
            left: widgetReference.width! * 0.0925,
            child: Text(student.studentId.toString(), style: studentManageDialogId),
          ),
          Positioned(
            top: widgetReference.height! * 0.105,
            left: widgetReference.width! * 0.0925,
            child: Text(student.name!, style: studentManageDialogName),
          ),
          Positioned(
              top: widgetReference.height! * 0.1475,
              child: Container(width: widgetReference.width! * 0.82, child: Divider(color: dalgeurakGrayOne, thickness: 1.0))
          ),
          Positioned(
              top: widgetReference.height! * 0.18,
              left: widgetReference.width! * 0.0925,
              child: Text("상세 사유", style: widgetReference_detailTitle)
          ),
          Positioned(
              top: widgetReference.height! * 0.23,
              left: widgetReference.width! * 0.0925,
              child: Container(
                width: widgetReference.width! * 0.846,
                height: widgetReference.height! * 0.185,
                decoration: BoxDecoration(
                  border: Border.all(color: dalgeurakGrayTwo, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: warningReasonTextController,
                  textAlign: TextAlign.center,
                  style: studentManageWarningReasonDialogTextField,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 0, style: BorderStyle.none,)),
                    hintText: "상세 사유를 입력해 주세요.",
                    hintStyle: studentManageWarningReasonDialogTextField.copyWith(color: dalgeurakGrayTwo),
                  ),
                ),
              )
          ),
          Positioned(
              bottom: widgetReference.height! * 0.06,
              child: SizedBox(
                width: widgetReference.width! * 0.82,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: widgetReference.getDialogBtnWidget("취소", false, false),
                    ),
                    GestureDetector(
                      onTap: () {
                        List warningList = [];
                        this.warningList.forEach((key, value) {
                          if (value) {
                            warningList.add((key as String).convertStudentWarningType);
                          }
                        });

                        mealController.giveStudentWarning(student.id!, warningList, warningReasonTextController.text);
                      },
                      child: widgetReference.getDialogBtnWidget("확인", false, true),
                    )
                  ],
                ),
              )
          ),
        ],
      )
  );
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
