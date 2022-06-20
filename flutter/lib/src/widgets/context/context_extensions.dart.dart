import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

extension Ctx on BuildContext {
  Future showBottomSheetCustom(
      {required void Function(int index) onTap,
      required List<String> item,
      required String title}) {
    return showModalBottomSheet(
      context: this,
      backgroundColor: AppTheme.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: SafeArea(
          bottom: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text(title,
                  fontSize: AppFontSize.mediumM,
                  fontWeight: FontWeight.bold,
                  fontFamily: houschkaHead),
              ListView.builder(
                shrinkWrap: true,
                itemCount: item.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: roundButton(item[index], onPressed: () {
                    Get.back();
                    onTap(index);
                  },
                      fontSize: AppFontSize.mediumM,
                      textColor: AppTheme.mainRed,
                      buttonColor: AppTheme.white,
                      side: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
