import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'package:ahead_adecco/src/config/export_config.dart';

Widget textAndLogo(String header, String desc) {
  final size = DeviceTypeSize.getSizeType(sizeMobile: 15.w, sizeTablet: 10.w);
  return Column(
    children: [
      verticalSpace(45),
      Align(
        alignment: Alignment.centerRight,
        child: Container(
            padding: const EdgeInsets.only(right: 20, top: 10),
            height: size,
            width: size,
            child: const Image(
                fit: BoxFit.fitWidth,
                image: AssetImage('assets/images/logo.png'))),
      ),
      verticalSpace(35),
      SizedBox(height: 40.w, child: textHeaderAndDesc(header, desc)),
    ],
  );
}
