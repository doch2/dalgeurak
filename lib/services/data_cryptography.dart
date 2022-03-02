import 'dart:convert';

import 'package:cryptography/cryptography.dart';

class DataCryptography {
  final algorithm = AesCtr.with256bits(macAlgorithm: Hmac.sha512());

  Future<String> encrypt(String data) async {
    final secretKey = SecretKey(utf8.encode("d1Z3UwZub780Sj5zulNJ0lN4dvzbjepJ")); //TODO 키 추가하기 - 현재는 오류 방지용 임시키

    final secretBox = await algorithm.encrypt(
        utf8.encode(data),
        secretKey: secretKey);

    return secretBox.cipherText.toString() + "_" + secretBox.nonce.toString() + "_" + secretBox.mac.bytes.toString();
  }

  Future<String> decrypt(SecretBox secretBox) async => utf8.decode(await algorithm.decrypt(secretBox, secretKey: SecretKey(utf8.encode("d1Z3UwZub780Sj5zulNJ0lN4dvzbjepJ")))); //TODO 키 추가하기 - 현재는 오류 방지용 임시키
}