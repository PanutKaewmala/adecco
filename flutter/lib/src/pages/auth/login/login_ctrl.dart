import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/pages/auth/login/logint_text_ctrl.dart';
import 'package:ahead_adecco/src/services/auth.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class LoginController extends GetxController {
  final LoginTextController loginTextController = LoginTextController();
  final obscureText = true.obs;
  bool? validation;
  late AuthenticationService authenticationService;
  List<EmployeeProjectModel> employeeProjectList = [];
  EmployeeProjectModel? selectedEmployee;
  TokenAuthModel? tokenAuthModel;

  @override
  void onInit() {
    authenticationService = AuthenticationService();
    super.onInit();
  }

  @override
  void onClose() {
    loginTextController.dispose();
    authenticationService.close();
    super.onClose();
  }

  Future callAllAPI(BuildContext context) async {
    try {
      LoadingCustom.showOverlay(context);
      await callAPITokenAuth();
      await callAPIEmplyeeProject(context);
    } catch (e) {
      LoadingCustom.hideOverlay(context);
      DialogCustom.showBasicAlert("$e");
    }
  }

  void onClickLogin(BuildContext context) async {
    Get.focusScope!.unfocus();
    validation = loginTextController.isDataValid();
    if ((validation ?? false)) {
      callAllAPI(context);
    }
  }

  void showPassword() {
    obscureText.value = !obscureText.value;
  }

  void onClickResetPassword() {
    UserConfig.pageForgotPassword = Routes.login;
    Get.toNamed(Routes.forgotPassword);
  }

  Future callAPITokenAuth() async {
    var data = {
      "username": loginTextController.username.text.trim().toLowerCase(),
      "password": loginTextController.password.text.trim(),
    };
    try {
      await authenticationService.tokenAuth(data).then((value) async {
        tokenAuthModel = value;
        UserConfig.session = tokenAuthModel;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future callAPIEmplyeeProject(BuildContext context) async {
    try {
      var _employeeList = await authenticationService.getEmployeeProject();
      LoadingCustom.hideOverlay(context);
      if (_employeeList.isNotEmpty) {
        employeeProjectList.assignAll(_employeeList);
        showCupertinoProjectPicker(context,
            employeeProjectList: employeeProjectList,
            onPressed: (selected) async {
          selectedEmployee = selected;
          await saveLoginData();
        });
      } else {
        DialogCustom.showBasicAlert(Texts.noProject);
      }
    } catch (e) {
      rethrow;
    }
  }

  void goToPage() {
    if (!UserConfig.isCreatePassword) {
      Get.toNamed(Routes.createPassword);
    } else if (!UserConfig.hasPincode) {
      Get.toNamed(Routes.pincode);
    } else {
      Get.offAllNamed(Routes.home);
    }
  }

  Future saveLoginData() async {
    await SharedPreferencesService.setTokenAuth(tokenAuthModel!);
    await SharedPreferencesService.setIsCreatePassword(
        tokenAuthModel!.user.default_password_changed);
    await SharedPreferencesService.setProject(selectedEmployee!);
    await SharedPreferencesService.setProjectList(employeeProjectList);
    goToPage();
  }
}
