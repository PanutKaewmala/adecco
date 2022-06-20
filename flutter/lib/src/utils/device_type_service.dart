import 'package:ahead_adecco/src/config/export_config.dart';

class DeviceTypeSize {
  static DeviceType getDeviceType() {
    final data = SizerUtil.deviceType;
    UserConfig.deviceType = data;
    return data;
  }

  static bool isTablet() {
    switch (UserConfig.deviceType) {
      case DeviceType.mobile:
        return false;
      case DeviceType.tablet:
        return true;
      default:
        return false;
    }
  }

  static double getSizeType(
      {required double sizeMobile, required double sizeTablet}) {
    switch (UserConfig.deviceType) {
      case DeviceType.mobile:
        return sizeMobile;
      case DeviceType.tablet:
        return sizeTablet;
      default:
        return sizeMobile;
    }
  }
}
