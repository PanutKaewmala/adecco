import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/pages/calendar/main/calendar_ctrl.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

Widget buildToDayList(CalendarController controller) {
  if (controller.eventToday.value!.status == CalendarStatus.workDay.key) {
    return ListView.separated(
      controller: controller.listViewCtrl,
      padding: EdgeInsets.zero,
      itemCount: controller.dailyTaskList.length,
      itemBuilder: (context, index) =>
          LocationDetail(checkInTasksModel: controller.dailyTaskList[index]),
      separatorBuilder: (context, index) {
        return dividerHorizontal(top: 10, bottom: 10);
      },
    );
  } else if (controller.eventToday.value!.status == CalendarStatus.leave.key) {
    return ListView.separated(
      controller: controller.listViewCtrl,
      padding: EdgeInsets.zero,
      itemCount: controller.leaveRequestList.length,
      itemBuilder: (context, index) => buttonLeaveRequest(controller,
          leaveRequestModel: controller.leaveRequestList[index]),
      separatorBuilder: (context, index) {
        return dividerHorizontal(top: 10, bottom: 10);
      },
    );
  } else {
    return Container();
  }
}

Widget buttonLeaveRequest(CalendarController controller,
    {LeaveRequestModel? leaveRequestModel}) {
  return Container(
    height: 50,
    decoration: const BoxDecoration(color: AppTheme.white),
    child: elevatedButtonCustom(
      onPressed: () {
        controller.onClickLeave(leaveRequestModel!);
      },
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 50,
                  width: 3,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppTheme.mainRed, AppTheme.peach]))),
              horizontalSpace(5),
              text(leaveRequestModel?.type ?? "Visit Store",
                  fontSize: AppFontSize.mediumM),
              horizontalSpace(10),
              Visibility(
                visible: leaveRequestModel!.status == LeaveRequest.pending.key,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppTheme.orange),
                  child: text(Texts.pending,
                      fontSize: AppFontSize.small,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.orangeText),
                ),
              )
            ],
          ),
          leaveRequestModel.all_day
              ? text("All-Day", fontSize: AppFontSize.mediumM)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 20,
                        child: text(
                            leaveRequestModel.start_time?.substring(0, 5) ??
                                "10:00",
                            fontSize: AppFontSize.mediumM)),
                    SizedBox(
                        height: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Container(
                            width: 5,
                            height: 2,
                            color: AppTheme.greyText,
                          ),
                        )),
                    SizedBox(
                        height: 20,
                        child: text(
                            leaveRequestModel.end_time?.substring(0, 5) ??
                                "10:00",
                            fontSize: AppFontSize.mediumM,
                            color: AppTheme.greyText))
                  ],
                )
        ],
      ),
    ),
  );
}
