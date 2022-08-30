import 'package:dalgeurak/themes/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../themes/text_theme.dart';

class DownloadButton extends StatelessWidget {
  dynamic clickAction;
  DownloadButton({required this.clickAction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: clickAction,
      child: Container(
        width: 194,
        height: 50,
        decoration: BoxDecoration(
          color: dalgeurakBlueOne,
          borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 22),
            SvgPicture.asset(
              "assets/images/icons/download.svg",
              width: 24,
            ),
            const SizedBox(width: 24),
            Text("다운로드", style: downloadButton)
          ],
        ),
      ),
    );
  }
}