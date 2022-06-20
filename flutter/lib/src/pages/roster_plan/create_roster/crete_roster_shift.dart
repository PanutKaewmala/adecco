import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/pages/roster_plan/create_roster/create_roster_ctrl.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class RosterShift extends StatelessWidget {
  final int index;
  final bool showDelete;
  const RosterShift({Key? key, required this.index, required this.showDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CreateRosterController controller = Get.find();

    Widget _buildSelectWorkDay(BuildContext context, int indexShift) {
      return Container(
        color: AppTheme.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<CreateRosterController>(
              builder: (controller) => DayPickerCustom(
                disableDay: controller.shiftList[index].selectedDay,
                workDay: controller.shiftList[index].workDayType[indexShift],
                onPressed: (day, isDayOff) {
                  controller.update();
                  controller.removeSelectDay(index, day, isDayOff);
                },
              ),
            ),
            verticalSpace(10),
            text(Texts.workPlace,
                fontSize: AppFontSize.mediumM,
                color: AppTheme.greyText,
                fontWeight: FontWeight.bold),
            Obx(() => MultiSelectChipDisplay(
                  items: controller
                      .shiftList[index].placeList[indexShift].placeShift
                      .map((e) => MultiSelectItem(e, e.name))
                      .toList(),
                  onTap: (PlaceRosterModel value) {
                    controller.shiftList[index].placeList[indexShift].placeShift
                        .removeWhere((element) => element.id == value.id);
                    controller.update();
                  },
                  chipColor: AppTheme.greyBorder,
                  textStyle: textStyle(color: AppTheme.black),
                )),
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
                            .map((e) => MultiSelectItem(e, e.name))
                            .toList(),
                        initialValue: controller
                            .shiftList[index].placeList[indexShift].placeShift,
                        onConfirm: (List<PlaceRosterModel> values) {
                          controller
                              .shiftList[index].placeList[indexShift].placeShift
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

    return Obx(
      () => Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: contianerBorderShadow(
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
                      text(Texts.shift + " ${controller.shiftList[index].id}",
                          fontSize: AppFontSize.mediumL,
                          fontWeight: FontWeight.bold),
                    ],
                  ),
                  showDelete
                      ? SizedBox(
                          height: 25,
                          width: 25,
                          child: GestureDetector(
                              onTap: () {
                                controller.onClickRemove(index);
                              },
                              child: const Icon(
                                Icons.close,
                                color: AppTheme.greyText,
                              )),
                        )
                      : Container()
                ],
              ),
              verticalSpace(20),
              dateSelectWithLabel(
                  context,
                  controller.shiftList[index].startDate.value,
                  controller.shiftList[index].endDate.value,
                  endDateStart: controller.shiftList[index].startDate.value,
                  minTime: controller.shiftList[index].startDate.value,
                  maxTime: controller.endDate.value,
                  lableStart: Texts.from,
                  lableEnd: Texts.to,
                  onPressEndDate: showDelete
                      ? (date) {
                          controller.setDateIndex(index, false, date);
                        }
                      : null),
              verticalSpace(10),
              text(Texts.schedule, fontSize: AppFontSize.mediumL),
              ListView.separated(
                  separatorBuilder: (context, index) =>
                      dividerHorizontal(top: 10, bottom: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.shiftList[index].workDayType.length,
                  itemBuilder: (context, indexShift) {
                    return Dismissible(
                      key: UniqueKey(),
                      direction: (indexShift > 0 &&
                              indexShift + 1 ==
                                  controller
                                      .shiftList[index].workDayType.length)
                          ? DismissDirection.endToStart
                          : DismissDirection.none,
                      onDismissed: (direction) {
                        controller.removeSchedule(index, indexShift);
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
                      child: _buildSelectWorkDay(context, indexShift),
                    );
                  }),
              dividerHorizontal(bottom: 10, top: 10),
              roundButton(Texts.addSchedule, onPressed: () {
                controller.onClickAddSchedule(index);
              },
                  fontSize: AppFontSize.mediumM,
                  textColor: AppTheme.mainRed,
                  buttonColor: AppTheme.white,
                  side: true),
            ],
          ))),
    );
  }
}
