import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/services/export_services.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class LeaveRequestService extends HttpService {
  Future<List<LeaveQuotaModel>> leaveQuotaDetail() async {
    try {
      var httpRequest = makeRequest(RequestMethod.get, ApiUrl.leaveQuota,
          queryParameters: {
            "project": UserConfig.employeeProjectModel!.project.id.toString()
          });
      var jsonString = await checkResponse(httpRequest);
      DataListModel dataListModel = DataListModel.fromJson(jsonString);
      List<LeaveQuotaModel> _leaveQuotaList = [];
      for (var item in dataListModel.results) {
        _leaveQuotaList.add(LeaveQuotaModel.fromJson(item));
      }
      return _leaveQuotaList;
    } catch (e) {
      debugPrint("Leave Quota Error: $e");
      rethrow;
    }
  }

  Future<List<LeaveTypeDetailModel>> leaveType() async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.get, ApiUrl.dropDown, queryParameters: {
        "type": Keys.leaveName,
        "project": UserConfig.employeeProjectModel!.project.id.toString()
      });
      var jsonString = await checkResponse(httpRequest);
      LeaveNameModel _leaveType = LeaveNameModel.fromJson(jsonString);
      List<LeaveTypeDetailModel> _leaveTypeList = [];
      for (var item in _leaveType.leave_name) {
        _leaveTypeList.add(item);
      }
      return _leaveTypeList;
    } catch (e) {
      debugPrint("Leave Type Error: $e");
      rethrow;
    }
  }

  Future<DataPagination> leaveRequest(
      {String? status, String? date, int? page}) async {
    try {
      Map<String, String> param = {
        "project": UserConfig.employeeProjectModel!.project.id.toString()
      };
      if (status != null) {
        param.addAll({"status": status});
      } else {
        param.addAll({"date": date!});
      }
      if (page != null) {
        param.addAll({"page": "$page"});
      }
      var httpRequest = makeRequest(RequestMethod.get, ApiUrl.leaveRequest,
          queryParameters: param);
      var jsonString = await checkResponse(httpRequest);
      DataListModel dataListModel = DataListModel.fromJson(jsonString);
      List<LeaveRequestModel> _leaveRequestList = [];
      for (var item in dataListModel.results) {
        _leaveRequestList.add(LeaveRequestModel.fromJson(item));
      }
      DataPagination _data = DataPagination(
          data: _leaveRequestList,
          hasMore: dataListModel.next == null ? false : true);
      return _data;
    } catch (e) {
      debugPrint("Leave Request Error: $e");
      rethrow;
    }
  }

  Future<LeaveRequestDetailModel> leaveRequestById(int id) async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.get, ApiUrl.leaveRequest + "$id/");
      var jsonString = await checkResponse(httpRequest);
      LeaveRequestDetailModel _leaveRequestDetailModel =
          LeaveRequestDetailModel.fromJson(jsonString);
      return _leaveRequestDetailModel;
    } catch (e) {
      debugPrint("Leave Request Detail Error: $e");
      rethrow;
    }
  }

  Future<int> createLeave(
      Map<String, dynamic> data, List<File> fileList) async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.post, ApiUrl.leaveRequest, data: data);
      var jsonString = await checkResponse(httpRequest);

      int id = jsonString['id'];
      return id;
    } catch (e) {
      debugPrint("Create Leave Error: $e");
      rethrow;
    }
  }

  Future patchLeave(
      Map<String, dynamic> data, List<File> fileList, int id) async {
    try {
      var httpRequest = makeRequest(
          RequestMethod.patch, ApiUrl.leaveRequest + "$id/",
          data: data);
      await checkResponse(httpRequest);
    } catch (e) {
      debugPrint("Patch Leave Error: $e");
      rethrow;
    }
  }

  Future cancelLeaveRequest(int id) async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.delete, ApiUrl.leaveRequest + "$id/");
      await checkResponse(httpRequest);
    } catch (e) {
      debugPrint("Cancel Leave Error: $e");
      rethrow;
    }
  }

  Future fileUploadAttachment(
      Map<String, String> data, List<File> fileList) async {
    try {
      var httpRequest = makeRequestWithFile(
          RequestMethod.postWithFile, ApiUrl.uploadAttachment + ApiUrl.bulk,
          data: data, fileKey: Keys.file, fileList: fileList);
      await checkResponse(httpRequest);
    } catch (e) {
      debugPrint("Upload Attachment Error: $e");
      rethrow;
    }
  }

  Future<List<UploadAttachmentModel>> refreshFileUploadAttachment(
      int id) async {
    try {
      var httpRequest = makeRequest(RequestMethod.get, ApiUrl.uploadAttachment,
          queryParameters: {Keys.leaveRequestId: "$id"});
      var jsonString = await checkResponse(httpRequest);
      DataListModel dataListModel = DataListModel.fromJson(jsonString);
      List<UploadAttachmentModel> _uploadAttachment = [];
      for (var item in dataListModel.results) {
        _uploadAttachment.add(UploadAttachmentModel.fromJson(item));
      }
      return _uploadAttachment;
    } catch (e) {
      debugPrint("Refresh Upload Attachment Error: $e");
      rethrow;
    }
  }

  Future deleteUploadAttachment(int id) async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.delete, ApiUrl.uploadAttachment + "$id/");
      await checkResponse(httpRequest);
    } catch (e) {
      debugPrint("Delete Upload Attachment Error: $e");
      rethrow;
    }
  }
}
