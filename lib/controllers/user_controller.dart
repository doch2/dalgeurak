import 'package:dalgeurak/models/user.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  Rx<UserModel> _userModel = UserModel().obs;

  UserModel get user => _userModel.value;

  set user(UserModel value) => this._userModel.value = value;

  void clear() {
    _userModel.value = UserModel();
  }

  dynamic getProfileWidget(double _width) {
    if (user.profileImg == "") {
      return Icon(Icons.person_rounded, size: _width * 0.12);
    } else {
      return ExtendedImage.network(user.profileImg!, cache: true);
    }
  }

  String getModifyStudentId() { //수정된 학번 불러오기 ex) 161 -> 1601
    String result = user.studentId!.substring(0, 2);
    if (user.studentId!.substring(2).length > 1) { result = result + user.studentId!.substring(2); } else { result = result + "0${user.studentId!.substring(2)}"; }

    return result;
  }
}
