import 'package:safe_device/safe_device.dart';

class IsSimulator {
  static Future<bool> isRealDevice() async {
    bool isRealDevice = await SafeDevice.isRealDevice;
    return isRealDevice;
  }
}
