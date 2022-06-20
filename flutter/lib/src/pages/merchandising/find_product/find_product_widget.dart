import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/merchandising/FindProductModel.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import 'find_product_filter/find_product_filter_ctrl.dart';

Widget buildFilterList(FindProductFilterController controller,
    List<FindProductModel> findProductList) {
  return ListView.builder(
    controller: controller.listViewCtrl,
    padding: const EdgeInsets.all(15),
    itemCount: findProductList.length,
    itemBuilder: (context, index) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 50,
        child: roundButtonWithWidth(
          findProductList[index].name,
          fontSize: AppFontSize.mediumM,
          side: true,
          buttonColor: AppTheme.white,
          textColor: AppTheme.black,
          borderColor: AppTheme.greyBorder,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.left,
          onPressed: () {
            controller.getBack(findProductList[index]);
          },
        ),
      ),
    ),
  );
}
