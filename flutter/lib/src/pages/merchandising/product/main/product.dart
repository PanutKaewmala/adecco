import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/pages/merchandising/product/main/product_ctrl.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import 'product_widget.dart';

class ProductPage extends StatelessWidget {
  ProductPage({Key? key}) : super(key: key);
  final String? _subName = Get.arguments[Keys.name];
  final ShopModel shopModel = Get.arguments[Keys.data];
  final int _settingID = Get.arguments[Keys.settingID];
  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.put(
        ProductController(context, shopModel: shopModel, setting: _settingID));
    return Scaffold(
        appBar: appbarBackgroundWithSearch(
          _subName ?? "-",
          subTitle: shopModel.shop.name,
        ),
        body: Obx(
          () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    buildTapbar(
                      Texts.osa,
                      controller.tabList[0].value,
                      width: 90,
                      onPressed: () {
                        controller.onPressedTab(ProductTabbarType.osa);
                      },
                    ),
                    dividerVertical(25, left: 10, right: 10),
                    buildTapbar(
                      Texts.priceTracking,
                      controller.tabList[1].value,
                      width: 90,
                      onPressed: () {
                        controller
                            .onPressedTab(ProductTabbarType.priceTracking);
                      },
                    ),
                    dividerVertical(25, left: 10, right: 10),
                    buildTapbar(
                      Texts.sku,
                      controller.tabList[2].value,
                      width: 90,
                      onPressed: () {
                        controller.onPressedTab(ProductTabbarType.sku);
                      },
                    )
                  ],
                ),
                controller.obx(
                  (state) => BuildProductList(
                      controller: controller, productList: state!),
                  onLoading: Expanded(
                    child: controller.showSearch.value
                        ? Container()
                        : Center(child: LoadingCustom.loadingWidget()),
                  ),
                  onEmpty:
                      Expanded(child: Center(child: textNotFoundAndIcon())),
                  onError: (error) =>
                      Expanded(child: Center(child: textErrorAndIcon())),
                ),
                if (controller.isLoading.value == true && controller.page != 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Center(
                      child: LoadingCustom.loadingWidget(),
                    ),
                  ),
                verticalSpace(15)
              ],
            ),
          ),
        ));
  }
}
