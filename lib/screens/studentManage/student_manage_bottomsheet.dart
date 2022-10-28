import 'package:dalgeurak/screens/studentManage/student_manage_dialog.dart';
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

import '../../controllers/meal_controller.dart';
import '../../controllers/user_controller.dart';
import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';
import 'student_search.dart';
import '../widgets/big_menu_button.dart';

class StudentManageBottomSheet {
  StudentSearch studentSearch;
  DimigoinUser student;
  StudentManageBottomSheet({required this.student, required this.studentSearch});

  DalgeurakService _dalgeurakService = Get.find<DalgeurakService>();

  DalgeurakToast _dalgeurakToast = DalgeurakToast();
  DalgeurakBottomSheet _dalgeurakBottomSheet = DalgeurakBottomSheet();
  DalgeurakDialog _dalgeurakDialog = DalgeurakDialog();
  DalgeurakOverlayAlert _dalgeurakOverlayAlert = DalgeurakOverlayAlert(context: Get.context!);
  StudentManageDialog _studentManageDialog = StudentManageDialog();

  RxMap warningList = {
    "지각": false,
    "욕설": false,
    "통로 사용": false,
    "순서 무시": false,
    "기타": false,
  }.obs;
  TextEditingController warningReasonTextController = TextEditingController();
  MealController mealController = Get.find<MealController>();

