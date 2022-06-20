import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/utils/validate_string.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class ProductPromotionTextController {
  final TextEditingController normalPrice = TextEditingController();
  final TextEditingController promotionPrice = TextEditingController();
  final TextEditingController buy = TextEditingController();
  final TextEditingController free = TextEditingController();
  final TextEditingController productName = TextEditingController();
  final TextEditingController additionNote = TextEditingController();

  final validations = <String>[].obs;

  bool? isValidNormalPrice() {
    return validations.isEmpty ? null : isValidField(0);
  }

  bool? isValidPromotionPrice() {
    return validations.isEmpty ? null : isValidField(1);
  }

  bool? isValidBuy() {
    return validations.isEmpty ? null : isValidField(2);
  }

  bool? isValidFree() {
    return validations.isEmpty ? null : isValidField(3);
  }

  bool? isValidPoductName() {
    return validations.isEmpty ? null : isValidField(0);
  }

  bool isValidField(int index) {
    if (validations.isNotEmpty) {
      return validations[index].isEmptyString() ? true : false;
    } else {
      return true;
    }
  }

  bool isDataValidSingleProduct() {
    validations.assignAll(['', '', '', '']);
    normalPrice.text.isEmptyString()
        ? setValidation(0, Keys.isRequired)
        : setValidation(0, '');
    promotionPrice.text.isEmptyString()
        ? setValidation(1, Keys.isRequired)
        : setValidation(1, '');
    buy.text.isEmptyString()
        ? setValidation(2, Keys.isRequired)
        : setValidation(2, '');
    free.text.isEmptyString()
        ? setValidation(3, Keys.isRequired)
        : setValidation(3, '');
    return validations.every((element) => element == '');
  }

  bool isDataValidEachProduct() {
    validations.assignAll(['']);
    productName.text.isEmptyString()
        ? setValidation(0, Keys.isRequired)
        : setValidation(0, '');
    return validations.every((element) => element == '');
  }

  void setValidation(int index, String validationString) {
    validations[index] = validationString;
  }

  void dispose() {
    normalPrice.dispose();
    buy.dispose();
    free.dispose();
    productName.dispose();
    additionNote.dispose();
  }

  void clearAll() {
    normalPrice.clear();
    buy.clear();
    free.clear();
    productName.clear();
    additionNote.clear();
  }
}
