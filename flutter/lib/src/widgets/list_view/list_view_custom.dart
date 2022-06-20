import 'package:ahead_adecco/src/widgets/export_widget.dart';

Widget listViewCustom(
    {List<Widget> children = const <Widget>[], ScrollController? controller}) {
  return ListView(
    controller: controller,
    physics: const ClampingScrollPhysics(),
    padding: EdgeInsets.zero,
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    children: children,
  );
}

Widget singleChildScrollViewCustom(
    {required Widget child, ScrollController? controller}) {
  return SingleChildScrollView(
    controller: controller,
    physics: const ClampingScrollPhysics(),
    padding: EdgeInsets.zero,
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    child: child,
  );
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  static overscroll() {
    return const ScrollBehavior().copyWith(overscroll: false);
  }
}
