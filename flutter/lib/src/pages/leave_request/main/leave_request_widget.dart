import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/pages/leave_request/main/leave_request_ctrl.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

Widget buildLeaveRequestList(LeaveRequestController controller,
    List<LeaveRequestModel> leaveRequestList) {
  return Expanded(
    child: Column(
      children: [
        verticalSpace(15),
        buildTabTitle(controller.isSelected.value),
        verticalSpace(15),
        Expanded(
          child: ListView.separated(
            controller: controller.listViewCtrl,
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) =>
                dividerHorizontal(top: 15, bottom: 15),
            itemCount: leaveRequestList.length,
            itemBuilder: (context, index) => elevatedButtonCustom(
              color: AppTheme.background,
              onPressed: () {
                controller.onClickLeave(leaveRequestList[index]);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  containerGradient(
                    height: 50,
                    width: 120,
                    color1: AppTheme.mainRed,
                    color2: AppTheme.peach,
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          textAutoSize(leaveRequestList[index].date,
                              fontSize: AppFontSize.mediumM,
                              color: AppTheme.mainRed,
                              maxline: 1),
                        ],
                      ),
                    ),
                  ),
                  horizontalSpace(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(leaveRequestList[index].type ?? "",
                          fontSize: AppFontSize.mediumM),
                      verticalSpace(5),
                      text(
                          leaveRequestList[index].all_day
                              ? Texts.allDay
                              : "${leaveRequestList[index].start_time} - ${leaveRequestList[index].end_time}",
                          fontSize: AppFontSize.mediumS)
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    ),
  );
}
