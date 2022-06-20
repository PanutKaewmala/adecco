import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/utils/validate_string.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import '../../../config/export_config.dart';

class CreateOTTextController {
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final validations = <String>[].obs;

  bool? isValidTitle() {
    return validations.isEmpty ? null : isValidField(0);
  }

  bool isValidField(int index) {
    if (validations.isNotEmpty) {
      return validations[index].isEmptyString() ? true : false;
    } else {
      return true;
    }
  }

  bool isDataValid() {
    validations.assignAll(['']);
    title.text.isEmptyString()
        ? setValidation(0, Keys.isRequired)
        : setValidation(0, '');
    return validations.every((element) => element == '');
  }

  void setValidation(int index, String validationString) {
    validations[index] = validationString;
  }

  void dispose() {
    title.dispose();
    description.dispose();
  }
}
