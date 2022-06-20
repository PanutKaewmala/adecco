import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'http.dart';

class AuthenticationService extends HttpService {
  Future<TokenAuthModel> tokenAuth(Object data) async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.post, ApiUrl.tokenAuth, data: data);
      var jsonString = await checkResponse(httpRequest);
      return TokenAuthModel.fromJson(jsonString);
    } catch (e) {
      debugPrint("Auth Error: $e");
      rethrow;
    }
  }

  Future createPassword(Object data) async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.post, ApiUrl.createPassword, data: data);
      await checkResponse(httpRequest);
    } catch (e) {
      debugPrint("Password Error: $e");
      rethrow;
    }
  }

  Future createPincode(Object data) async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.post, ApiUrl.createPincode, data: data);
      var jsonString = await checkResponse(httpRequest);
      return DetailModel.fromJson(jsonString);
    } catch (e) {
      debugPrint("Pincode Error: $e");
      rethrow;
    }
  }

  Future forgotPassword(Object data) async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.post, ApiUrl.createPincode, data: data);
      var jsonString = await checkResponse(httpRequest);
      return DetailModel.fromJson(jsonString);
    } catch (e) {
      debugPrint("Pincode Error: $e");
      rethrow;
    }
  }

  Future<List<EmployeeProjectModel>> getEmployeeProject() async {
    try {
      var httpRequest = makeRequest(RequestMethod.get, ApiUrl.employeeProject);
      var jsonString = await checkResponse(httpRequest);
      List<EmployeeProjectModel> _employeeProjectList = [];
      for (var item in jsonString as List) {
        _employeeProjectList.add(EmployeeProjectModel.fromJson(item));
      }
      return _employeeProjectList;
    } catch (e) {
      debugPrint("Employee Project Error: $e");
      rethrow;
    }
  }
}
