import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/pages/home/home_ctrl.dart';
import 'package:ahead_adecco/src/pages/home/home_widget.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          Obx(
            () => HomeInfo(
              percent: 98,
              projectName: controller.selectedProject.value?.project.name,
            ),
          ),
          HomeMenuGrid(
            onMenuTap: (menu) {
              debugPrint("menu $menu");
              controller.navigatorMenu(menu);
            },
          ),
        ],
      ),
    );
  }
}
