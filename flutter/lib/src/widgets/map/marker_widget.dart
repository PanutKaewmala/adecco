import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class CustomMarker extends StatelessWidget {
  const CustomMarker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle),
        height: 20.w,
        width: 20.w,
        child: Stack(
          children: [
            Align(
                alignment: Alignment.bottomCenter,
                child: Icon(
                  Icons.location_on_rounded,
                  color: AppTheme.mainRed,
                  size: 20.w,
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 6.75.w),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/avatar.png',
                    fit: BoxFit.fill,
                    width: 10.w,
                    height: 10.w,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
