import 'package:flutter/material.dart';

import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';

class SequenceBlueButton extends StatelessWidget {
  final String content;
  final int sequenceNum;
  final bool isEnable;
  SequenceBlueButton({required this.content, required this.sequenceNum, required this.isEnable});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: isEnable ? dalgeurakBlueOne : dalgeurakGrayThree,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 2,
            right: 2,
            child: Container(
              width: 16,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isEnable ? dalgeurakBlueOne : Colors.transparent
              ),
              child: Center(
                  child: Text("$sequenceNum", style: sequenceBlueButtonSequenceNum)
              ),
            ),
          ),
          Text(content, style: (isEnable ? btnTitle1.copyWith(fontSize: 14) : btnTitle1.copyWith(fontSize: 14, color: dalgeurakGrayThree))),
        ],
      ),
    );
  }
}