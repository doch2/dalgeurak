import 'package:dalgeurak/screens/widgets/sequence_blue_button.dart';
import 'package:dalgeurak_widget_package/widgets/blue_button.dart';
import 'package:dalgeurak_widget_package/widgets/bottom_sheet.dart';
import 'package:dalgeurak_widget_package/widgets/dialog.dart';
import 'package:dalgeurak_widget_package/widgets/overlay_alert.dart';
import 'package:dalgeurak_widget_package/widgets/toast.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/meal_controller.dart';
import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';

enum ModifyMealInfoType {
  sequence,
  place,
  none
}

class HomeBottomSheet {
  DalgeurakBottomSheet _dalgeurakBottomSheet = DalgeurakBottomSheet();
  DalgeurakToast _dalgeurakToast = DalgeurakToast();
  MealController mealController = Get.find<MealController>();

  Rx<MealType> modifyMealInfoTime = MealType.none.obs;
  Rx<ModifyMealInfoType> modifyMealInfoType = ModifyMealInfoType.none.obs;
  Map<int, RxList<int>> modifyMealClassSequence = {1: ([].cast<int>()).obs, 2: ([].cast<int>()).obs};
  Rx<MealWaitingPlaceType> modifyMealPlaceType = MealWaitingPlaceType.outside.obs;

