import 'dart:convert';

import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future setTokenAuth(TokenAuthModel tokenAuthModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Keys.tokenAuth, jsonEncode(tokenAuthModel).encrypting());
  }

  static Future<TokenAuthModel?> getTokenAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(Keys.tokenAuth);
    if (jsonString != null) {
      String jsonEncrytp = jsonString.decrypting();
      TokenAuthModel tokenAuthModel =
          TokenAuthModel.fromJson(jsonDecode(jsonEncrytp));
      UserConfig.session = tokenAuthModel;
      return tokenAuthModel;
    } else {
      return null;
    }
  }

  static Future removeAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future setUpDefualtData() async {
    await Future.wait([
      getTokenAuth(),
      getIsCreatePassword(),
      getPincodeStatus(),
      getProject()
    ]);
  }

  static Future setPincodeStatus(bool isSetPin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Keys.pincode, isSetPin);
    UserConfig.hasPincode = isSetPin;
  }

  static Future getPincodeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserConfig.hasPincode = prefs.getBool(Keys.pincode) ?? false;
  }

  static Future setIsCreatePassword(bool isFirstTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserConfig.isCreatePassword = isFirstTime;
    prefs.setBool(Keys.firstTimePassword, isFirstTime);
  }

  static Future<bool> getIsCreatePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _isCreatePassword = prefs.getBool(Keys.firstTimePassword) ?? false;
    UserConfig.isCreatePassword = _isCreatePassword;
    return _isCreatePassword;
  }

  static Future setEncryptedPassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Keys.encryptedPassword, password.encrypting());
  }

  static Future<String?> getEncryptedPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? password = prefs.getString(Keys.encryptedPassword);
    if (password != null) {
      return password.decrypting();
    } else {
      return "";
    }
  }

  static Future setProject(EmployeeProjectModel employeeProjectModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Keys.project, jsonEncode(employeeProjectModel));
    UserConfig.employeeProjectModel = employeeProjectModel;
  }

  static Future getProject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString(Keys.project);
    if (json != null) {
      EmployeeProjectModel employeeProjectModel =
          EmployeeProjectModel.fromJson(jsonDecode(json));
      UserConfig.employeeProjectModel = employeeProjectModel;
    }
  }

  static Future setProjectList(
      List<EmployeeProjectModel> employeeProjectModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jsonList = employeeProjectModel.map((e) => e.toJson()).toList();
    prefs.setString(Keys.projectList, jsonEncode(jsonList));
  }

  static Future getProjectList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonList = prefs.getString(Keys.projectList);

    if (jsonList != null) {
      List<EmployeeProjectModel> employeeProjectModel = [];
      for (var item in jsonDecode(jsonList) as List) {
        employeeProjectModel.add(EmployeeProjectModel.fromJson(item));
      }
      return employeeProjectModel;
    } else {
      return [];
    }
  }
}
