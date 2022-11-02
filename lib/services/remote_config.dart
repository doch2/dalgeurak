import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';


class RemoteConfigService extends GetxService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  @override
  onInit() async {
    super.onInit();

    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 60),
        minimumFetchInterval: Duration(seconds: 0),
      ),
    );
    await _remoteConfig.setDefaults({"dienenManualUrl": "https://dimigo.in", "minAppVersion": "2.0.4"});
    await _remoteConfig.activate();
    await Future.delayed(const Duration(seconds: 350));
    await _remoteConfig.fetch();
    await _remoteConfig.fetchAndActivate();
  }

  getDienenManualFileUrl() => _remoteConfig.getString("dienenManualUrl");
}