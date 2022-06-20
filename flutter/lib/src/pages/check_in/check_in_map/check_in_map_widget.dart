import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/pages/check_in/check_in_map/check_in_map_ctrl.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class CheckInDetail extends StatelessWidget {
  const CheckInDetail(
      {Key? key,
      required this.addressName,
      required this.contoller,
      required this.checkInPageType})
      : super(key: key);

  final AddressNameModel? addressName;
  final CheckInMapContoller contoller;
  final CheckInPageType checkInPageType;

  @override
  Widget build(BuildContext context) {
    final CheckInMapContoller controller = Get.find();
    final bool isCheckInOutType = checkInPageType == CheckInPageType.checkIn ||
        checkInPageType == CheckInPageType.checkOut;
    return Obx(
      () => Container(
        height: isCheckInOutType ? 300 : 360,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 15,
                      width: 4,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [AppTheme.mainRed, AppTheme.peach])),
                    ),
                    horizontalSpace(5),
                    text(Texts.location,
                        fontSize: AppFontSize.mediumL,
                        fontWeight: FontWeight.bold),
                  ],
                ),
                isCheckInOutType
                    ? contoller.isInRadius.value != null
                        ? text(
                            contoller.isInRadius.value!
                                ? Texts.inRadius
                                : Texts.outRadius,
                            fontSize: AppFontSize.mediumM,
                            color: contoller.isInRadius.value!
                                ? AppTheme.green
                                : AppTheme.red)
                        : LoadingCustom.loadingWidget(size: 20)
                    : text(
                        DateTimeService.dateTimeToStringHHMM(
                            contoller.checkInTime.value),
                        fontSize: AppFontSize.mediumM,
                        color: AppTheme.greyText)
              ],
            ),
            verticalSpace(15),
            isCheckInOutType
                ? SizedBox(
                    height: 75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(addressName!.name,
                            fontSize: AppFontSize.mediumM,
                            fontWeight: FontWeight.bold),
                        verticalSpace(5),
                        textAutoSizeII(addressName!.address,
                            fontSize: AppFontSize.mediumM,
                            color: AppTheme.greyText,
                            maxline: 2),
                      ],
                    ),
                  )
                : _buildPinPointAddress(controller.workPlaceName),
            const Spacer(),
            isCheckInOutType
                ? Column(
                    children: [
                      SizedBox(
                        height: 90,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  text(Texts.checkIn,
                                      fontSize: AppFontSize.mediumM,
                                      color: AppTheme.greyText,
                                      fontWeight: FontWeight.bold),
                                  verticalSpace(5),
                                  GestureDetector(
                                    onTap: () {
                                      if (contoller.isCheckIn.value) {
                                        TimePickerCustom.openTimePicker(
                                          context,
                                          contoller.checkOutTime.value,
                                          onChangeDateTime: (time) {
                                            contoller.adjustingTime(time);
                                          },
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 90,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: AppTheme.grey,
                                          border: Border.all(
                                              color: AppTheme.greyBorder,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: text(
                                          DateTimeService.getStringTimeNow(
                                              contoller.checkInTime.value),
                                          fontSize: AppFontSize.largeM,
                                          color: AppTheme.blueText),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                height: 40,
                                width: 1,
                                color: AppTheme.greyBorder),
                            Expanded(
                              child: Column(
                                children: [
                                  text(Texts.checkOut,
                                      fontSize: AppFontSize.mediumM,
                                      color: AppTheme.greyText,
                                      fontWeight: FontWeight.bold),
                                  verticalSpace(5),
                                  GestureDetector(
                                    onTap: () {
                                      if (!contoller.isCheckIn.value) {
                                        TimePickerCustom.openTimePicker(
                                          context,
                                          contoller.checkOutTime.value,
                                          onChangeDateTime: (time) {
                                            contoller.adjustingTime(time);
                                          },
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 90,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: AppTheme.grey,
                                          border: Border.all(
                                              color: AppTheme.greyBorder,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: text(
                                          contoller.isCheckIn.value
                                              ? "-- : --"
                                              : DateTimeService
                                                  .getStringTimeNow(contoller
                                                      .checkOutTime.value),
                                          fontSize: AppFontSize.largeM,
                                          color: AppTheme.redText),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      roundButton(
                          checkInPageType == CheckInPageType.checkIn
                              ? Texts.checkInNow
                              : Texts.checkOutNow, onPressed: () {
                        contoller.onClickCheckIn();
                      }, fontSize: AppFontSize.mediumM)
                    ],
                  )
                : Column(
                    children: [
                      roundButton(Texts.createPinPoint, onPressed: () {
                        controller.onClickCreatePinPoint();
                      },
                          fontSize: AppFontSize.mediumM,
                          buttonColor: AppTheme.white,
                          textColor: AppTheme.mainRed,
                          side: true),
                      verticalSpace(10),
                      roundButton(Texts.createTrackRoute, onPressed: () {
                        contoller.onClickCreateTrackRoute();
                      }, fontSize: AppFontSize.mediumM),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinPointAddress(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textFieldWithlabel(
          Texts.name,
          controller,
          textWidget: text(Texts.name, fontWeight: FontWeight.bold),
        ),
        verticalSpace(10),
        text(Texts.address,
            fontSize: AppFontSize.mediumM, fontWeight: FontWeight.bold),
        verticalSpace(5),
        textAutoSizeII(contoller.locationAddress.value,
            fontSize: AppFontSize.mediumM,
            color: AppTheme.greyText,
            maxline: 2),
      ],
    );
  }
}
