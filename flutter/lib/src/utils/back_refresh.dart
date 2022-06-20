void onBackRefresh({void Function()? function, bool? value}) {
  value != null && value ? function!() : null;
}
