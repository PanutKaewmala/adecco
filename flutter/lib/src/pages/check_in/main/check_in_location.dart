import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';

import 'package:ahead_adecco/src/widgets/export_widget.dart';

class CheckInLocationPage extends StatelessWidget {
  CheckInLocationPage({Key? key}) : super(key: key);

  final List<String> locationList = Get.arguments[Keys.data] ?? [];

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
          appBar: appbarBackground(Texts.location),
          body: locationList.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: locationList.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      height: 50,
                      child: roundButtonWithWidth(
                        locationList[index],
                        fontSize: AppFontSize.mediumM,
                        side: true,
                        buttonColor: AppTheme.white,
                        textColor: AppTheme.black,
                        borderColor: AppTheme.greyBorder,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.left,
                        onPressed: () {
                          Get.back(result: index);
                        },
                      ),
                    ),
                  ),
                )
              : Center(
                  child: textNotFoundAndIcon(),
                )),
    );
  }
}
