import 'package:dalgeurak/controllers/qrcode_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScan extends GetWidget<QrCodeController> {
  QrCodeScan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: _width,
              height: _height,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                    borderColor: Colors.red,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: _width * 0.5),
                onPermissionSet: (ctrl, p) {
                  if (!p) {
                    Permission.camera.request();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController scanController) {
    controller.scanController = scanController;

    scanController.scannedDataStream.listen((scanData) => controller.analyzeQrCodeData(scanData.code));
  }
}