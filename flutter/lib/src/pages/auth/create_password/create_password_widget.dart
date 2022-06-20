import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

Icon validateIcon(CheckPassword check) {
  switch (check) {
    case CheckPassword.pass:
      return const Icon(
        Icons.check_circle,
        color: AppTheme.green,
        size: 14,
      );
    case CheckPassword.fail:
      return const Icon(
        Icons.close_sharp,
        color: AppTheme.red,
        size: 14,
      );
    default:
      return const Icon(
        Icons.check_circle,
        color: AppTheme.greyBorder,
        size: 14,
      );
  }
}
