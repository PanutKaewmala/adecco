import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/utils/validate_string.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import '../../../config/export_config.dart';

class ForgotPasswordTextController {
  final TextEditingController username = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final validations = <String>[].obs;

  bool? isValidUsername() {
    return validations.isEmpty ? null : isValidField(0);
  }

  bool? isValidPhone() {
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
    username.text.isEmptyString()
        ? setValidation(0, Keys.isRequired)
        : setValidation(0, '');
    phone.text.isEmptyString()
        ? setValidation(1, Keys.isRequired)
        : setValidation(1, '');
    return validations.every((element) => element == '');
  }

  void setValidation(int index, String validationString) {
    validations[index] = validationString;
  }

  void dispose() {
    username.dispose();
    phone.dispose();
  }
}
