import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import 'find_product_ctrl.dart';

class FindProductPage extends StatelessWidget {
  FindProductPage({Key? key}) : super(key: key);

  final ShopModel shopModel = Get.arguments[Keys.data];

  @override
  Widget build(BuildContext context) {
    final FindProductController controller =
        Get.put(FindProductController(context, shopModel: shopModel));
    return Scaffold(
      appBar: appbarBackgroundWithSearch(Texts.selectProduct,
          subTitle: shopModel.shop.name),
      body: Obx(() => Padding(
            padding: const EdgeInsets.all(15),
            child: contianerBorderShadow(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  textWithContainerGradient(Texts.findProduct),
                  verticalSpace(20),
                  textPickerWithLabel(
                    Texts.group,
                    controller.selectGroup.value?.name,
                    onTap: () {
                      controller.goToFindProductFilter(
                          FindProductType.findGroup,
                          id: shopModel.id);
                    },
                  ),
                  verticalSpace(10),
                  textPickerWithLabel(
                    Texts.category,
                    controller.selectCate.value?.name,
                    onTap: () {
                      controller.goToFindProductFilter(FindProductType.findCate,
                          id: shopModel.id);
                    },
                  ),
                  verticalSpace(10),
                  textPickerWithLabel(
                    Texts.subCategory,
                    controller.selectSub.value?.name,
                    onTap: () {
                      controller.goToFindProductFilter(FindProductType.findSub,
                          id: shopModel.id);
                    },
                  ),
                  verticalSpace(30),
                  roundButton(
                    Texts.searchProduct,
                    onPressed: () {
                      controller.goToProductPage();
                    },
                  ),
                  verticalSpace(15),
                  text("Or"),
                  verticalSpace(15),
                  roundButtonWithIcon(Texts.seacrhByBarcode, onPressed: () {
                    Get.toNamed(Routes.barcodeScan);
                  },
                      icon: const Icon(
                        Icons.qr_code_scanner,
                        color: AppTheme.mainRed,
                      ),
                      buttonColor: AppTheme.white,
                      textColor: AppTheme.mainRed,
                      borderColor: AppTheme.mainRed)
                ],
              ),
            ),
          )),
    );
  }
}
