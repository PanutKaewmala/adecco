import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/auth/EmployeeProjectModel.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class HomeController extends GetxController {
  List<EmployeeProjectModel> employeeProjectList = [];
  final selectedProject = Rx<EmployeeProjectModel?>(null);

  @override
  void onInit() {
    selectedProject.value = UserConfig.employeeProjectModel;
    getEmployeeProjectList();
    super.onInit();
  }

  Future getEmployeeProjectList() async {
    var _employeeProjectList = await SharedPreferencesService.getProjectList();
    employeeProjectList.assignAll(_employeeProjectList);
  }

  Future getLocation() async {
    try {
      await LocationService().checkLocationEnable();
      Get.toNamed(Routes.checkIn);
    } catch (e) {
      return;
    }
  }

  void navigatorMenu(HomeMenu menu) {
    switch (menu) {
      case HomeMenu.timeAndLocation:
        getLocation();
        break;
      case HomeMenu.calendar:
        Get.toNamed(Routes.calendar);
        break;
      case HomeMenu.leave:
        Get.toNamed(Routes.leaveRequest);
        break;
      case HomeMenu.roster:
        Get.toNamed(Routes.rosterPlan);
        break;
      case HomeMenu.overTime:
        Get.toNamed(Routes.otRequest);
        break;
      case HomeMenu.merchandising:
        Get.toNamed(Routes.selectShop);
        break;
      default:
    }
  }

  void onClickSelectProject(BuildContext context) async {
    showCupertinoProjectPicker(context,
        employeeProjectList: employeeProjectList,
        selected: selectedProject.value, onPressed: (value) async {
      selectedProject.value = value;
      UserConfig.employeeProjectModel = value;
      await SharedPreferencesService.setProject(selectedProject.value!);
    });
  }
}
