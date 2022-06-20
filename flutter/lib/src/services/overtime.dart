import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/services/export_services.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class OvertimeService extends HttpService {
  Future postOvertimeRequest(Map<String, Object> data) async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.post, ApiUrl.otRequest, data: data);
      await checkResponse(httpRequest);
    } catch (e) {
      debugPrint("Create OT Error: $e");
      rethrow;
    }
  }

  Future<List<DropDownModel>> getWorkPlace() async {
    try {
      Map<String, String> param = {
        Keys.project: UserConfig.getProjectID().toString(),
        "type": "workplace"
      };
      var httpRequest = makeRequest(RequestMethod.get, ApiUrl.dropDown,
          queryParameters: param);
      var jsonString = await checkResponse(httpRequest);
      List<DropDownModel> workPlaceList = [];
      for (var item in jsonString["workplace"] as List) {
        workPlaceList.add(DropDownModel.fromJson(item));
      }
      return workPlaceList;
    } catch (e) {
      debugPrint("Work Place OT Error: $e");
      rethrow;
    }
  }

  Future<DataPagination> getOvertime(
      {required String status, int? page}) async {
    try {
      Map<String, String> param = {
        Keys.project: UserConfig.getProjectID().toString(),
        "type": "user_request",
        "status": status
      };
      if (page != null) {
        param.addAll({"page": "$page"});
      }
      var httpRequest = makeRequest(RequestMethod.get, ApiUrl.otRequest,
          queryParameters: param);
      var jsonString = await checkResponse(httpRequest);
      DataListModel dataListModel = DataListModel.fromJson(jsonString);
      List<OverTimeModel> workPlaceList = [];
      for (var item in dataListModel.results) {
        workPlaceList.add(OverTimeModel.fromJson(item));
      }

      DataPagination _data = DataPagination(
          data: workPlaceList,
          hasMore: dataListModel.next == null ? false : true);
      return _data;
    } catch (e) {
      rethrow;
    }
  }

  Future<OverTimeQuotaModel> getOvertimeQuota() async {
    try {
      Map<String, String> param = {
        Keys.project: UserConfig.getProjectID().toString()
      };
      var httpRequest = makeRequest(RequestMethod.get, ApiUrl.otQuota,
          queryParameters: param);
      var jsonString = await checkResponse(httpRequest);
      OverTimeQuotaModel overTimeQuotaModel =
          OverTimeQuotaModel.fromJson(jsonString);
      return overTimeQuotaModel;
    } catch (e) {
      debugPrint("Quota OT Error: $e");
      rethrow;
    }
  }

  Future patchOvertime(Map<String, Object> data, int id) async {
    try {
      var httpRequest = makeRequest(
          RequestMethod.patch, ApiUrl.otRequest + "$id/",
          data: data);
      await checkResponse(httpRequest);
    } catch (e) {
      debugPrint("Edit OT Error: $e");
      rethrow;
    }
  }

  Future<OvertimeEditModel> getOvertimeEdit(int id) async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.get, ApiUrl.otRequest + "$id/");
      var jsonString = await checkResponse(httpRequest);
      OvertimeEditModel _overTimeEditMmodel =
          OvertimeEditModel.fromJson(jsonString);
      return _overTimeEditMmodel;
    } catch (e) {
      debugPrint("Edit OT Error: $e");
      rethrow;
    }
  }

  Future cancelOvertime(int id) async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.delete, ApiUrl.otRequest + "$id/");
      await checkResponse(httpRequest);
    } catch (e) {
      debugPrint("Cancel OT Error: $e");
      rethrow;
    }
  }
}
