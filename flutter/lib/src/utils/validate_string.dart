extension ValidateString on String {
  bool isEmptyString() {
    return trim().replaceAll(' ', '').isEmpty;
  }

  bool isNotEmptyString() {
    return trim().replaceAll(' ', '').isNotEmpty;
  }
}
