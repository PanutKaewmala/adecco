import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  String buildHomePage() {
    if (UserConfig.session == null) {
      return Routes.login;
    } else {
      if (!UserConfig.isCreatePassword) {
        return Routes.createPassword;
      } else {
        return Routes.pincode;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      DeviceTypeSize.getDeviceType();
      return GlobalLoaderOverlay(
        overlayColor: AppTheme.black,
        overlayOpacity: 0.2,
        useDefaultLoading: false,
        overlayWidget: Center(child: LoadingCustom.loadingOverlayWidget()),
        child: GetMaterialApp(
          scrollBehavior: CustomScrollBehavior.overscroll(),
          title: 'Ahead',
          theme: ThemeData(
              fontFamily: houschkaHead,
              primarySwatch: Colors.grey,
              unselectedWidgetColor: AppTheme.greyBorder),
          initialRoute: buildHomePage(),
          getPages: Routes.getAll(),
        ),
      );
    });
  }
}

class Init {
  Init._();
  static final instance = Init._();
  Future initialize() async {
    await SharedPreferencesService.setUpDefualtData();
    debugPrint(
        "data: ${UserConfig.session} ${UserConfig.isCreatePassword} ${UserConfig.hasPincode}");
  }
}
