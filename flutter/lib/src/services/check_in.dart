import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/services/export_services.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class CheckInService extends HttpService {
  Future<List<CheckInTasksModel>> checkIndailyTask(
      Map<String, String> params) async {
    try {
      var httpRequest = makeRequest(RequestMethod.get, ApiUrl.checkInDailyTask,
          queryParameters: params);
      var jsonString = await checkResponse(httpRequest);
      List<CheckInTasksModel> _dailyTasks = [];
      for (var item in jsonString as List) {
        _dailyTasks.add(CheckInTasksModel.fromJson(item));
      }
      return _dailyTasks;
    } catch (e) {
      debugPrint("Check In DailyTask Error: $e");
      rethrow;
    }
  }

  Future<int> checkInOut(Map<String, String> data, File? file) async {
    List<File> _fileList = [];
    try {
      if (file != null) {
        _fileList.add(file);
      }
      var httpRequest = file != null
          ? makeRequestWithFile(RequestMethod.postWithFile, ApiUrl.activities,
              data: data, fileList: _fileList, fileKey: "picture")
          : makeRequest(RequestMethod.post, ApiUrl.activities, data: data);
      var jsonString = await checkResponse(httpRequest);
      return jsonString[Keys.id];
    } catch (e) {
      debugPrint("CheckInOut Error: $e");
      rethrow;
    }
  }

  Future<List<CheckInHistoryModel>> history(Map<String, String> param) async {
    try {
      var httpRequest = makeRequest(
          RequestMethod.get, ApiUrl.attendanceHistories,
          queryParameters: param);
      var jsonString = await checkResponse(httpRequest);
      List<CheckInHistoryModel> _checkInHistorys = [];
      for (var item in jsonString as List) {
        _checkInHistorys.add(CheckInHistoryModel.fromJson(item));
      }
      return _checkInHistorys;
    } catch (e) {
      debugPrint("Histories Error: $e");
      rethrow;
    }
  }

  Future<List<LocationModel>> location(Map<String, String> param) async {
    try {
      var httpRequest = makeRequest(RequestMethod.get, ApiUrl.locations,
          queryParameters: param);
      var jsonString = await checkResponse(httpRequest);
      List<LocationModel> locationList = [];
      for (var item in jsonString as List) {
        locationList.add(LocationModel.fromJson(item));
      }
      return locationList;
    } catch (e) {
      debugPrint("Location Error: $e");
      rethrow;
    }
  }

  Future<bool> checkRadius(Map<String, Object> data) async {
    debugPrint("call api radius");
    try {
      var httpRequest =
          makeRequest(RequestMethod.post, ApiUrl.insideWorkPlace, data: data);
      var jsonString = await checkResponse(httpRequest);
      bool inside = false;
      inside = jsonString["inside"];
      return inside;
    } catch (e) {
      debugPrint("CheckRadius Error: $e");
      return false;
    }
  }

  Future<List<DropDownModel>> pinPointTypeDropDown(
      Map<String, String> param) async {
    try {
      var httpRequest = makeRequest(RequestMethod.get, ApiUrl.dropDown,
          queryParameters: param);
      var jsonString = await checkResponse(httpRequest);
      List<DropDownModel> _pinPointList = [];
      for (var item in jsonString['pin_point_type'] as List) {
        _pinPointList.add(DropDownModel.fromJson(item));
      }
      return _pinPointList;
    } catch (e) {
      debugPrint("Pin Piont DropDown Error: $e");
      return [];
    }
  }

  Future<PinPointModel> pinPoint(int id) async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.get, ApiUrl.pinPointType + "$id/");
      var jsonString = await checkResponse(httpRequest);
      PinPointModel pinPointModel = PinPointModel.fromJson(jsonString);
      return pinPointModel;
    } catch (e) {
      debugPrint("Pin Piont Detail Error: $e");
      rethrow;
    }
  }

  Future createpinPoint(Map<String, dynamic> data) async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.get, ApiUrl.pinPoints, data: data);
      await checkResponse(httpRequest);
    } catch (e) {
      debugPrint("Pin Piont Detail Error: $e");
      rethrow;
    }
  }
}
