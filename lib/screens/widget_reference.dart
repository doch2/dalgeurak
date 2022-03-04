import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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

  getMenuBtnWidget(double sizeRatio, dynamic childWidget, bool includeInnerShadow, String backgroundType, dynamic background) { //backgroundType: color, gradient, image
    List<Shadow> innerShadow = [];
    if (includeInnerShadow) {
      innerShadow.add(
        Shadow(
          color: Colors.white.withAlpha(10),
          offset: Offset(10, 10),
          blurRadius: 20
        )
      );
      innerShadow.add(
          Shadow(
              color: Colors.black.withAlpha(10),
              offset: Offset(-10, -10),
              blurRadius: 20
          )
      );
    }

    BoxDecoration boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10
        )
      ]
    );
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