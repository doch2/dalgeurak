import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/services/data_cryptography.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class QrCodeController extends GetxController {
  DataCryptography _dataCryptography = DataCryptography();
  DalgeurakService _dalgeurakService = DalgeurakService();

  QRViewController? scanController;

  RxString qrImageData = "initData".obs;
  RxInt refreshTime = 0.obs;
  bool isCreateRefreshTimer = false;

  Future<void> refreshTimer() async {
    try {
      while (true) {
        await Future.delayed(
            Duration(seconds: 1),
                () async {
              if (refreshTime.value == 0) {
                await getData();
                refreshTime.value = 30;
              } else {
                refreshTime.value = refreshTime.value - 1;
              }
            }
        );
      }
    } catch (e) { //중간에 로그아웃 되서 타이머가 오류가 났을 경우
      isCreateRefreshTimer = false;
    }
  }

  getData() async {
    String result = "dalgeurak_checkin_qr://";

    result = result + await _dataCryptography.encrypt(
        Get.find<UserController>().user!.studentId!.toString() + Get.find<UserController>().user!.name! + "_" + DateTime.now().add(Duration(seconds: 30)).microsecondsSinceEpoch.toString()
    );

    qrImageData.value = result;
  }

  analyzeQrCodeData(String? scanResult) async {
    scanController!.pauseCamera();

    if (scanResult!.contains("dalgeurak_checkin_qr://")) {
      try {
        List<int> cipherText = json.decode(scanResult.substring((scanResult.indexOf("qr://") + 5), scanResult.indexOf("_", scanResult.indexOf("qr://")))).cast<int>();
        List<int> nonce = json.decode(scanResult.substring((scanResult.indexOf(cipherText.toString().substring(cipherText.toString().length-5)) + 6), scanResult.indexOf("_", (scanResult.indexOf(cipherText.toString().substring(cipherText.toString().length-5)) + 8)))).cast<int>();
        List<int> macData = json.decode(scanResult.substring((scanResult.indexOf(nonce.toString().substring(nonce.toString().length-5)) + 6))).cast<int>();

        SecretBox newSecretBox = SecretBox(cipherText, nonce: nonce, mac: Mac(macData));
        String decryptData = await _dataCryptography.decrypt(newSecretBox);

        if (int.parse(decryptData.substring(decryptData.indexOf("_") + 1)) < DateTime.now().microsecondsSinceEpoch) {
          showToast("QR코드의 유효기간이 지났습니다. \n다시 시도해 주세요.");
        } else {
          Map checkInResult = await _dalgeurakService.mealCheckInByManager(int.parse(decryptData.substring(0, 4)), decryptData.substring(4, decryptData.indexOf("_")));

          if (checkInResult["result"] == "success") {
            showToast("${checkInResult['name']}님 체크인 되었습니다.");
          } else if (checkInResult["result"] == "alreadyRegister") {
            showToast("이미 체크인 되었습니다.");
          } else {
            showToast("체크인에 실패하였습니다. 다시 시도해주세요.");
          }
        }
      } catch(e) {
        showToast("QR코드 데이터가 정확하지 않습니다. \n앱에서 발급된 QR코드인지 확인 후 다시 시도해 주세요.");
      }
    } else {
      showToast("달그락 체크인 QR코드가 아닙니다. \n다시 시도해주세요.");
    }

    scanController!.resumeCamera();
  }

  showToast(String message) => Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xE6FFFFFF),
      textColor: Colors.black,
      fontSize: 13.0
  );
}