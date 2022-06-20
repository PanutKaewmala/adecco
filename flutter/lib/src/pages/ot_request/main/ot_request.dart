import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/pages/ot_request/main/ot_request_ctrl.dart';
import 'package:ahead_adecco/src/pages/ot_request/main/ot_request_widget.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class OTRequestPage extends StatelessWidget {
  const OTRequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OTRequestController controller =
        Get.put(OTRequestController(context: context));
    final size =
        DeviceTypeSize.getSizeType(sizeMobile: 100.w, sizeTablet: 80.w);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppTheme.background,
      appBar: appbarBackgroundWithAction(Texts.overtime,
          background: false,
          action: appBarButton(Texts.request, onPressed: () {
            controller.onClickAddRequest();
          })),
      body: Obx(
        () => Column(
          children: [
            SizedBox(
              height: 340,
              child: Stack(
                children: [
                  Container(
                    color: AppTheme.mainRed,
                    height: 340,
                    width: double.maxFinite,
                    child: Image.asset(
                      Assets.leave,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 200,
                      width: size,
                      child: Stack(
                        children: [
                          Positioned(
                              top: 0,
                              child: Container(
                                  width: size,
                                  alignment: Alignment.center,
                                  child: CircularPercentIndicator(
                                    radius: 40.0,
                                    lineWidth: 8.0,
                                    percent: controller.getPrecent(),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    center: text(controller.getRemained(),
                                        fontSize: AppFontSize.largeS,
                                        color: AppTheme.white),
                                    progressColor: AppTheme.greyBorder,
                                    backgroundColor: AppTheme.purple,
                                  ))),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 3.h),
                              child: Container(
                                height: 75,
                                width: 50.w,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppTheme.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildDetailQuota(
                                        Texts.quota,
                                        controller
                                            .overTimeQuotaModel.value?.ot_quota,
                                        flex: 1),
                                    dividerVertical(40),
                                    buildDetailQuota(
                                        Texts.used,
                                        controller.overTimeQuotaModel.value
                                            ?.ot_quota_used,
                                        color: AppTheme.greyBorder,
                                        flex: 1),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 2.h,
                            bottom: 5,
                            child: Image.asset(
                              Assets.girlOT,
                              height: 160,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        buildTapbar(Texts.upcoming, controller.tabList[0].value,
                            onPressed: () {
                          controller.onPressedTab(TabbarType.upcoming);
                        }),
                        dividerVertical(25, left: 10, right: 10),
                        buildTapbar(Texts.pending, controller.tabList[1].value,
                            onPressed: () {
                          controller.onPressedTab(TabbarType.pending);
                        }),
                        dividerVertical(25, left: 10, right: 10),
                        buildTapbar(
                          Texts.history,
                          controller.tabList[2].value,
                          onPressed: () {
                            controller.onPressedTab(TabbarType.history);
                          },
                        )
                      ],
                    ),
                    controller.obx(
                      (state) => buildOvertimeList(controller, state!),
                      onLoading: Expanded(
                          child: Center(child: LoadingCustom.loadingWidget())),
                      onEmpty:
                          Expanded(child: Center(child: textNotFoundAndIcon())),
                      onError: (error) =>
                          Expanded(child: Center(child: textErrorAndIcon())),
                    ),
                    if (controller.isLoading.value == true &&
                        controller.page != 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Center(
                          child: LoadingCustom.loadingWidget(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
