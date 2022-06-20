import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/roster/WorkingHoursModel.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

// ignore: must_be_immutable
class DropDownCustom extends StatelessWidget {
  final List<dynamic> listItem;
  final void Function(dynamic) onSelected;
  final dynamic selected;
  final bool border;
  final double height;
  const DropDownCustom(
      {Key? key,
      required this.listItem,
      required this.onSelected,
      required this.selected,
      required this.height,
      this.border = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: border != false ? BorderRadius.circular(8) : null,
        border: border != false
            ? Border.all(color: AppTheme.greyBorder, width: 1)
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<dynamic>(
          hint: text(Texts.select,
              color: AppTheme.greyText, fontSize: AppFontSize.mediumM),
          dropdownDecoration:
              BoxDecoration(borderRadius: BorderRadius.circular(8)),
          items: listItem
              .map((item) => DropdownMenuItem<dynamic>(
                    value: item,
                    child: text(item.label, fontSize: AppFontSize.mediumS),
                  ))
              .toList(),
          value: selected,
          onChanged: (value) {
            onSelected(value);
          },
          icon: listItem.isNotEmpty
              ? const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppTheme.greyText,
                )
              : LoadingCustom.loadingWidget(size: 15),
          buttonHeight: 30,
          buttonWidth: 90.w,
          itemHeight: 45,
        ),
      ),
    );
  }
}

class DropDownCustomWorkingHours extends StatelessWidget {
  final List<WorkingHoursModel> listItem;
  final void Function(WorkingHoursModel) onSelected;
  final WorkingHoursModel? selected;
  final bool border;
  final double height;
  const DropDownCustomWorkingHours(
      {Key? key,
      required this.listItem,
      required this.onSelected,
      required this.selected,
      required this.height,
      this.border = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: border != false ? BorderRadius.circular(8) : null,
        border: border != false
            ? Border.all(color: AppTheme.greyBorder, width: 1)
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<WorkingHoursModel>(
          hint: text(Texts.select,
              color: AppTheme.greyText, fontSize: AppFontSize.mediumM),
          dropdownDecoration:
              BoxDecoration(borderRadius: BorderRadius.circular(8)),
          items: listItem
              .map((item) => DropdownMenuItem<WorkingHoursModel>(
                    value: item,
                    child: text(item.name, fontSize: AppFontSize.mediumS),
                  ))
              .toList(),
          value: selected,
          onChanged: (value) {
            onSelected(value!);
          },
          icon: listItem.isNotEmpty
              ? const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppTheme.greyText,
                )
              : LoadingCustom.loadingWidget(size: 15),
          buttonHeight: 30,
          buttonWidth: 90.w,
          itemHeight: 45,
        ),
      ),
    );
  }
}
