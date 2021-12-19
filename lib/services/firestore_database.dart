import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/models/user.dart';
import 'package:get/get.dart';

class FirestoreDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserController userController = Get.find<UserController>();

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection("users").doc(user.id).set({
        "name": user.name,
        "email": user.email,
        "profileImg": user.profileImg,
        "group": user.group,
        "studentId": user.studentId,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserModel> getUser(String? uid) async {
    try {
      DocumentSnapshot _doc =
          await _firestore.collection("users").doc(uid).get();
      return UserModel?.fromDocumentSnapshot(documentSnapshot: _doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> isAlreadyRegisterUser(String? uid) async {
    try {
      DocumentSnapshot _doc = await _firestore.collection("users").doc(uid).get();

      if (_doc.data() == null) { return false; } else { return true; }
    } catch (e) {
      return false;
    }
  }

  Future<String> getUserMealTime(String? mealKind) async {
    try {
      String? studentId = userController.user.studentId;

      DocumentSnapshot _doc = await _firestore.collection("reference").doc("mealSequence").get();
      int mealSequence = (_doc.data() as dynamic)[mealKind][studentId!.substring(0, 1)][studentId.substring(1, 2)];

      _doc = await _firestore.collection("reference").doc("mealTime").get();
      String mealTime = (_doc.data() as dynamic)[mealKind][studentId.substring(0, 1)][mealSequence.toString()].toString();
      return "${mealTime.substring(0, 2)}시 ${mealTime.substring(2, 4)}분";
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> getStudentIsNotEatMeal() async {
    try {
      String? studentId = userController.user.studentId;

      Map studentInfo = ((await _firestore.collection("students").doc("${studentId!.substring(0, 1)}-${studentId.substring(1, 2)}").get()).data() as dynamic)[studentId.substring(2)];

      if (studentInfo["isNotEatMeal"] == null) { return false; } else { return studentInfo["isNotEatMeal"]; }

    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> setStudentIsNotEatMeal() async {
    try {
      String? studentId = userController.user.studentId;
      String studentClass = "${studentId!.substring(0, 1)}-${studentId.substring(1, 2)}"; String studentNumber = studentId.substring(2);
      Map studentInfo = ((await _firestore.collection("students").doc(studentClass).get()).data() as dynamic)[studentNumber];
      studentInfo["isNotEatMeal"] = Get.find<MealController>().userNotEatMeal.value;
      studentInfo["checkNotEatMealTime"] = "${DateTime.now().month}${DateTime.now().day}_${Get.find<MealController>().getMealKind("eng", false)}";

      await _firestore.collection("students").doc(studentClass).update({
        studentNumber: studentInfo,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }


  Future<Map> getUserInfoForCheckIn(String uid) async {
    try {
      DocumentSnapshot _doc = await _firestore.collection("users").doc(uid).get();
      Map miniProfileInfo = {};
      miniProfileInfo["name"] = (_doc.data() as dynamic)['name'];
      miniProfileInfo["studentId"] = (_doc.data() as dynamic)['studentId'];

      Map studentInfo = ((await _firestore.collection("students").doc(miniProfileInfo["studentId"].substring(0, 1) + "-" + miniProfileInfo["studentId"].substring(1, 2)).get()).data() as dynamic)[miniProfileInfo["studentId"].substring(2)];
      miniProfileInfo["lastCheckInTime"] = studentInfo['lastCheckInTime'];

      return miniProfileInfo;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<int> getMealTimeForCheckIn(String studentGrade, String studentClass, String mealKind) async {
    try {
      DocumentSnapshot _doc = await _firestore.collection("reference").doc("mealTime").get();

      int result = (_doc.data() as dynamic)[mealKind][studentGrade][studentClass];

      return result;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> setStudentMealStatus(String studentClass, String studentNumber, String mealStatus, String mealTime) async {
    try {
      Map studentInfo = ((await _firestore.collection("students").doc(studentClass).get()).data() as dynamic)[studentNumber];
      studentInfo["mealStatus"] = mealStatus;
      studentInfo["lastCheckInTime"] = mealTime;

      await _firestore.collection("students").doc(studentClass).update({
        studentNumber: studentInfo,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addStudentQrCodeLog(String userID, String mealKind, String mealStatus) async {
    try {
      DateTime nowTime = DateTime.now();

      if (((await _firestore.collection("users").doc(userID).collection("checkInLog").doc("${nowTime.year}").get()).data() as dynamic) == null) { await _firestore.collection("users").doc(userID).collection("checkInLog").doc("${nowTime.year}").set({}); } //checkInLog Collection이 생성되지 않았을 경우 새로 생성
      if (((await _firestore.collection("users").doc(userID).collection("checkInLog").doc("${nowTime.year}").get()).data() as dynamic)[nowTime.month.toString()] == null) { await _firestore.collection("users").doc(userID).collection("checkInLog").doc("${nowTime.year}").set({nowTime.month.toString(): {}}); } //checkInLog Collection의 현재 달 Field 생성되지 않았을 경우 새로 생성

      Map checkInLog = ((await _firestore.collection("users").doc(userID).collection("checkInLog").doc("${nowTime.year}").get()).data() as dynamic)[nowTime.month.toString()];
      if (checkInLog[nowTime.day.toString()] == null) { checkInLog[nowTime.day.toString()] = {}; }
      if (checkInLog[nowTime.day.toString()][mealKind] == null) { checkInLog[nowTime.day.toString()][mealKind] = {}; }
      checkInLog[nowTime.day.toString()][mealKind]["time"] = "${DateTime.now().hour}${DateTime.now().minute}";
      checkInLog[nowTime.day.toString()][mealKind]["mealStatus"] = mealStatus;

      await _firestore.collection("users").doc(userID).collection("checkInLog").doc("${nowTime.year}").update({
        nowTime.month.toString(): checkInLog
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map<String, dynamic>?> getStudentQrCodeLog(String? userID) async {
    try {
      DateTime nowTime = DateTime.now();

      Map<String, dynamic>? checkInLog = (await _firestore.collection("users")
          .doc(userID)
          .collection("checkInLog")
          .doc("${nowTime.year}").get()).data();

      return checkInLog;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> getKey() async {
    try {
      DocumentSnapshot _doc =
      await _firestore.collection("reference").doc("key").get();
      return _doc["content"];
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> addStudentInfo(int grade, int _class, int number, String name, String group, String userID) async {
    try {
      await _firestore.collection("students").doc("$grade-$_class").update({
        "studentAmount": 1,
        "$number": {
          "name": name,
          "userID": userID,
          "group": group,
        },
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map> getLeftStudentAmount(int grade, int classNum) async {
    try {
      Map<String, dynamic>? classInfo = (await _firestore.collection("students").doc("$grade-$classNum").get()).data();

      if (classInfo != null) { //반이 등록되지 않았을 시
        int leftPeople = classInfo["studentAmount"];

        for (int i=1; i<=classInfo["studentAmount"]; i++) {
          if (classInfo["$i"] != null) { //학생이 등록되지 않았을 시
            String nowTime = "${DateTime.now().month}${DateTime.now().day}_${Get.find<MealController>().getMealKind("eng", false)}";

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
