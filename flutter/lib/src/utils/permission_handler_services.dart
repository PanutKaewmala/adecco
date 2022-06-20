export 'package:permission_handler/permission_handler.dart';
import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:location/location.dart' as location;

class LocationPermissionServices {
  static Future<bool> checkPermission() async {
    final status = await Permission.locationWhenInUse.request();
    switch (status) {
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.permanentlyDenied:
        await openAppSettings();
        return false;
      default:
        return false;
    }
  }

  static Future<bool> checkLocation() async {
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus == ServiceStatus.enabled;
    if (!isGpsOn) {
      return await requestLocation();
    } else {
      return true;
    }
  }

  static Future<bool> requestLocation() async {
    final locationStatus = location.Location();
    if (!await locationStatus.serviceEnabled()) {
      return await locationStatus.requestService();
    } else {
      return true;
    }
  }
}
