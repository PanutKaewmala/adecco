import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/pages/merchandising/product/product_date/product_date_ctrl.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class ProductDateWidget extends StatelessWidget {
  final ProductDateController controller;
  final List<ProductDateModel> productDateList;

  const ProductDateWidget(
      {Key? key, required this.controller, required this.productDateList})
      : super(key: key);

  void onTap(int index) {
    controller.onClickEdit(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        verticalSpace(20),
        Row(children: [
          _buildHeadTable(4, Texts.date, center: false),
          _buildHeadTable(3, Texts.promotion),
          _buildHeadTable(2, Texts.price),
          _buildHeadTable(3, Texts.promoPrice),
        ]),
        dividerHorizontal(top: 5, bottom: 10),
        Expanded(
            child: SingleChildScrollView(
          controller: controller.listViewCtrl,
          padding: EdgeInsets.zero,
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(4),
              1: FlexColumnWidth(3),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(3),
            },
            children: _buildListTableRow(productDateList, onTap: (index) {
              onTap(index);
            }),
          ),
        )),
      ],
    );
  }
}

List<TableRow> _buildListTableRow(List<ProductDateModel> productDateList,
    {required void Function(int) onTap}) {
  return List<TableRow>.generate(
    productDateList.length,
    (index) {
      final _product = productDateList[index];
      return TableRow(children: [
        _buildTextTable(
            DateTimeService.timeServerToStringDDMMMYYYY2(_product.date),
            center: false, onTap: () {
          onTap(productDateList[index].id);
        }),
        _buildTextTable(checkPromotionType(_product.type)),
        _buildTextTable(_product.normal_price.toString()),
        _buildTextTable(_product.promotion_price.toString()),
      ]);
    },
  );
}

Widget _buildHeadTable(int flex, String title, {bool center = true}) {
  return Flexible(
    flex: flex,
    child: SizedBox(
        width: double.maxFinite,
        child: text(title,
            fontSize: AppFontSize.small,
            color: AppTheme.greyText,
            fontWeight: FontWeight.bold,
            textAlign: center ? TextAlign.center : TextAlign.left)),
  );
}

Widget _buildTextTable(String title,
    {bool center = true, void Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
        height: 30,
        child: text(title,
            fontSize: AppFontSize.mediumS,
            color: AppTheme.black,
            textAlign: center ? TextAlign.center : TextAlign.left)),
  );
}

String checkPromotionType(String type) {
  switch (type) {
    case Keys.singleCategoryProduct:
      return "Y";
    case Keys.eachCategoryProduct:
      return "Y";
    case Keys.noCategoryProduct:
      return "N";
    default:
      return "";
  }
}
