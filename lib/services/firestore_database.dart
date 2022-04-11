import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:get/get.dart';

class FirestoreDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserController userController = Get.find<UserController>();
  final DalgeurakService _dalgeurakService = Get.find<DalgeurakService>();

  Future<Map> getLeftStudentAmount(int grade, int classNum) async {
    try {
      Map<String, dynamic>? classInfo = (await _firestore.collection("students").doc("$grade-$classNum").get()).data();

      if (classInfo != null) { //반이 등록되지 않았을 시
        int leftPeople = classInfo["studentAmount"];

        for (int i=1; i<=classInfo["studentAmount"]; i++) {
          if (classInfo["$i"] != null) { //학생이 등록되지 않았을 시
            String nowTime = "${DateTime.now().month}${DateTime.now().day}_${_dalgeurakService.getMealKind(false).convertEngStr}";

            if (classInfo["$i"]["lastCheckInTime"] != null && classInfo["$i"]["lastCheckInTime"] == nowTime) { //한번도 체크인 한 적이 없거나 날짜가 같지 않을 시
              leftPeople--;
            } else if(classInfo["$i"]["isNotEatMeal"] != null && classInfo["$i"]["isNotEatMeal"] == true && classInfo["$i"]["checkNotEatMealTime"] == nowTime) { //급식 안먹는다고 표시하였을 시
              leftPeople--;
            }
          }
        }

        return {"totalAmount": classInfo["studentAmount"], "leftPeople": leftPeople};
      } else {
        return {};
      }
    } catch (e) {
      print(e);
      return {};
    }
  }
}
