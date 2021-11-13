import 'package:dalgeurak/controllers/qrcode_controller.dart';
import 'package:dalgeurak/screens/qrcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    if (!Get.find<QrCodeController>().isCreateRefreshTimer) { Get.find<QrCodeController>().refreshTimer(); Get.find<QrCodeController>().isCreateRefreshTimer = true; }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Home Page"),
            SizedBox(height: _height * 0.1),
            GetBuilder<QrCodeController> (
              init: QrCodeController(),
              builder: (qrCodeController) => Obx(() {
                String data = qrCodeController.qrImageData.value;
                if (data == "initData") {
                  return CircularProgressIndicator();
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      QrImage(
                        data: qrCodeController.qrImageData.value,
                        version: QrVersions.auto,
                        size: _width * 0.5,
                      ),
                      Text("남은 시간: ${qrCodeController.refreshTime.value}")
                    ],
                  );
                }
              }),
            ),
            SizedBox(height: _height * 0.15),
            GetBuilder<QrCodeController> (
              init: QrCodeController(),
              builder: (qrCodeController) => GestureDetector(onTap: () => Get.to(QrCodeScan()), child: Text("QR코드 스캔하기")),
            ),
          ],
        ),
      ),
    );
  }
}