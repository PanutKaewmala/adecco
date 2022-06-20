import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class DrawCircle extends CustomPainter {
  final double paintSize;
  DrawCircle({required this.paintSize});
  Paint paint1 = Paint()
    ..color = AppTheme.white
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(const Offset(0.0, 0.0), paintSize, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
