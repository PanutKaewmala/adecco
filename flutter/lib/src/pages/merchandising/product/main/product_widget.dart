import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/pages/merchandising/product/main/product_ctrl.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class BuildProductList extends StatelessWidget {
  final ProductController controller;
  final List<ProductModel> productList;
  const BuildProductList(
      {Key? key, required this.controller, required this.productList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: contianerBorder(
        padding: EdgeInsets.zero,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: productList.length,
          controller: controller.listViewCtrl,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) => SizedBox(
            height: 50,
            child: roundButtonWithWidth(
              productList[index].name,
              fontSize: AppFontSize.mediumM,
              buttonColor: AppTheme.white,
              textColor: AppTheme.black,
              borderColor: AppTheme.greyBorder,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.left,
              onPressed: () {
                controller.goToProductDate(productList[index]);
              },
            ),
          ),
          separatorBuilder: (context, index) =>
              dividerHorizontal(top: 5, bottom: 5),
        ),
      ),
    );
  }
}
