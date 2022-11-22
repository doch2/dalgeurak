import 'package:dalgeurak/screens/studentManage/student_manage_bottomsheet.dart';
import 'package:dalgeurak_widget_package/screens/basic_student_search.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/scheduler.dart';

class ApplicationBlackList extends BasicStudentSearch {
  @override
  void Function()? studentBtnOnClick(DimigoinUser selectStudent) {
    return () => SchedulerBinding.instance.addPostFrameCallback((_) async {
      await StudentManageBottomSheet(student: selectStudent, studentSearch: this).showStudentBlackListBottomSheet();
    });
  }

  @override
  bool get isMustStudentListDataReload => true;
}