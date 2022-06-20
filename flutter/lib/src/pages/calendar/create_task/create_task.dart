import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class CreateTaskPage extends StatelessWidget {
  const CreateTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarBackground(Texts.createTask),
    );
  }
}
