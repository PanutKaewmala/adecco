import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/pages/check_in/check_in_map/check_in_map_ctrl.dart';
import 'package:ahead_adecco/src/pages/check_in/model/check_in_model.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import 'check_in_map_widget.dart';

class CheckInMapPage extends StatelessWidget {
  CheckInMapPage({Key? key}) : super(key: key);

  final CheckInData _checkInData = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final CheckInMapContoller contoller =
        Get.put(CheckInMapContoller(context, checkInData: _checkInData));
    final _height = 80.h;
    return KeyboardDismisser(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: appbarNoBackground(),
        body: Stack(
          children: [
            Obx(() => contoller.showMapDelay.value
                ? Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      child: SizedBox(
                          height: _height,
                          child: contoller.isPinPointOrTrackRoute()
                              ? MapViewAction(
                                  latLng: LatLng(
                                      _checkInData.posiotion.latitude,
                                      _checkInData.posiotion.longitude),
                                  onTap: (lanlng) {
                                    contoller.onTapMap(lanlng);
                                  },
                                )
                              : MapView(
                                  latLng: LatLng(
                                      _checkInData.posiotion.latitude,
                                      _checkInData.posiotion.longitude),
                                )),
                    ),
                  )
                : Center(child: LoadingCustom.loadingWidget())),
            Align(
              alignment: Alignment.bottomCenter,
              child: CheckInDetail(
                  addressName: _checkInData.addressNameModel,
                  contoller: contoller,
                  checkInPageType: _checkInData.checkInPageType),
            ),
          ],
        ),
      ),
    );
  }
}
