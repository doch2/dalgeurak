import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/models/user.dart';
import 'package:dalgeurak/services/firestore_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  FirebaseAuth authInstance = FirebaseAuth.instance;

  Rxn<User> _firebaseUser = Rxn<User>();
  User? get user => _firebaseUser.value;

  @override
  onInit() {
    _firebaseUser.bindStream(authInstance.authStateChanges());
  }

  void signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential _authResult = await FirebaseAuth.instance.signInWithCredential(credential);

    writeAccountInfo(_authResult.user?.uid, googleUser?.email, googleUser?.displayName, googleUser?.photoUrl, false);
  }

  void logOut() async {
    try {
      await authInstance.signOut();

      Get.find<UserController>().clear();

      Fluttertoast.showToast(
          msg: "로그아웃 되었습니다.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xE6FFFFFF),
          textColor: Colors.black,
          fontSize: 13.0
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "로그아웃 오류",
        e.message ?? "예기치 못한 오류가 발생하였습니다.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void writeAccountInfo(String? userID, String? email, String? name, String? profileImgUrl, bool isEmailSignUp) async {
    UserModel _user = UserModel(
      id: userID,
      email: email,
      name: name,
      profileImg: profileImgUrl,
    );

    if (isEmailSignUp) {
      if (await FirestoreDatabase().createNewUser(_user)) {
        Get.find<UserController>().user = _user;
      }
    } else {
      FirebaseFirestore.instance
          .collection("users")
          .doc(userID)
          .get()
          .then((doc) async {
        if (doc.exists) {
          print("exists");
        } else {
          if (await FirestoreDatabase().createNewUser(_user)) {
            Get.find<UserController>().user = _user;
          }
        }
      }
      );
    }
  }
}
