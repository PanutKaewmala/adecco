import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/pages/home/home_ctrl.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomeInfo extends StatelessWidget {
  final double percent;
  final String? projectName;
  const HomeInfo({Key? key, required this.percent, required this.projectName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size =
        DeviceTypeSize.getSizeType(sizeMobile: 100.w, sizeTablet: 80.w);
    final HomeController controller = Get.find();
    return SizedBox(
      height: 340,
      child: Stack(
        children: [
          Container(
            color: AppTheme.mainRed,
            height: 340,
            width: double.maxFinite,
            child: Image.asset(
              Assets.home,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 80,
            child: Container(
              width: 100.w,
              alignment: Alignment.center,
              child: SizedBox(
                height: 160,
                width: 160,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        Assets.ellipse,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: CustomPaint(
                        painter: DrawCircle(paintSize: 70),
                      ),
                    ),
                    SfRadialGauge(axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 0,
                        maximum: 100,
                        showLabels: false,
                        showTicks: false,
                        startAngle: 270,
                        endAngle: 270,
                        showAxisLine: false,
                        pointers: <GaugePointer>[
                          MarkerPointer(
                            value: percent,
                            markerType: MarkerType.circle,
                            color: AppTheme.white,
                            borderColor: AppTheme.mainRed,
                            borderWidth: 2,
                          )
                        ],
                      ),
                    ]),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text("${percent.toStringAsFixed(0)}%",
                              fontSize: AppFontSize.largeL,
                              color: AppTheme.white),
                          text(Texts.attendance,
                              fontSize: AppFontSize.small,
                              color: AppTheme.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              top: 50,
              child: Container(
                width: 100.w,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.setting);
                      },
                      child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: AppTheme.yellow,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          alignment: Alignment.center,
                          child: text(
                              UserConfig.session!.user.first_name
                                  .substring(0, 1),
                              fontSize: AppFontSize.mediumM,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.white)),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.onClickSelectProject(context);
                      },
                      child: Container(
                        height: 30,
                        width: 70.w,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text(projectName ?? "",
                                fontSize: AppFontSize.mediumM),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppTheme.black,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: SvgPicture.asset(
                          Assets.bellNoti,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: size,
              height: 200,
              child: Stack(
                children: [
                  Positioned(
                    left: 2.w,
                    bottom: 5,
                    child: Image.asset(
                      Assets.girlHome,
                      height: 170,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Container(
                        height: 75,
                        width: 60.w,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildDetailQuota(Texts.attend, 30,
                                icon: Assets.emoji, flex: 2),
                            dividerVertical(40, left: 5, right: 5),
                            _buildDetailQuota(Texts.late, 2,
                                icon: Assets.emojiSad, flex: 2),
                            dividerVertical(40, left: 5, right: 5),
                            _buildDetailQuota(Texts.leave, 2,
                                icon: Assets.emojiSatisfied, flex: 2),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 2.w,
                    bottom: 5,
                    child: Image.asset(
                      Assets.boyHome,
                      height: 107,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailQuota(String title, int number,
      {required String icon, required int flex}) {
    return Flexible(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(icon),
              horizontalSpace(5),
              text(title,
                  fontSize: AppFontSize.mediumS, color: AppTheme.greyText)
            ],
          ),
          verticalSpace(5),
          text("$number", fontSize: AppFontSize.mediumL, color: AppTheme.black)
        ],
      ),
    );
  }
}

class HomeMenuGrid extends StatelessWidget {
  final void Function(HomeMenu menu) onMenuTap;
  HomeMenuGrid({Key? key, required this.onMenuTap}) : super(key: key);

  final List<HomeMenu> _menuList = [
    HomeMenu.timeAndLocation,
    HomeMenu.calendar,
    HomeMenu.roster,
    HomeMenu.merchandising,
    HomeMenu.sales,
    HomeMenu.event,
    HomeMenu.leave,
    HomeMenu.overTime,
    HomeMenu.survey
  ];

  final _controller = ScrollController();

  Widget _buildMenuName(HomeMenu menu) {
    var _name = menu.title;
    var _svg = menu.code;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/images/icons/$_svg.svg",
          height: 30,
          width: 30,
          fit: BoxFit.scaleDown,
        ),
        verticalSpace(5),
        Container(
            height: 40,
            alignment: Alignment.center,
            child: text(_name,
                fontSize: DeviceTypeSize.isTablet()
                    ? AppFontSize.mediumS
                    : AppFontSize.small,
                textAlign: TextAlign.center,
                maxline: 2))
      ],
    );
  }

  Widget _buildButton(HomeMenu menu) {
    return roundElevatedButton(
        onPressed: () {
          onMenuTap(menu);
        },
        child: _buildMenuName(menu));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        controller: _controller,
        itemCount: _menuList.length,
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: UserConfig.deviceType == DeviceType.tablet ? 4 : 3),
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.all(10),
          child: _buildButton(_menuList[index]),
        ),
      ),
    );
  }
}
