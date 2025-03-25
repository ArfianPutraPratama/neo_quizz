import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  final BuildContext context;

  DeviceInfoService(this.context);

  Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id ?? 'unknown_android';
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? 'unknown_ios';
      } else {
        return 'unsupported_platform';
      }
    } catch (e) {
      return 'error_$e';
    }
  }
}
