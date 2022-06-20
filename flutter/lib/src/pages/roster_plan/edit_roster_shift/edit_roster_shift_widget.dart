import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/pages/roster_plan/edit_roster_shift/edit_roster_shift_ctrl.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class EditRosterShiftWidget extends StatelessWidget {
  final int shiftIndex;
  const EditRosterShiftWidget({Key? key, required this.shiftIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditRosterShiftController controller = Get.find();

    return Obx(
      () => Padding(
          padding: const EdgeInsets.all(15),
          child: contianerBorderShadow(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  text(Texts.roster,
                      fontSize: AppFontSize.mediumL,
                      fontWeight: FontWeight.bold),
                ],
              ),
              verticalSpace(10),
              dateWithLabel(
                  controller.startDate.value, controller.endDate.value),
              verticalSpace(10),
              textFieldMutiLineWithlabel(Texts.remarks, controller.remark,
                  maxLine: 5),
              verticalSpace(20),
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
                      text(Texts.shift + " $shiftIndex",
                          fontSize: AppFontSize.mediumL,
                          fontWeight: FontWeight.bold),
                    ],
                  ),
                ],
              ),
              verticalSpace(20),
              dateWithLabel(
                  controller.startDate.value, controller.endDate.value),
              verticalSpace(20),
              text(Texts.workingHours,
                  fontSize: AppFontSize.mediumS, color: AppTheme.greyText),
              verticalSpace(10),
              controller.workingTimeList.isNotEmpty
                  ? DropDownCustomWorkingHours(
                      listItem: controller.workingTimeList,
                      selected: controller.selectedWorkingHours.value,
                      border: true,
                      height: 45,
                      onSelected: (value) {
                        controller.onSelectedWorkingHours(value, true);
                      },
                    )
                  : SizedBox(
                      height: 45,
                      child: LoadingCustom.loadingWidget(size: 15),
                    ),
              controller.selectedWorkingHours.value != null
                  ? buildDayWorkingHours(controller.showDayDetail.value,
                      controller.selectedWorkingHours.value, onTap: (v) {
                      controller.showDayDetail.value = v;
                    })
                  : Container(),
              controller.showDayDetail.value
                  ? dividerHorizontal(top: 5, bottom: 5)
                  : Container(),
              verticalSpace(10),
              text(Texts.schedule, fontSize: AppFontSize.mediumL),
              verticalSpace(10),
              ListView.separated(
                  separatorBuilder: (context, index) =>
                      dividerHorizontal(top: 10, bottom: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.shiftDataModel.workDayType.length,
                  itemBuilder: (context, indexShift) {
                    return Dismissible(
                      key: UniqueKey(),
                      direction: (indexShift > 0 &&
                              indexShift + 1 ==
                                  controller.shiftDataModel.workDayType.length)
                          ? DismissDirection.endToStart
                          : DismissDirection.none,
                      onDismissed: (direction) {
                        controller.removeSchedule(indexShift);
                      },
                      background: Container(
                        color: AppTheme.redText,
                        padding: const EdgeInsets.only(right: 15),
                        alignment: Alignment.centerRight,
                        child: const Icon(
                          Icons.delete,
                          color: AppTheme.white,
                        ),
                      ),
                      child:
                          _buildSelectWorkDay(controller, context, indexShift),
                    );
                  }),
              dividerHorizontal(bottom: 10, top: 10),
              roundButton(Texts.addSchedule, onPressed: () {
                controller.onClickAddSchedule();
              },
                  fontSize: AppFontSize.mediumM,
                  textColor: AppTheme.mainRed,
                  buttonColor: AppTheme.white,
                  side: true),
            ],
          ))),
    );
  }

  Widget _buildSelectWorkDay(EditRosterShiftController controller,
      BuildContext context, int indexShift) {
    return Container(
      color: AppTheme.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GetBuilder<EditRosterShiftController>(
            builder: (controller) => DayPickerCustom(
              disableDay: controller.shiftDataModel.selectedDay,
              workDay: controller.shiftDataModel.workDayType[indexShift],
              onPressed: (day, isDayOff) {
                controller.update();
                controller.removeSelectDay(indexShift, day, isDayOff);
                debugPrint(
                    "controller.shiftDataModel.selectedDay ${controller.shiftDataModel.selectedDay} $day $isDayOff");
              },
            ),
          ),
          verticalSpace(10),
          text(Texts.workPlace,
              fontSize: AppFontSize.mediumM,
              color: AppTheme.greyText,
              fontWeight: FontWeight.bold),
          Obx(
            () => MultiSelectChipDisplay(
              items: controller.shiftDataModel.placeList[indexShift].placeShift
                  .map((e) => MultiSelectItem(e, e.name))
                  .toList(),
              onTap: (PlaceRosterModel value) {
                controller.shiftDataModel.placeList[indexShift].placeShift
                    .removeWhere((element) => element.id == value.id);
              },
              chipColor: AppTheme.greyBorder,
              textStyle: textStyle(color: AppTheme.black),
            ),
          ),
          verticalSpace(10),
          GestureDetector(
            onTap: () async {
              await showModalBottomSheet(
                backgroundColor: AppTheme.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                context: context,
                builder: (ctx) {
                  return SafeArea(
                    bottom: true,
                    child: MultiSelectBottomSheet(
                      itemsTextStyle: textStyleWithFont(),
                      selectedItemsTextStyle: textStyleWithFont(),
                      searchable: false,
                      initialChildSize: 0.6,
                      selectedColor: AppTheme.mainRed,
                      items: controller.workPlaceList
                          .map((place) => MultiSelectItem<PlaceRosterModel>(
                              place, place.name))
                          .toList(),
                      initialValue: controller
                          .shiftDataModel.placeList[indexShift].placeShift,
                      onConfirm: (List<PlaceRosterModel> values) {
                        controller
                            .shiftDataModel.placeList[indexShift].placeShift
                            .assignAll(values);
                      },
                    ),
                  );
                },
              );
            },
            child: textWithIconContainer(
                Texts.addWorkPlace,
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppTheme.greyBorder,
                ),
                textColor: AppTheme.greyText),
          ),
        ],
      ),
    );
  }
}
