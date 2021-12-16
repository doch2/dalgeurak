import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/models/user.dart';
import 'package:dalgeurak/screens/auth/signup_selectgroup.dart';
import 'package:dalgeurak/services/firestore_database.dart';
import 'package:dalgeurak/token_reference.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/all.dart'as kakaoFlutterLib;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthController extends GetxController {
  FirebaseAuth authInstance = FirebaseAuth.instance;

  Rxn<User> _firebaseUser = Rxn<User>();
  User? get user => _firebaseUser.value;
  Map loginUserInfo = {}; //userID, email, name, profileImgUrl
  RxString selectGroupName = "init".obs;

  RxBool isLogin = false.obs;

  final Dio _dio = Get.find<Dio>();


  @override
  onInit() async {
    _firebaseUser.bindStream(authInstance.authStateChanges());
    _firebaseUser.value = authInstance.currentUser;
    Get.find<UserController>().user = await FirestoreDatabase().getUser(user!.uid);

    kakaoFlutterLib.KakaoContext.clientId = TokenReference().kakaoNativeKey;
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

    loginUserInfo["userid"] = _authResult.user?.uid;
    loginUserInfo["email"] = googleUser?.email;
    loginUserInfo["name"] = googleUser?.displayName;
    loginUserInfo["profileImgUrl"] = googleUser?.photoUrl;

    if (_authResult.additionalUserInfo!.isNewUser) { Get.to(SignUpSelectGroup()); } else { isLogin.value = true; Get.find<UserController>().user = await FirestoreDatabase().getUser(user!.uid); }
  }

  void signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      UserCredential _authResult = await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      loginUserInfo["userid"] = _authResult.user?.uid;
      loginUserInfo["email"] = appleCredential.email;
      loginUserInfo["name"] = "${appleCredential.familyName}${appleCredential.givenName}";
      loginUserInfo["profileImgUrl"] = "";

      if (_authResult.additionalUserInfo!.isNewUser) { Get.to(SignUpSelectGroup()); } else { isLogin.value = true; Get.find<UserController>().user = await FirestoreDatabase().getUser(user!.uid); }
    } catch(error) {
      print(error);
    }
  }

  void signInWithKakao() async {
    try {
      final installed = await kakaoFlutterLib.isKakaoTalkInstalled();
      String authCode = installed ? await kakaoFlutterLib.AuthCodeClient.instance.requestWithTalk() : await kakaoFlutterLib.AuthCodeClient.instance.request();

      kakaoFlutterLib.OAuthToken token = await kakaoFlutterLib.AuthApi.instance.issueAccessToken(authCode);
      kakaoFlutterLib.TokenManagerProvider.instance.manager.setToken(token);

      String accessToken = token.accessToken;

      kakaoFlutterLib.User user = await kakaoFlutterLib.UserApi.instance.me();

      loginUserInfo["userid"] = "kakao:${user.id}";
      loginUserInfo["email"] = user.kakaoAccount!.email;
      loginUserInfo["name"] = user.kakaoAccount!.profile!.nickname;
      loginUserInfo["profileImgUrl"] = user.kakaoAccount!.profile!.profileImageUrl;

      Response response = await _dio.post(
          'https://asia-northeast3-dalgeurak-58ca5.cloudfunctions.net/kakaoToken',
          data: {
            "data": {
              "access_token": accessToken
            }
          });

      await FirebaseAuth.instance.signInWithCustomToken(response.data["result"]);

      if (await FirestoreDatabase().isAlreadyRegisterUser(loginUserInfo["userid"])) { isLogin.value = true; Get.find<UserController>().user = await FirestoreDatabase().getUser(this.user!.uid); } else { Get.to(SignUpSelectGroup()); }
    } catch (e) {
      if (e.toString().contains("User canceled login.")) {
        Fluttertoast.showToast(
            msg: "카카오 로그인을 취소하셨습니다.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xE6FFFFFF),
            textColor: Colors.black,
            fontSize: 13.0
        );
      } else {
        print(e);
      }
    }
  }

  void logOut() async {
    try {
      await authInstance.signOut();

      Get.find<UserController>().clear();

      isLogin.value = false;

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

  void writeAccountInfo() async {
    UserModel _user = UserModel(
      id: loginUserInfo["userid"],
      email: loginUserInfo["email"],
      name: loginUserInfo["name"],
      profileImg: loginUserInfo["profileImgUrl"],
      group: loginUserInfo["group"],
      studentId: "${loginUserInfo["grade"]}${loginUserInfo["class"]}${loginUserInfo["number"]}"
    );

    await FirebaseFirestore.instance
        .collection("users")
        .doc(loginUserInfo["userid"])
        .get()
        .then((doc) async {
      if (doc.exists) {
        print("User info is already exist");
      } else {
        await FirestoreDatabase().createNewUser(_user);
      }
    }
    );

    Get.find<UserController>().user = _user;
  }

  addStudentInfo() async {
    bool result = await FirestoreDatabase().addStudentInfo(loginUserInfo["grade"], loginUserInfo["class"], loginUserInfo["number"], loginUserInfo["name"], loginUserInfo["group"], loginUserInfo["userid"]);

    if (result) { isLogin.value = true; Get.back(); }
  }
}