  showStudentManageBottomSheet() => _dalgeurakBottomSheet.show(
      0.579,
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(width: Get.width, height: Get.height * 0.579),
          Positioned(
            top: Get.height * 0.075,
            left: Get.width * 0.0925,
            child: Text(student.studentId.toString(), style: studentManageDialogId),
          ),
          Positioned(
            top: Get.height * 0.105,
            left: Get.width * 0.0925,
            child: Text(student.name!, style: studentManageDialogName),
          ),
          Positioned(
            top: Get.height * 0.155,
            left: Get.width * 0.0925,
            child: GestureDetector(
                onTap: () => _dalgeurakDialog.showWarning(
                  "${student.studentId} ${student.name}를 ${(student.permissions!.contains(DimigoinPermissionType.dalgeurak) ? "디넌 해제" : "디넌으로 임명")} 하시겠어요?",
                  "장난으로 기재할 시 처벌받을 수 있습니다.",
                      () async {
                    Map result = (student.permissions!.contains(DimigoinPermissionType.dalgeurak) ? await _dalgeurakService.removeDienenPermission(student.id!) : await _dalgeurakService.authorizeDienenPermission(student.id!));

                    if (result['success']) {
                      _dalgeurakOverlayAlert.show(
                          [
                            {
                              "content": "${student.name}(을)를 ",
                              "emphasis": false,
                            },
                            {
                              "content": (student.permissions!.contains(DimigoinPermissionType.dalgeurak) ? "디넌 임명 해제" : "디넌으로 임명"),
                              "emphasis": true,
                            },
                            {
                              "content": " 하였습니다.",
                              "emphasis": false,
                            }
                          ]
                      );
                      studentSearch.studentList = List<DimigoinUser>.from(await DalgeurakStudentListAPI().getStudentList(true));
                      studentSearch.query = studentSearch.query + " ";
                      studentSearch.query = studentSearch.query.substring(0, studentSearch.query.length - 1); //권한 새로고침을 위한 코드
                      Get.back();
                      Get.back();
                    } else {
                      _dalgeurakToast.show(result['content']);
                      Get.back();
                    }

                  },
                ),
                child: Text((Get.find<UserController>().user!.permissions!.contains(DimigoinPermissionType.dalgeurakManagement) ?
                (student.permissions!.contains(DimigoinPermissionType.dalgeurak) ? "디넌 임명 해제" : "디넌으로 임명하기") : ""), style: studentManageDialogSetDienen)
            ),
          ),
          Positioned(
              top: Get.height * 0.1175,
              right: Get.width * 0.075,
              child: SizedBox(
                width: Get.width * 0.356,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async => _studentManageDialog.showWarningDialog(await mealController.getStudentWarningList(student.id!)),
                      child: SmallMenuButton(
                        title: "경고 횟수",
                        iconName: "onePage",
                        isBig: false,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _studentManageDialog.showCheckInRecordDialog(student.name!),
                      child: SmallMenuButton(
                        title: "입장 기록",
                        iconName: "logPage",
                        isBig: false,
                      ),
                    ),
                  ],
                ),
              )
          ),
          Positioned(
              top: Get.height * 0.185,
              child: Container(width: Get.width * 0.82, child: Divider(color: dalgeurakGrayOne, thickness: 1.0))
          ),
          Positioned(
              top: Get.height * 0.215,
              child: SizedBox(
                width: Get.width * 0.846,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => showStudentWarningTypeBottomSheet(),
                      child: BigMenuButton(
                        title: "경고 부여",
                        iconName: "noticeCircle_fill",
                        isHome: false,
                        containerSize: 160,
                        includeInnerShadow: true,
                        backgroundType: BigMenuButtonBackgroundType.gradient,
                        background: blueLinearGradientOne
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _dalgeurakDialog.showWarning(
                        "${student.studentId} ${student.name}를 입장으로 처리하시겠어요?",
                        "장난으로 기재할 시 처벌받을 수 있습니다.",
                            () async {
                          Map result = await _dalgeurakService.mealCheckInByManager(student.id!);

                          if (result['success']) {
                            _dalgeurakOverlayAlert.show(
                                [
                                  {
                                    "content": "${student.name}(이)가 ",
                                    "emphasis": false,
                                  },
                                  {
                                    "content": "입장 처리",
                                    "emphasis": true,
                                  },
                                  {
                                    "content": "되었습니다.",
                                    "emphasis": false,
                                  }
                                ]
                            );
                            Get.back();
                          } else {
                            _dalgeurakToast.show(result['content']);
                            Get.back();
                          }

                        },
                      ),
                      child: BigMenuButton(
                        title: "입장 처리",
                        iconName: "checkCircle",
                        isHome: false,
                        containerSize: 160,
                        includeInnerShadow: true,
                        backgroundType: BigMenuButtonBackgroundType.color,
                        background: purpleTwo
                      ),
                    ),
                  ],
                ),
              )
          ),
          Positioned(
              bottom: Get.height * 0.08,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: BlueButton(content: "확인", isLong: true, isFill: true, isSmall: false, isDisable: false),
              )
          ),
        ],
      )
  );

  showStudentWarningTypeBottomSheet() => _dalgeurakBottomSheet.show(
      0.579,
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(width: Get.width, height: Get.height * 0.579),
          Positioned(
            top: Get.height * 0.075,
            left: Get.width * 0.0925,
            child: Text(student.studentId.toString(), style: studentManageDialogId),
          ),
          Positioned(
            top: Get.height * 0.105,
            left: Get.width * 0.0925,
            child: Text(student.name!, style: studentManageDialogName),
          ),
          Positioned(
              top: Get.height * 0.1475,
              child: Container(width: Get.width * 0.82, child: Divider(color: dalgeurakGrayOne, thickness: 1.0))
          ),
          Positioned(
              top: Get.height * 0.18,
              left: Get.width * 0.0925,
              child: Text("경고 항목", style: detailTitle)
          ),
          Positioned(
              top: Get.height * 0.22,
              left: Get.width * 0.0925,
              child: SizedBox(
                height: Get.height * 0.20,
                child: Obx(() {
                  List<Widget> widgetList = [];
                  warningList.keys.forEach(
                          (element) => widgetList.add(
                          GestureDetector(
                            onTap: () =>  warningList[element] = !warningList[element],
                            child: DalgeurakCheckBox(content: element, isOn: warningList[element], checkBoxType: DalgeurakCheckBoxType.window),
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
              bottom: Get.height * 0.06,
              child: SizedBox(
                width: Get.width * 0.82,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: BlueButton(content: "취소", isLong: false, isFill: false, isSmall: false, isDisable: false),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (warningList.containsValue(true)) {
                          Get.back();
                          await Future.delayed(Duration(milliseconds: 50));
                          showStudentWarningReasonBottomSheet();
                        } else {
                          _dalgeurakToast.show("경고 항목을 체크하고 진행해주세요.");
                        }
                      },
                      child: BlueButton(content: "다음", isLong: false, isFill: true, isSmall: false, isDisable: false),
                    )
                  ],
                ),
              )
          ),
        ],
      )
  );

  showStudentWarningReasonBottomSheet() => _dalgeurakBottomSheet.show(
      0.579,
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(width: Get.width, height: Get.height * 0.579),
          Positioned(
            top: Get.height * 0.075,
            left: Get.width * 0.0925,
            child: Text(student.studentId.toString(), style: studentManageDialogId),
          ),
          Positioned(
            top: Get.height * 0.105,
            left: Get.width * 0.0925,
            child: Text(student.name!, style: studentManageDialogName),
          ),
          Positioned(
              top: Get.height * 0.1475,
              child: Container(width: Get.width * 0.82, child: Divider(color: dalgeurakGrayOne, thickness: 1.0))
          ),
          Positioned(
              top: Get.height * 0.18,
              left: Get.width * 0.0925,
              child: Text("상세 사유", style: detailTitle)
          ),
          Positioned(
              top: Get.height * 0.23,
              left: Get.width * 0.0925,
              child: ReasonTextField(hintText: "상세 사유를 입력해주세요.", textController: warningReasonTextController, isBig: true, isEnable: true)
          ),
          Positioned(
              bottom: Get.height * 0.06,
              child: SizedBox(
                width: Get.width * 0.82,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: BlueButton(content: "취소", isLong: false, isFill: false, isSmall: false, isDisable: false),
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
                      child: BlueButton(content: "확인", isLong: false, isFill: true, isSmall: false, isDisable: false),
                    )
                  ],
                ),
              )
          ),
        ],
      )
  );
}