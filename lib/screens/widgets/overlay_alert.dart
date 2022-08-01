import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';

class DalgeurakOverlayAlert {
  BuildContext context;
  DalgeurakOverlayAlert({required this.context});

  show(List content) async {
    Vibrate.vibrate();

    OverlayEntry _overlay = OverlayEntry(builder: (_) => _OverlayAlertWidget(content: content));
    Navigator.of(context).overlay!.insert(_overlay);
    await Future.delayed(const Duration(seconds: 5));
    _overlay.remove();
  }
}

class _OverlayAlertWidget extends StatefulWidget {
  late List content;
  _OverlayAlertWidget({Key? key, required this.content}) : super(key: key);

  @override
  _OverlayAlertWidgetState createState() => _OverlayAlertWidgetState(content: content);
}

class _OverlayAlertWidgetState extends State<_OverlayAlertWidget> with SingleTickerProviderStateMixin {
  _OverlayAlertWidgetState({required this.content});

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