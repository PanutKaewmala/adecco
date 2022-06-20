import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/pages/merchandising/product/product_date/product_date_ctrl.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import 'product_date_widget.dart';

class ProductDatePage extends StatelessWidget {
  ProductDatePage({Key? key}) : super(key: key);

  final ProductModel _productModel = Get.arguments[Keys.product];
  final ProductTabbarType _productTabbarType = Get.arguments[Keys.type];

  @override
  Widget build(BuildContext context) {
    final ProductDateController controller = Get.put(ProductDateController(
        context,
        productModel: _productModel,
        type: _productTabbarType));
    return Scaffold(
      appBar: appbarBackgroundWithSearch(_productModel.name,
          subTitle: _productTabbarType.title),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(15.0),
          child: contianerBorder(
            child: Column(
              children: [
                textWithContainerGradient(Texts.selectDate),
                verticalSpace(15),
                dateSelectWithLabel(context, controller.startDate.value,
                    controller.endDate.value, onPressStartDate: (dateTime) {
                  controller.onClickSelectDate(true, dateTime);
                }, onPressEndDate: (dateTime) {
                  controller.onClickSelectDate(false, dateTime);
                }, minTime: controller.startDate.value),
                Expanded(
                  child: controller.obx(
                    (state) => ProductDateWidget(
                      controller: controller,
                      productDateList: state!,
                    ),
                    onLoading: controller.showSearch.value
                        ? Container()
                        : Center(child: LoadingCustom.loadingWidget()),
                    onEmpty: Center(child: textNotFoundAndIcon()),
                    onError: (error) => Center(child: textErrorAndIcon()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          dividerHorizontal(bottom: 5, top: 5),
          bottomNavigation("+" "${Texts.newDate}", onPressed: () {
            controller.onClickNewDate();
          }, color: AppTheme.black2)
        ],
      ),
    );
  }
}
