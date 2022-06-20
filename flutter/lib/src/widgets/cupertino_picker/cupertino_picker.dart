import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'package:flutter/cupertino.dart';

Widget _renderTitleActionsView(void Function()? onPressed) {
  return Container(
    height: 40,
    decoration: const BoxDecoration(
      color: AppTheme.white,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          height: 40,
          child: CupertinoButton(
            pressedOpacity: 0.3,
            padding: const EdgeInsetsDirectional.only(start: 16, top: 0),
            child: text(Texts.cancel,
                fontSize: AppFontSize.mediumM, fontFamily: houschkaHead),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        SizedBox(
          height: 40,
          child: CupertinoButton(
            pressedOpacity: 0.3,
            padding: const EdgeInsetsDirectional.only(end: 16, top: 0),
            child: text(Texts.done,
                fontSize: AppFontSize.mediumM,
                fontFamily: houschkaHead,
                color: AppTheme.mainRed),
            onPressed: onPressed,
          ),
        ),
      ],
    ),
  );
}

Widget _textPicker(String name) {
  return Center(
    child: text(name, fontSize: AppFontSize.mediumL, fontFamily: houschkaHead),
  );
}

Future showCupertinoProjectPicker(BuildContext context,
    {required List<EmployeeProjectModel> employeeProjectList,
    void Function(EmployeeProjectModel)? onPressed,
    EmployeeProjectModel? selected}) {
  EmployeeProjectModel employeeProjectModel = employeeProjectList.isNotEmpty
      ? selected ?? employeeProjectList[0]
      : EmployeeProjectModel(
          id: 0,
          project: ProjectModel(
              id: 0,
              name: Texts.dataNotFound,
              description: "",
              end_date: "",
              start_date: ""));

  List<Widget> widgets = employeeProjectList
      .map((employee) => _textPicker(employee.project.name))
      .toList();

  if (employeeProjectList.isEmpty) {
    widgets.add(_textPicker(employeeProjectModel.project.name));
  }

  int whereIndex(EmployeeProjectModel employeeProjectModel) {
    if (employeeProjectList.isEmpty) {
      return 0;
    } else {
      employeeProjectModel = employeeProjectList
          .where((element) => employeeProjectModel.id == element.id)
          .first;
      return employeeProjectList.indexOf(employeeProjectModel);
    }
  }

  void onPressedDone() {
    Get.back();
    if (onPressed != null && employeeProjectList.isNotEmpty) {
      onPressed(employeeProjectModel);
    }
  }

  return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 30.h,
          color: AppTheme.white,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
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
                      text(Texts.plsSelectProject,
                          fontSize: AppFontSize.mediumL),
                    ],
                  ),
                ),
                _renderTitleActionsView(onPressedDone),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                        initialItem: whereIndex(employeeProjectModel)),
                    children: widgets,
                    onSelectedItemChanged: (value) {
                      employeeProjectModel = employeeProjectList[value];
                    },
                    itemExtent: 35,
                    backgroundColor: AppTheme.white,
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

Future showCupertinoStringPicker(BuildContext context, String title,
    {required List<String> stringList,
    void Function(int)? onPressed,
    String? selected}) {
  String selectedString =
      stringList.isNotEmpty ? selected ?? stringList[0] : Texts.dataNotFound;

  List<Widget> widgets = stringList.map((name) => _textPicker(name)).toList();

  if (stringList.isEmpty) {
    widgets.add(_textPicker(selectedString));
  }

  int whereStringIndex(String name) {
    if (stringList.isEmpty) {
      return 0;
    } else {
      selectedString =
          stringList.where((element) => selectedString == element).first;
      return stringList.indexOf(name);
    }
  }

  void onPressedDone() {
    Get.back();
    if (onPressed != null && stringList.isNotEmpty) {
      onPressed(whereStringIndex(selectedString));
    }
  }

  return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 30.h,
          color: AppTheme.white,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
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
                      text(title, fontSize: AppFontSize.mediumL),
                    ],
                  ),
                ),
                _renderTitleActionsView(onPressedDone),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                        initialItem: whereStringIndex(selectedString)),
                    children: widgets,
                    onSelectedItemChanged: (value) {
                      selectedString = stringList[value];
                    },
                    itemExtent: 35,
                    backgroundColor: AppTheme.white,
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
