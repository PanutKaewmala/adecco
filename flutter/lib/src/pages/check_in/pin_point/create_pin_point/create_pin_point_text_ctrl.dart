import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/utils/validate_string.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class CreatePinPointTextController {
  final int length;
  final List<int> notRequiredList;
  List<TextEditingController> textControllerList = [];
  final validations = <String>[].obs;
  CreatePinPointTextController(
      {required this.length, required this.notRequiredList})
      : super() {
    initTextController();
  }

  void initTextController() {
    List<String> _validations = List.generate(length, (index) => '');
    for (var item in notRequiredList) {
      _validations[item] = Keys.isNotRequired;
    }
    List<TextEditingController> _textControllerList =
        List.generate(length, (index) => TextEditingController());
    validations.assignAll(_validations);
    textControllerList = _textControllerList;
  }

  bool? isValid(int index) {
    return validations[index].isEmpty ? null : isValidField(index);
  }

  bool isValidField(int index) {
    if (validations.isNotEmpty) {
      return validations[index].isEmptyString() ? true : false;
    } else {
      return true;
    }
  }

  bool isDataValid() {
    textControllerList.asMap().forEach((key, value) {
      value.text.isEmptyString() && !notRequiredList.contains(key)
          ? setValidation(key, Keys.isRequired)
          : setValidation(key, '');
    });
    debugPrint("textControllerList $validations");
    return validations.every((element) => element == '');
  }

  void setValidation(int index, String validationString) {
    validations[index] = validationString;
  }

  void dispose() {
    for (var element in textControllerList) {
      element.dispose();
    }
  }
}
