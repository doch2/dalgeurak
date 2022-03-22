import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class QrCodeController extends GetxController {
  DalgeurakService _dalgeurakService = DalgeurakService();

  QRViewController? scanController;

  RxString qrImageData = "initData".obs;
  RxInt refreshTime = 0.obs;

  setQrCodeData(String QRKey) async {
    String result = "dalgeurak_checkin_qr://";

    result = result + QRKey;

    qrImageData.value = result;
  }

  analyzeQrCodeData(String? scanResult) async {
    scanController!.pauseCamera();

    if (scanResult!.contains("dalgeurak_checkin_qr://")) {
      Map checkInResult = await _dalgeurakService.mealCheckInWithJWT(scanResult.substring(scanResult.indexOf("://")+3));

      if (checkInResult["result"] == "success") {
        showToast("${checkInResult['name']}님 체크인 되었습니다.");
      } else {
        showToast(checkInResult['content']);
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