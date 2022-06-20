import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/pages/merchandising/select_shop/select_shop_ctrl.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

Widget buildShopList(
    SelectShopController controller, List<ShopModel> shopList) {
  return ListView.builder(
    controller: controller.listViewCtrl,
    padding: const EdgeInsets.all(15),
    shrinkWrap: true,
    itemCount: shopList.length,
    itemBuilder: (context, index) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 50,
        child: roundButtonWithWidth(
          shopList[index].shop.name,
          fontSize: AppFontSize.mediumM,
          side: true,
          buttonColor: AppTheme.white,
          textColor: AppTheme.black,
          borderColor: AppTheme.greyBorder,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.left,
          onPressed: () {
            controller.goToFindingProduct(shopList[index]);
          },
        ),
      ),
    ),
  );
}
