import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/models/user.dart';
import 'package:get/get.dart';

class FirestoreDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection("users").doc(user.id).set({
        "name": user.name,
        "email": user.email,
        "profileImg": user.profileImg,
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

  Future<int> getMealTimeForCheckIn(String studentClass, String mealKind) async {
    try {
      DocumentSnapshot _doc = await _firestore.collection("reference").doc("mealTime").get();

      int result = (_doc.data() as dynamic)[mealKind][studentClass];

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

  Future<bool> addStudentQrCodeLog(String userID, String mealKind) async {
    try {
      DateTime nowTime = DateTime.now();

      if (((await _firestore.collection("users").doc(userID).collection("checkInLog").doc("${nowTime.year}").get()).data() as dynamic) == null) { await _firestore.collection("users").doc(userID).collection("checkInLog").doc("${nowTime.year}").set({}); } //checkInLog Collection이 생성되지 않았을 경우 새로 생성
      if (((await _firestore.collection("users").doc(userID).collection("checkInLog").doc("${nowTime.year}").get()).data() as dynamic)[nowTime.month.toString()] == null) { await _firestore.collection("users").doc(userID).collection("checkInLog").doc("${nowTime.year}").set({nowTime.month.toString(): {}}); } //checkInLog Collection의 현재 달 Field 생성되지 않았을 경우 새로 생성

      Map checkInLog = ((await _firestore.collection("users").doc(userID).collection("checkInLog").doc("${nowTime.year}").get()).data() as dynamic)[nowTime.month.toString()];
      if (checkInLog[nowTime.day.toString()] == null) { checkInLog[nowTime.day.toString()] = {}; }
      checkInLog[nowTime.day.toString()][mealKind] = "${DateTime.now().hour}${DateTime.now().minute}";

      await _firestore.collection("users").doc(userID).collection("checkInLog").doc("${nowTime.year}").update({
        nowTime.month.toString(): checkInLog
      });
      return true;
    } catch (e) {
      print(e);
      return false;
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

  Future<bool> addStudentInfo(int grade, int _class, int number, String name, String userID) async {
    try {
      await _firestore.collection("students").doc("$grade-$_class").update({
        "studentAmount": 1,
        "$number": {
          "name": name,
          "userID": userID
        },
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