  showMealDelay(BuildContext context) => _dalgeurakBottomSheet.show(
      0.5,
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(width: Get.width, height: Get.height * 0.5),
          Positioned(
              top: Get.height * 0.04,
              left: Get.width * 0.07,
              child: Text("급식 지연", style: homeBottomSheetTitle)
          ),
          Positioned(
              top: Get.height * 0.075,
              left: Get.width * 0.07,
              child: Text("지연 설정 할 시간을 입력해주세요.", style: homeBottomSheetSubTitle)
          ),
          Positioned(
              top: Get.height * 0.1,
              child: Container(width: Get.width * 0.871, child: Divider(color: dalgeurakGrayTwo, thickness: 1.0))
          ),
          Positioned(
              top: Get.height * 0.125,
              left: Get.width * 0.07,
              child: Text("현재 지연 된 시간", style: homeMealDelaySheetNowSettingDescription)
          ),
          Positioned(
              top: Get.height * 0.125,
              left: Get.width * 0.36,
              child: Text("${mealController.mealTime['extraMinute']}분", style: homeMealDelaySheetNowSettingTime)
          ),
          Positioned(
            top: Get.height * 0.2,
            child: Row(
              children: [
                SizedBox(
                  width: Get.width * 0.141,
                  height: Get.height * 0.04,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: mealController.mealDelayTextController,
                    textAlign: TextAlign.center,
                    style: homeMealDelaySheetFieldText,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(3), borderSide: BorderSide(width: 0, style: BorderStyle.none,)),
                      fillColor: dalgeurakGrayOne,
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(width: Get.width * 0.015),
                Text("분 지연 설정", style: homeMealDelaySheetFieldDescription),
              ],
            ),
          ),
          Positioned(
            bottom: Get.height * 0.08,
            child: SizedBox(
              width: Get.width * 0.825,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: BlueButton(content: "취소", isLong: false, isFill: false, isSmall: false, isDisable: false),
                  ),
                  GestureDetector(
                    onTap: () => DalgeurakDialog().showWarning(
                        "급식 시간을 ${mealController.mealDelayTextController.text}분 지연하시겠어요?",
                        "장난으로 기재할 시 처벌 받을 수 있습니다.",
                            () async {
                          if (await mealController.setDelayMealTime()) {
                            DalgeurakOverlayAlert(context: context).show(
                              [
                                {
                                  "content": "급식 시간이 ",
                                  "emphasis": false,
                                },
                                {
                                  "content": "${mealController.mealDelayTextController.text}분 지연",
                                  "emphasis": true,
                                },
                                {
                                  "content": " 되었습니다.",
                                  "emphasis": false,
                                }
                              ],
                            );
                            Get.back();
                          } else {
                            DalgeurakToast().show("시간 포멧이 정상적이지 않습니다. 다시 시도해주세요.");
                          }
                        }
                    ),
                    child: BlueButton(content: "확인", isLong: false, isFill: true, isSmall: false, isDisable: false),
                  ),
                ],
              ),
            ),
          )
        ],
      )
  );

  showChooseModifyMealInfoKind() => _dalgeurakBottomSheet.show(
    0.55,
    Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(width: Get.width, height: Get.height * 0.55),
        Positioned(
            top: Get.height * 0.04,
            left: Get.width * 0.07,
            child: Text("급식 정보 수정", style: homeBottomSheetTitle)
        ),
        Positioned(
            top: Get.height * 0.075,
            left: Get.width * 0.07,
            child: Text("수정할 시간대와 종류를 선택하세요.", style: homeBottomSheetSubTitle)
        ),
        Positioned(
            top: Get.height * 0.1,
            child: Container(width: Get.width * 0.871, child: Divider(color: dalgeurakGrayTwo, thickness: 1.0))
        ),
        Positioned(
          top: Get.height * 0.19,
          child: Obx(() => Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("시간대", style: homeChooseModifyMealInfoKindSheetInfoKind),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => modifyMealInfoTime.value = MealType.lunch,
                        child: BlueButton(content: "점심", isLong: false, isFill: (modifyMealInfoTime.value == MealType.lunch), isSmall: true, isDisable: (modifyMealInfoTime.value == MealType.none))
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                          onTap: () => modifyMealInfoTime.value = MealType.dinner,
                          child: BlueButton(content: "저녁", isLong: false, isFill: (modifyMealInfoTime.value == MealType.dinner), isSmall: true, isDisable: (modifyMealInfoTime.value == MealType.none))
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("종류", style: homeChooseModifyMealInfoKindSheetInfoKind),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () => modifyMealInfoType.value = ModifyMealInfoType.sequence,
                          child: BlueButton(content: "순서", isLong: false, isFill: (modifyMealInfoType.value == ModifyMealInfoType.sequence), isSmall: true, isDisable: (modifyMealInfoType.value == ModifyMealInfoType.none))
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                          onTap: () => modifyMealInfoType.value = ModifyMealInfoType.place,
                          child: BlueButton(content: "장소", isLong: false, isFill: (modifyMealInfoType.value == ModifyMealInfoType.place), isSmall: true, isDisable: (modifyMealInfoType.value == ModifyMealInfoType.none))
                      ),
                    ],
                  )
                ],
              )
            ],
          ))
        ),
        Positioned(
          bottom: Get.height * 0.1,
          child: Row(
            children: [
              GestureDetector(onTap: () => Get.back(), child: BlueButton(content: "취소", isLong: false, isSmall: false, isFill: false, isDisable: false)),
              SizedBox(width: 30),
              GestureDetector(
                onTap: () {
                  if (modifyMealInfoType.value != ModifyMealInfoType.none && modifyMealInfoTime.value != MealType.none) {
                    Get.back();
                    if (modifyMealInfoType.value == ModifyMealInfoType.sequence) {
                      showMealSequence();
                    } else if (modifyMealInfoType.value == ModifyMealInfoType.place) {
                      showMealPlace();
                    }
                  } else {
                    _dalgeurakToast.show("수정할 정보 종류를 선택 후 다시 시도해주세요.");
                  }
                },
                child: BlueButton(content: "확인", isLong: false, isSmall: false, isFill: true, isDisable: false)
              ),
            ],
          ),
        )
      ],
    )
  );

  showMealSequence() => _dalgeurakBottomSheet.show(
      0.55,
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(width: Get.width, height: Get.height * 0.55),
          Positioned(
              top: Get.height * 0.04,
              left: Get.width * 0.07,
              child: Text("급식 급식 순서 수정", style: homeBottomSheetTitle)
          ),
          Positioned(
              top: Get.height * 0.075,
              left: Get.width * 0.07,
              child: Text("급식 순서대로 반을 터치하세요.", style: homeBottomSheetSubTitle)
          ),
          Positioned(
              top: Get.height * 0.1,
              child: Container(width: Get.width * 0.871, child: Divider(color: dalgeurakGrayTwo, thickness: 1.0))
          ),
          Positioned(
            top: Get.height * 0.13,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("1학년", style: homeMealSequenceSheetGradeKind),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: 350,
                      height: 50,
                      child: ListView.builder(
                          itemCount: 6,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Obx(() {
                                  int listIndex = modifyMealClassSequence[1]!.indexOf(index+1);

                                  return GestureDetector(
                                      onTap: () {
                                        if (listIndex == -1) {
                                          modifyMealClassSequence[1]!.add(index+1);
                                        } else {
                                          modifyMealClassSequence[1]!.remove(index+1);
                                        }
                                      },
                                      child: SequenceBlueButton(content: "${index+1}반", sequenceNum: listIndex+1, isEnable: listIndex != -1)
                                  );
                                }),
                                const SizedBox(width: 10)
                              ],
                            );
                          }
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("2학년", style: homeMealSequenceSheetGradeKind),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: 350,
                      height: 50,
                      child: ListView.builder(
                          itemCount: 6,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Obx(() {
                                  int listIndex = modifyMealClassSequence[2]!.indexOf(index+1);

                                  return GestureDetector(
                                      onTap: () {
                                        if (listIndex == -1) {
                                          modifyMealClassSequence[2]!.add(index+1);
                                        } else {
                                          modifyMealClassSequence[2]!.remove(index+1);
                                        }
                                      },
                                      child: SequenceBlueButton(content: "${index+1}반", sequenceNum: listIndex+1, isEnable: listIndex != -1)
                                  );
                                }),
                                const SizedBox(width: 10)
                              ],
                            );
                          }
                      ),
                    )
                  ],
                ),
              ],
            )
          ),
          Positioned(
            bottom: Get.height * 0.1,
            child: Row(
              children: [
                GestureDetector(onTap: () => Get.back(), child: BlueButton(content: "취소", isLong: false, isSmall: false, isFill: false, isDisable: false)),
                SizedBox(width: 30),
                GestureDetector(
                    onTap: () {
                      if (modifyMealClassSequence[1]!.length == 6 && modifyMealClassSequence[2]!.length == 6) {
                        mealController.setMealSequence(modifyMealInfoTime.value, modifyMealClassSequence);
                      } else {
                        _dalgeurakToast.show("모든 반의 순서를 지정하고 다시 시도해주세요.");
                      }
                    },
                    child: BlueButton(content: "확인", isLong: false, isSmall: false, isFill: true, isDisable: false)
                ),
              ],
            ),
          )
        ],
      )
  );

  showMealPlace() => _dalgeurakBottomSheet.show(
      0.55,
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(width: Get.width, height: Get.height * 0.55),
          Positioned(
              top: Get.height * 0.04,
              left: Get.width * 0.07,
              child: Text("급식 정보 장소수정", style: homeBottomSheetTitle)
          ),
          Positioned(
              top: Get.height * 0.075,
              left: Get.width * 0.07,
              child: Text("장소를 선택하고 확인을 누르세요.", style: homeBottomSheetSubTitle)
          ),
          Positioned(
              top: Get.height * 0.1,
              child: Container(width: Get.width * 0.871, child: Divider(color: dalgeurakGrayTwo, thickness: 1.0))
          ),
          Positioned(
              top: Get.height * 0.22,
              child: Obx(() => Row(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () => modifyMealPlaceType.value = MealWaitingPlaceType.corridor,
                          child: BlueButton(content: "1학년 복도", isLong: false, isFill: (modifyMealPlaceType.value == MealWaitingPlaceType.corridor), isSmall: false, isDisable: false)
                      ),
                      const SizedBox(width: 24),
                      GestureDetector(
                          onTap: () => modifyMealPlaceType.value = MealWaitingPlaceType.outside,
                          child: BlueButton(content: "외부 통로", isLong: false, isFill: (modifyMealPlaceType.value == MealWaitingPlaceType.outside), isSmall: false, isDisable: false)
                      ),
                    ],
                  )
                ],
              ))
          ),
          Positioned(
            bottom: Get.height * 0.1,
            child: Row(
              children: [
                GestureDetector(onTap: () => Get.back(), child: BlueButton(content: "취소", isLong: false, isSmall: false, isFill: false, isDisable: false)),
                SizedBox(width: 30),
                GestureDetector(
                    onTap: () => mealController.setMealWaitingPlace(modifyMealPlaceType.value),
                    child: BlueButton(content: "확인", isLong: false, isSmall: false, isFill: true, isDisable: false)
                ),
              ],
            ),
          )
        ],
      )
  );
}