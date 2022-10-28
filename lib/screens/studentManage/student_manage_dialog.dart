import 'package:dalgeurak_widget_package/services/dalgeurak_api.dart';
import 'package:dalgeurak_widget_package/widgets/blue_button.dart';
import 'package:dalgeurak_widget_package/widgets/checkbox.dart';
import 'package:dalgeurak_widget_package/widgets/dialog.dart';
import 'package:dalgeurak_widget_package/widgets/overlay_alert.dart';
import 'package:dalgeurak_widget_package/widgets/bottom_sheet.dart';
import 'package:dalgeurak_widget_package/widgets/reason_textfield.dart';
import 'package:dalgeurak/screens/widgets/small_menu_button.dart';
import 'package:dalgeurak_widget_package/widgets/toast.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

import '../../controllers/meal_controller.dart';
import '../../controllers/user_controller.dart';
import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';
import 'student_search.dart';
import '../widgets/big_menu_button.dart';

class StudentManageDialog {
  StudentManageDialog();

  DalgeurakDialog _dalgeurakDialog = DalgeurakDialog();

  RxMap warningList = {
    "지각": false,
    "욕설": false,
    "통로 사용": false,
    "순서 무시": false,
    "기타": false,
  }.obs;
  TextEditingController warningReasonTextController = TextEditingController();
  MealController mealController = Get.find<MealController>();

  showWarningDialog(List<DalgeurakWarning> warningList) => _dalgeurakDialog.showList(
      "경고",
      "누적 ${warningList.length}회",
      "경고 기록",
      ListView.builder(
          itemCount: warningList.length,
          itemBuilder: (context, index) {
            DalgeurakWarning warning = warningList[index];

            String warningTypeStr = "";
            warning.warningTypeList?.forEach((element) => warningTypeStr = warningTypeStr + element.convertKorStr + ", ");
            warningTypeStr = warningTypeStr.substring(0, warningTypeStr.length-2);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${Jiffy(warning.date).format("MM.dd (E) a hh:mm")}", style: myProfile_warning_date),
                SizedBox(height: 2),
                Text("$warningTypeStr(${warning.reason})", style: myProfile_warning_reason),
                SizedBox(height: 20),
              ],
            );
          }
      )
  );

  showCheckInRecordDialog(String studentName) => _dalgeurakDialog.showList(
      studentName,
      "입장 기록",
      "입장 기록",
      null
  );
}