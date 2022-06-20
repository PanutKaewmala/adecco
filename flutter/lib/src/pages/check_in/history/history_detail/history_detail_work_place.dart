import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class HistoryDetailWorkPlacePage extends StatelessWidget {
  const HistoryDetailWorkPlacePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarBackground("Visit New Store"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 15),
            child: text(DateTimeService.getStringDateTimeFormat(DateTime.now(),
                format: DateTimeFormatCustom.mmmmddyyyy)),
          ),
          Expanded(
            child: singleChildScrollViewCustom(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: contianerBorderShadow(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textWithContainerGradient("Type 1"),
                    verticalSpace(10),
                    text("Location"),
                    verticalSpace(5),
                    text("Lotus Rama I", fontSize: AppFontSize.mediumS),
                    verticalSpace(5),
                    text(
                        "Lotus Rama I Rama I Road, Pathum Wan, Pathum Wan District, Bangkok 10330",
                        fontSize: AppFontSize.mediumS,
                        color: AppTheme.greyText),
                    dividerHorizontal(top: 10, bottom: 10),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: ((context, index) => buildRowQuestion()),
                        separatorBuilder: (context, index) =>
                            dividerHorizontal(top: 10, bottom: 10),
                        itemCount: 10)
                  ],
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRowQuestion() {
    return SizedBox(
      height: 70,
      child: Row(
        children: [
          Container(
            width: 4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppTheme.mainRed, AppTheme.peach]),
            ),
          ),
          horizontalSpace(5),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text("Name",
                    fontSize: AppFontSize.mediumL, fontWeight: FontWeight.bold),
                Container(
                  height: 40,
                  alignment: Alignment.centerLeft,
                  child: text(
                      "Lotus Rama I Rama I Road, Pathum Wan, Pathum Wan District, Bangkok 10330,Lotus Rama I Rama I Road, Pathum Wan, Pathum Wan District, Bangkok 10330",
                      color: AppTheme.greyText,
                      maxline: 2,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
