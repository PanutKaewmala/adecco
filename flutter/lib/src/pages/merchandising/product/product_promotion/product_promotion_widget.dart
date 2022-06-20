import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/pages/merchandising/product/product_promotion/product_promotion_ctrl.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

Widget _buildRadioButton(dynamic value, dynamic groupValue,
    {required void Function(dynamic)? onChanged}) {
  return SizedBox(
      width: 30,
      height: 30,
      child: Radio(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: AppTheme.mainRed,
      ));
}

Widget containerBorder() {
  return Container(
    decoration: BoxDecoration(
        color: AppTheme.grey, borderRadius: BorderRadius.circular(10)),
    height: 45,
    width: 50,
  );
}

Widget buildPromotionOne(
    BuildContext context,
    ProductPromotionController controller,
    dynamic groupValue1,
    dynamic groupValue2,
    bool enable1,
    bool enable2,
    {required void Function(dynamic)? onChanged,
    required void Function(dynamic)? onChangedBuy}) {
  return Column(
    children: [
      Row(
        children: [
          _buildRadioButton(
              PriceTrackingType.singleCategoryProduct, groupValue1,
              onChanged: onChanged),
          text(Texts.singleProduct, fontSize: AppFontSize.mediumM)
        ],
      ),
      groupValue1 == PriceTrackingType.singleCategoryProduct
          ? Column(
              children: [
                verticalSpace(10),
                dateSelectWithLabel(context, controller.startDate.value,
                    controller.endDate.value, onPressStartDate: (date) {
                  controller.startDate.value = date;
                }, onPressEndDate: (date) {
                  controller.endDate.value = date;
                }, minTime: controller.startDate.value),
                verticalSpace(10),
                textFieldWithlabelMoneyFormat(Texts.promotionPrice,
                    controller.textController.promotionPrice,
                    validate:
                        controller.textController.isValidPromotionPrice()),
                verticalSpace(10),
                Row(
                  children: [
                    _buildRadioButton(0, groupValue2, onChanged: onChangedBuy),
                    SizedBox(
                        width: 65,
                        child:
                            text(Texts.buypcs, fontSize: AppFontSize.mediumS)),
                    horizontalSpace(5),
                    enable1
                        ? textFieldNoLabel(controller.textController.buy,
                            enabled: enable1,
                            validate: controller.textController.isValidBuy(),
                            keyboardType: TextInputType.number)
                        : containerBorder(),
                    horizontalSpace(5),
                    SizedBox(
                        width: 60,
                        child:
                            text(Texts.getpcs, fontSize: AppFontSize.mediumS)),
                    horizontalSpace(5),
                    enable1
                        ? textFieldNoLabel(controller.textController.free,
                            enabled: enable1,
                            validate: controller.textController.isValidFree(),
                            keyboardType: TextInputType.number)
                        : containerBorder(),
                    horizontalSpace(5),
                    text(Texts.free, fontSize: AppFontSize.mediumS)
                  ],
                ),
                verticalSpace(10),
                Row(
                  children: [
                    _buildRadioButton(1, groupValue2, onChanged: onChangedBuy),
                    SizedBox(
                        width: 65,
                        child:
                            text(Texts.buypcs, fontSize: AppFontSize.mediumS)),
                    horizontalSpace(5),
                    enable2
                        ? textFieldNoLabel(controller.textController.buy,
                            enabled: enable2,
                            validate: controller.textController.isValidBuy(),
                            keyboardType: TextInputType.number)
                        : containerBorder(),
                    horizontalSpace(5),
                    SizedBox(
                        width: 60,
                        child: text(Texts.getpercent,
                            fontSize: AppFontSize.mediumS)),
                    horizontalSpace(5),
                    enable2
                        ? textFieldNoLabel(controller.textController.free,
                            enabled: enable2,
                            validate: controller.textController.isValidFree(),
                            keyboardType: TextInputType.number)
                        : containerBorder(),
                    horizontalSpace(5),
                    text(Texts.off, fontSize: AppFontSize.mediumS)
                  ],
                ),
              ],
            )
          : Container()
    ],
  );
}

Widget buildPromotionTwo(BuildContext context,
    ProductPromotionController controller, dynamic groupValue1,
    {required void Function(dynamic)? onChanged}) {
  return Column(
    children: [
      Row(
        children: [
          _buildRadioButton(PriceTrackingType.eachCategoryProduct, groupValue1,
              onChanged: onChanged),
          text(Texts.eachProduct, fontSize: AppFontSize.mediumM),
        ],
      ),
      groupValue1 == PriceTrackingType.eachCategoryProduct
          ? Column(
              children: [
                verticalSpace(10),
                dateSelectWithLabel(context, controller.startDate.value,
                    controller.endDate.value, onPressStartDate: (date) {
                  controller.startDate.value = date;
                }, onPressEndDate: (date) {
                  controller.endDate.value = date;
                }, minTime: controller.startDate.value),
                verticalSpace(10),
                textFieldWithlabel(
                    Texts.productName, controller.textController.productName,
                    validate: controller.textController.isValidPoductName()),
              ],
            )
          : Container()
    ],
  );
}

Widget buildPromotionThree(
    BuildContext context, dynamic groupValue1, String? selectReason,
    {required void Function(dynamic)? onChanged, void Function()? onTap}) {
  return Column(
    children: [
      Row(
        children: [
          _buildRadioButton(PriceTrackingType.noCategoryProduct, groupValue1,
              onChanged: onChanged),
          text(Texts.no, fontSize: AppFontSize.mediumM),
        ],
      ),
      groupValue1 == PriceTrackingType.noCategoryProduct
          ? Column(
              children: [
                verticalSpace(10),
                textPickerWithContainer(
                  selectReason ?? Texts.select,
                  onTap: onTap,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                ),
              ],
            )
          : Container()
    ],
  );
}
