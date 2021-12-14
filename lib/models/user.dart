import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? profileImg;
  String? group;
  String? studentId;

  UserModel({this.id, this.name, this.email, this.profileImg, this.group, this.studentId});

  UserModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    name = documentSnapshot["name"];
    email = documentSnapshot["email"];
    profileImg = documentSnapshot["profileImg"];
    group = documentSnapshot["group"];
    studentId = documentSnapshot["studentId"];
  }
}
