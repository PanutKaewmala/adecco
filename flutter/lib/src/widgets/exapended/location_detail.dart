import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import '../../models/export_models.dart';

class LocationDetail extends StatefulWidget {
  final CheckInTasksModel checkInTasksModel;
  const LocationDetail({Key? key, required this.checkInTasksModel})
      : super(key: key);

  @override
  State<LocationDetail> createState() => _LocationDetailState();
}

class _LocationDetailState extends State<LocationDetail> {
  bool isExpaned = false;
  @override
  Widget build(BuildContext context) {
    return contianerBorderShadow(
        child: Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpaned = !isExpaned;
            });
          },
          child: Row(
            children: [
              text(widget.checkInTasksModel.name,
                  fontSize: AppFontSize.mediumM, fontWeight: FontWeight.bold),
              const Spacer(),
              text("${widget.checkInTasksModel.tasks.length} ${Texts.task}",
                  fontSize: AppFontSize.mediumS, color: AppTheme.greyText),
              Icon(
                  isExpaned
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppTheme.greyText)
            ],
          ),
        ),
        verticalSpace(5),
        Row(
          children: [
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.checkInTasksModel.inside
                      ? AppTheme.mainRed
                      : AppTheme.greyText),
            ),
            horizontalSpace(5),
            text(
                widget.checkInTasksModel.inside
                    ? Texts.insideWorkPlace
                    : Texts.outsideWorkPlace,
                fontSize: AppFontSize.mediumS),
          ],
        ),
        isExpaned ? dividerHorizontal(top: 15, bottom: 15) : Container(),
        isExpaned
            ? ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) =>
                    workPlace(widget.checkInTasksModel.tasks[index]),
                separatorBuilder: (context, index) =>
                    dividerHorizontal(top: 15, bottom: 15),
                itemCount: widget.checkInTasksModel.tasks.length)
            : Container()
      ],
    ));
  }

  Widget workPlace(TasksModel taskModel) {
    return Column(
      children: [
        Row(
          children: [
            textWithContainerGradientCustom(height: 15),
            horizontalSpace(10),
            text(taskModel.name, fontSize: AppFontSize.mediumM),
            const Spacer(),
            text(
                taskModel.date_time != null
                    ? DateTimeService.timeServerToStringHHMM(
                        taskModel.date_time!)
                    : "",
                fontSize: AppFontSize.mediumS,
                color: AppTheme.greyText)
          ],
        ),
      ],
    );
  }
}
