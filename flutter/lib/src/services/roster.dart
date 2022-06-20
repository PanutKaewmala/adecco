import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/models/roster/AdjustRequestModel.dart';

import 'package:ahead_adecco/src/widgets/export_widget.dart';

import 'http.dart';

class RosterPlanService extends HttpService {
  Future<List<PlaceRosterModel>> workPlaces() async {
    try {
      var httpRequest = makeRequest(
          RequestMethod.get,
          ApiUrl.project +
              "${UserConfig.getProjectID()}" +
              "/" +
              ApiUrl.workplaces);
      var jsonString = await checkResponse(httpRequest);
      List<PlaceRosterModel> _placeList = [];
      for (var item in jsonString as List) {
        _placeList.add(PlaceRosterModel.fromJson(item));
      }
      return _placeList;
    } catch (e) {
      debugPrint("WorkPlace Error: $e");
      rethrow;
    }
  }

  Future<List<WorkingHoursModel>> workHours() async {
    try {
      var httpRequest = makeRequest(
          RequestMethod.get,
          ApiUrl.project +
              "${UserConfig.getProjectID()}" +
              "/" +
              ApiUrl.workingHours);
      var jsonString = await checkResponse(httpRequest);
      List<WorkingHoursModel> _workTimeList = [];
      for (var item in jsonString as List) {
        _workTimeList.add(WorkingHoursModel.fromJson(item));
      }
      return _workTimeList;
    } catch (e) {
      debugPrint("WorkHours Error: $e");
      rethrow;
    }
  }

  Future createRoster(Map<String, dynamic> data) async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.post, ApiUrl.rosters, data: data);
      await checkResponse(httpRequest);
    } catch (e) {
      debugPrint("Create Roster Error: $e");
      rethrow;
    }
  }

  Future createDayOff(Map<String, dynamic> data) async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.post, ApiUrl.rosterDayOff, data: data);
      await checkResponse(httpRequest);
    } catch (e) {
      debugPrint("Create DayOff Error: $e");
      rethrow;
    }
  }

  Future editRoster(Map<String, dynamic> data, int rosterID) async {
    try {
      var httpRequest = makeRequest(
          RequestMethod.patch, ApiUrl.rosters + "$rosterID/",
          data: data);
      await checkResponse(httpRequest);
    } catch (e) {
      debugPrint("Edit Roster Error: $e");
      rethrow;
    }
  }

  Future editDayOff(Map<String, dynamic> data) async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.patch, ApiUrl.rosterDayOff, data: data);
      await checkResponse(httpRequest);
    } catch (e) {
      debugPrint("Edit DayOff Error: $e");
      rethrow;
    }
  }

  Future<RosterDetailModel> previewRoster(Map<String, dynamic> data) async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.post, ApiUrl.rosterPreview, data: data);
      var jsonString = await checkResponse(httpRequest);
      RosterDetailModel _rosterDetailModel =
          RosterDetailModel.fromJson(jsonString);
      return _rosterDetailModel;
    } catch (e) {
      debugPrint("Preview Roster Error: $e");
      rethrow;
    }
  }

  Future<List<RosterModel>> getRoster(Map<String, dynamic> param) async {
    try {
      var httpRequest = makeRequest(RequestMethod.get, ApiUrl.rosters,
          queryParameters: param);
      var jsonString = await checkResponse(httpRequest);
      DataListModel dataListModel = DataListModel.fromJson(jsonString);
      List<RosterModel> _rosterList = [];
      for (var item in dataListModel.results) {
        _rosterList.add(RosterModel.fromJson(item));
      }
      return _rosterList;
    } catch (e) {
      debugPrint("Roster Error: $e");
      rethrow;
    }
  }

  Future<RosterCalendarModel> getRosterCalendar(
      Map<String, dynamic> param) async {
    try {
      var httpRequest = makeRequest(RequestMethod.get, ApiUrl.rosterCalendars,
          queryParameters: param);
      var jsonString = await checkResponse(httpRequest);
      RosterCalendarModel _rosterCalendarModel =
          RosterCalendarModel.fromJson(jsonString);

      return _rosterCalendarModel;
    } catch (e) {
      debugPrint("Roster Error: $e");
      rethrow;
    }
  }

  Future<RosterDetailModel> getRosterShiftDetailByID(int id) async {
    try {
      var httpRequest = makeRequest(
          RequestMethod.get, ApiUrl.rosters + "$id/" + ApiUrl.details);
      var jsonString = await checkResponse(httpRequest);
      RosterDetailModel _rosterDetailModel =
          RosterDetailModel.fromJson(jsonString);
      return _rosterDetailModel;
    } catch (e) {
      debugPrint("Shift Detail Error: $e");
      rethrow;
    }
  }

  Future<RosterEditModel> getRosterDetailByID(int id) async {
    try {
      var httpRequest = makeRequest(RequestMethod.get, ApiUrl.rosters + "$id/");
      var jsonString = await checkResponse(httpRequest);
      RosterEditModel _rosterEditModel = RosterEditModel.fromJson(jsonString);
      return _rosterEditModel;
    } catch (e) {
      debugPrint("Roster Detail Error: $e");
      rethrow;
    }
  }

  Future<RosterDayOffEditModel> getRosterDayOffDetail(int id) async {
    try {
      var httpRequest = makeRequest(
          RequestMethod.get, ApiUrl.rosters + "$id/" + ApiUrl.dayOffRetrieve);
      var jsonString = await checkResponse(httpRequest);
      RosterDayOffEditModel _rosterDayOffEditModel =
          RosterDayOffEditModel.fromJson(jsonString);
      return _rosterDayOffEditModel;
    } catch (e) {
      debugPrint("roster dayoff Detail Error: $e");
      rethrow;
    }
  }

  Future<ShiftDetailEditModel> getRosterEditShiftDetailByID(int id) async {
    try {
      var httpRequest = makeRequest(RequestMethod.get, ApiUrl.shifts + "$id/");
      var jsonString = await checkResponse(httpRequest);
      ShiftDetailEditModel _shiftDetailEditModel =
          ShiftDetailEditModel.fromJson(jsonString);
      return _shiftDetailEditModel;
    } catch (e) {
      debugPrint("Shift Detail Error: $e");
      rethrow;
    }
  }

  Future postRosterEditShiftDetail(int id, Object data) async {
    try {
      var httpRequest = makeRequest(
          RequestMethod.post, ApiUrl.rosters + "$id/" + ApiUrl.editShift,
          data: data);
      await checkResponse(httpRequest);
    } catch (e) {
      debugPrint("Shift Detail Error: $e");
      rethrow;
    }
  }

  Future<List<AdjustRequestModel>> getRosterAdjustRequest(
      Map<String, dynamic> param) async {
    try {
      var httpRequest = makeRequest(RequestMethod.get, ApiUrl.adjustRequest,
          queryParameters: param);
      var jsonString = await checkResponse(httpRequest);
      DataListModel dataListModel = DataListModel.fromJson(jsonString);
      List<AdjustRequestModel> adjustRequestModel = [];
      for (var item in dataListModel.results) {
        adjustRequestModel.add(AdjustRequestModel.fromJson(item));
      }
      return adjustRequestModel;
    } catch (e) {
      debugPrint("Adjust Request Error: $e");
      rethrow;
    }
  }

  Future cancelRoster(int id) async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.delete, ApiUrl.rosters + "$id/");
      await checkResponse(httpRequest);
    } catch (e) {
      debugPrint("Cancel roster Error: $e");
      rethrow;
    }
  }
}
