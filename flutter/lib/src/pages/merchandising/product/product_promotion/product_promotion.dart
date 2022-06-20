import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/pages/merchandising/product/main/product_ctrl.dart';
import 'package:ahead_adecco/src/pages/merchandising/product/product_date/product_date_ctrl.dart';
import 'package:ahead_adecco/src/pages/merchandising/product/product_promotion/product_promotion_ctrl.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import 'product_promotion_widget.dart';

class ProductPromotionPage extends StatelessWidget {
  ProductPromotionPage({Key? key}) : super(key: key);
  final ProductTabbarType _type = Get.arguments[Keys.type];
  final PageType _pageType = Get.arguments[Keys.pageType];
  final int? _id = Get.arguments[Keys.id];

  @override
  Widget build(BuildContext context) {
    final ProductController _productCtrl = Get.find();
    final ProductDateController _productDateCtrl = Get.find();
    final ProductPromotionController controller = Get.put(
        ProductPromotionController(context,
            type: _type,
            merchandizerProductID:
                _productDateCtrl.productModel.merchandizer_product,
            pageType: _pageType,
            id: _id));

    return KeyboardDismisser(
      child: Scaffold(
        appBar: appbarBackground(
          _type.title,
          subTitle: _productCtrl.shopModel.shop.name,
        ),
        body: controller.obx(
          (state) => Obx(
            () => SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: contianerBorderShadow(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textWithContainerGradient(
                            _productDateCtrl.productModel.name),
                        text(_productDateCtrl.productModel.setting_name,
                            color: AppTheme.greyText,
                            fontSize: AppFontSize.mediumS),
                        dividerHorizontal(top: 10, bottom: 20),
                        oneDateSelectWithLabel(context, controller.date.value,
                            lableStart: Texts.date + "*",
                            onPressSelectDate: (date) {
                          controller.date.value = date;
                        }),
                        verticalSpace(15),
                        textFieldWithlabelMoneyFormat(Texts.normalPrice,
                            controller.textController.normalPrice,
                            validate:
                                controller.textController.isValidNormalPrice()),
                        dividerHorizontal(top: 20, bottom: 20),
                        buildPromotionOne(
                            context,
                            controller,
                            controller.selectedType.value,
                            controller.buySelected.value,
                            controller.onSelectSinglePromotion(0),
                            controller.onSelectSinglePromotion(1),
                            onChanged: (v) {
                          controller.onSelectPromotion(v);
                        }, onChangedBuy: (v) {
                          controller.onSelectBuy(v);
                        }),
                        verticalSpace(20),
                        buildPromotionTwo(
                          context,
                          controller,
                          controller.selectedType.value,
                          onChanged: (v) {
                            controller.onSelectPromotion(v);
                          },
                        ),
                        verticalSpace(20),
                        buildPromotionThree(
                            context,
                            controller.selectedType.value,
                            controller.reason.value?.label, onChanged: (v) {
                          controller.onSelectPromotion(v);
                        }, onTap: () {
                          controller.onClickSelectReason();
                        }),
                        dividerHorizontal(top: 20, bottom: 20),
                        textFieldMutiLineWithlabel(Texts.additionalNote,
                            controller.textController.additionNote,
                            maxLine: 5),
                      ],
                    )),
              ),
            ),
          ),
          onLoading: Center(child: LoadingCustom.loadingWidget()),
          onEmpty: Center(child: textNotFoundAndIcon()),
          onError: (error) => Center(child: textErrorAndIcon()),
        ),
        bottomNavigationBar: Obx(
          () => bottomNavigationWithEdit(
              _pageType, controller.disableButton.value, onPressedCancel: () {
            controller.onClickCancel();
          }, onPressedSave: () {
            controller.onClickCreate();
          }, onPressedCreate: () {
            controller.onClickCreate();
          }),
        ),
      ),
    );
  }
}
