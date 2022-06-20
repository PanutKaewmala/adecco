import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/utils/validate_string.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import '../../../config/export_config.dart';

class CreatePasswordTextController {
  final TextEditingController password = TextEditingController();
  final TextEditingController comfirmPassword = TextEditingController();
  final validations = <String>[].obs;

  bool? isValidPassword() {
    return validations.isEmpty ? null : isValidField(0);
  }

  bool? isValidConfirmPassword() {
    return validations.isEmpty ? null : isValidField(1);
  }

  bool isValidField(int index) {
    if (validations.isNotEmpty) {
      return validations[index].isEmptyString() ? true : false;
    } else {
      return true;
    }
  }

  bool isDataValid() {
    validations.assignAll(['', '']);
    password.text.isEmptyString()
        ? setValidation(0, Keys.isRequired)
        : setValidation(0, '');
    comfirmPassword.text.isEmptyString()
        ? setValidation(1, Keys.isRequired)
        : setValidation(1, '');
    return validations.every((element) => element == '');
  }

  void setValidation(int index, String validationString) {
    validations[index] = validationString;
  }

  void dispose() {
    password.dispose();
    comfirmPassword.dispose();
  }
}
