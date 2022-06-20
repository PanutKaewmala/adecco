// ignore_for_file: non_constant_identifier_names

import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:geolocator/geolocator.dart';

class CheckInData {
  Position posiotion;
  AddressNameModel addressNameModel;
  String checkInTime;
  int? workPlaceID;
  int? workingHourID;
  CheckInPageType checkInPageType;
  bool isOT;
  String description;
  int? pair_id;

  CheckInData(
      {required this.posiotion,
      required this.addressNameModel,
      required this.checkInTime,
      this.workPlaceID,
      this.workingHourID,
      required this.checkInPageType,
      this.isOT = false,
      this.description = "",
      this.pair_id});
}
