import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../models/export_models.dart';

class LocationService {
  Future<Position?> determinePosition({bool checkOnly = false}) async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      return !checkOnly
          ? await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          : null;
    } catch (e) {
      debugPrint("Location error: $e");
      return null;
    }
  }

  Future<AddressNameModel?> getLocationAddressModel(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark address = placemarks.first;
      AddressNameModel addressNameModel = AddressNameModel(
          name: "${address.name}",
          address:
              "${address.thoroughfare} ${address.subLocality} ${address.subAdministrativeArea} ${address.administrativeArea} ${address.postalCode}");
      return addressNameModel;
    } catch (e) {
      debugPrint("Location name error: $e");
      return null;
    }
  }

  Future<AddressNameModel?> getLocationAddressModelLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      Placemark address = placemarks.first;
      AddressNameModel addressNameModel = AddressNameModel(
          name: "${address.name}",
          address:
              "${address.thoroughfare} ${address.subLocality} ${address.subAdministrativeArea} ${address.administrativeArea} ${address.postalCode}");
      return addressNameModel;
    } catch (e) {
      debugPrint("Location name error: $e");
      return null;
    }
  }

  bool checkRadiusBetween(LatLng latlng1, LatLng latlng2, double radius) {
    double _radius = Geolocator.distanceBetween(latlng1.latitude,
        latlng1.longitude, latlng2.latitude, latlng2.longitude);
    debugPrint("$_radius < $radius");
    return _radius < radius;
  }

  Future checkLocationEnable() async {
    try {
      await LocationService().determinePosition(checkOnly: true);
    } catch (e) {
      DialogCustom.showBasicAlert(Texts.plsEnableLocation);
      rethrow;
    }
  }
}
