import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
<<<<<<< HEAD
import 'package:dalgeurak/models/user.dart';
import 'package:dalgeurak/screens/auth/signup_selectgroup.dart';
import 'package:dalgeurak/services/firestore_database.dart';
import 'package:dio/dio.dart';
=======
import 'package:dalgeurak/screens/auth/login_success.dart';
import 'package:dalgeurak_widget_package/widgets/toast.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
>>>>>>> 92c83953fd75001b4a696ac8f90034ff2b2f9a90
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakaoFlutterLib;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthController extends GetxController {
  FirebaseAuth authInstance = FirebaseAuth.instance;
<<<<<<< HEAD
=======
  DimigoinAccount _dimigoinAccount = Get.find<DimigoinAccount>();
  DalgeurakService _dalgeurakService = Get.find<DalgeurakService>();
  DalgeurakToast _dalgeurakToast = DalgeurakToast();
>>>>>>> 92c83953fd75001b4a696ac8f90034ff2b2f9a90

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
    if (user != null) { Get.find<UserController>().user = await FirestoreDatabase().getUser(user!.uid); }
  }

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

<<<<<<< HEAD
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


    return _authResult;
  }

  signInWithApple() async {
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


      return _authResult;
    } catch(error) {
      print(error);
=======
      Get.to(LoginSuccess());
    } else {
      _dalgeurakToast.show("로그인에 실패하였습니다. 다시 시도해주세요.");
>>>>>>> 92c83953fd75001b4a696ac8f90034ff2b2f9a90
    }
  }

  signInWithKakao() async {
    try {
      final installed = await kakaoFlutterLib.isKakaoTalkInstalled();
      kakaoFlutterLib.OAuthToken loginToken = installed
          ? await kakaoFlutterLib.UserApi.instance.loginWithKakaoTalk()
          : await kakaoFlutterLib.UserApi.instance.loginWithKakaoAccount();

<<<<<<< HEAD
      kakaoFlutterLib.User user = await kakaoFlutterLib.UserApi.instance.me();

      loginUserInfo["userid"] = "kakao:${user.id}";
      loginUserInfo["email"] = user.kakaoAccount!.email;
      loginUserInfo["name"] = user.kakaoAccount!.profile!.nickname;
      loginUserInfo["profileImgUrl"] = user.kakaoAccount!.profile!.profileImageUrl;

      Response response = await _dio.post(
          'https://asia-northeast3-dalgeurak-58ca5.cloudfunctions.net/kakaoToken',
          data: {
            "data": {
              "access_token": loginToken.accessToken
            }
          });

      UserCredential _authResult = await FirebaseAuth.instance.signInWithCustomToken(response.data["result"]);

      if (await FirestoreDatabase().isAlreadyRegisterUser(loginUserInfo["userid"])) { isLogin.value = true; Get.find<UserController>().user = await FirestoreDatabase().getUser(this.user!.uid); } else { Get.to(SignUpSelectGroup()); }


      return _authResult;
    } catch (e) {
      if (e.toString().contains("User canceled login.")) {
        _showToast("카카오 로그인을 취소하셨습니다.");
      } else {
        print(e);
      }
    }
  }

  logOut() async {
    try {
      await authInstance.signOut();
=======
    _dalgeurakToast.show("로그아웃 되었습니다.");
  }

  logOutFirebaseAccount() async => await authInstance.signOut();

  loginSuccessScreenAnimate(double height, double width) {
    btnContainerPositioned.value = -(height * 0.07);
    helloTextPositioned.value = height * 0.6;
    subTitlePositioned['top'] = height * 0.5;
    subTitlePositioned['left'] = width * 0.434;
    successCheckIconPositioned["top"] = (height * 0.5);
    successCheckIconPositioned["left"] = (width * 0.5);
>>>>>>> 92c83953fd75001b4a696ac8f90034ff2b2f9a90

      Get.find<UserController>().clear();

      isLogin.value = false;

      _showToast("로그아웃 되었습니다.");
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

  deleteAccount() async {
    Get.dialog(
      AlertDialog(
        title: Text("달그락 회원 탈퇴"),
        content: Text("본인 확인을 위해, 재로그인을 진행한 후 회원 탈퇴 처리를 진행합니다.\n본 절차는 실행 후 취소할 수 없으며, 삭제된 계정 복구는 불가능합니다."),
        actions: [
          TextButton(onPressed: () async {
            String? providerId = user?.providerData[0].providerId;

            UserCredential? userCredential;
            if (providerId!.contains("google")) {
              userCredential = await signInWithGoogle();
            } else if (providerId.contains("apple")) {
              userCredential = await signInWithApple();
            } else {
              userCredential = await signInWithKakao();
            }

            if (userCredential == null) {
              _showToast("재로그인에 실패하였습니다. \n탈퇴를 중단합니다.");
            } else {
              if (await FirestoreDatabase().deleteUser(user!.uid)) {
                user?.delete();
                await logOut();
                _showToast("탈퇴에 성공하였습니다.");
              } else {
                _showToast("DB 관련 오류가 발생하여 실패하였습니다. \n탈퇴를 중단합니다.");
              }
            }


            Get.back();
          }, child: Text("확인")),
          TextButton(onPressed: () => Get.back(), child: Text("취소")),
        ],
      )
    );
  }

  _showToast(String content) {
    Fluttertoast.showToast(
        msg: content,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xE6FFFFFF),
        textColor: Colors.black,
        fontSize: 13.0
    );
  }
}
