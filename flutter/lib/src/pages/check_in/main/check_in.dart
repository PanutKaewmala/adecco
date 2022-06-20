import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import 'check_in_ctrl.dart';
import 'check_in_widget.dart';

class CheckInPage extends GetView<CheckInController> {
  CheckInPage({Key? key}) : super(key: key);
  final String userName = UserConfig.getFullName();
  @override
  Widget build(BuildContext context) {
    final CheckInController controller = Get.put(CheckInController(context));
    return Scaffold(
        appBar: appbarBackground(userName,
            subTitle: DateTimeService.greeting() + ",",
            action: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.history);
                },
                child: SvgPicture.asset(Assets.history))),
        body: Obx(() {
          return Column(
            children: [
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(20)),
                  boxShadow: [
                    BoxShadowStyles.addShadow,
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child:
                          text(Texts.location, fontSize: AppFontSize.mediumM),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: textPickerWithContainer(
                        controller.selectedLocation.value?.workplace.name,
                        onTap: () {
                          controller.onClickSelectLocation();
                        },
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      ),
                    ),
                    dividerHorizontal(top: 15, bottom: 15),
                    SizedBox(
                      height: 90,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildCheckInTime(true,
                              time: controller
                                  .selectedLocation.value?.activity.check_in,
                              date: controller.selectedLocation.value?.activity
                                          .check_in !=
                                      null
                                  ? DateTimeService.getStringTimeNowFormat(
                                      format: DateTimeFormatCustom.mmmmddyyyy)
                                  : null),
                          dividerVertical(40),
                          buildCheckInTime(false,
                              time: controller
                                  .selectedLocation.value?.activity.check_out,
                              date: controller.selectedLocation.value?.activity
                                          .check_out !=
                                      null
                                  ? DateTimeService.getStringTimeNowFormat(
                                      format: DateTimeFormatCustom.mmmmddyyyy)
                                  : null),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: roundButton(
                          controller.isCheckIn ? Texts.checkIn : Texts.checkOut,
                          onPressed: () {
                        if (!controller.disableCheckin.value) {
                          controller.onClickCheckIn(false);
                        }
                      },
                          fontSize: AppFontSize.mediumM,
                          buttonColor: controller.disableCheckin.value
                              ? AppTheme.greyText
                              : AppTheme.mainRed),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: Row(
                  children: [
                    buildTapbar(Texts.workPlace, controller.tabList[0].value,
                        onPressed: () {
                      // controller.onPressedTab(TabbarType.upcoming);
                    }),
                    dividerVertical(25, left: 10, right: 10),
                    buildTapbar(Texts.shop, controller.tabList[1].value,
                        onPressed: () {
                      // controller.onPressedTab(TabbarType.pending);
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text("${controller.workPlaceSize.value} Workplace",
                        fontSize: AppFontSize.mediumM),
                    GestureDetector(
                      onTap: () {
                        controller.onClickCheckIn(true);
                      },
                      child: text(Texts.addNewRoute,
                          fontSize: AppFontSize.mediumM,
                          color: AppTheme.mainRed),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: controller.obx(
                    (state) => buildLisToDay(state!, controller.listViewCtrl),
                    onLoading: Center(child: LoadingCustom.loadingWidget()),
                    onEmpty: Center(child: textNotFoundAndIcon()),
                    onError: (error) => Center(child: textErrorAndIcon()),
                  ),
                ),
              ),
            ],
          );
        }));
  }
}
