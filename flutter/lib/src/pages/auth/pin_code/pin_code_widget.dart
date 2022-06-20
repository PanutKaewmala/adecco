import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'package:ahead_adecco/src/config/export_config.dart';

class NumpadPinCode extends StatelessWidget {
  NumpadPinCode({Key? key, required this.onNumpadTap}) : super(key: key);
  final void Function(Numpad numpad) onNumpadTap;
  final List<Numpad> _numpadList = [
    Numpad.num1,
    Numpad.num2,
    Numpad.num3,
    Numpad.num4,
    Numpad.num5,
    Numpad.num6,
    Numpad.num7,
    Numpad.num8,
    Numpad.num9,
    Numpad.space,
    Numpad.num0,
    Numpad.delete,
  ];

  Widget _buildButton(Numpad numpad) {
    return (numpad == Numpad.space)
        ? Container()
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: (numpad == Numpad.delete)
                ? const Icon(
                    Icons.arrow_back,
                    color: AppTheme.white,
                  )
                : Container(
                    child: text('${numpad.index}',
                        fontSize: AppFontSize.largeL,
                        textAlign: TextAlign.center,
                        color: AppTheme.white),
                  ),
            onPressed: () {
              onNumpadTap(numpad);
            });
  }

  Widget _buildnumpadGrid(List<Numpad> numList) {
    final size = DeviceTypeSize.getSizeType(sizeMobile: 80.w, sizeTablet: 60.w);
    return SizedBox(
      height: size,
      width: size,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: numList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 40),
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.all(10),
          child: Container(child: _buildButton(numList[index])),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildnumpadGrid(_numpadList),
    );
  }
}

class PincodeDot extends StatelessWidget {
  final double dotSize = 14;
  final bool filled;

  const PincodeDot({Key? key, required this.filled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 7),
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.white, width: 1),
          color: (filled) ? AppTheme.white : Colors.transparent),
    );
  }
}
