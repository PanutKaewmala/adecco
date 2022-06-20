import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/models/merchandising/FindProductModel.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class FindProductController extends GetxController {
  BuildContext context;
  ShopModel shopModel;
  FindProductController(this.context, {required this.shopModel});
  final selectGroup = Rx<FindProductModel?>(null);
  final selectCate = Rx<FindProductModel?>(null);
  final selectSub = Rx<FindProductModel?>(null);

  void goToFindProductFilter(FindProductType type,
      {int? id, int? parentID}) async {
    switch (type) {
      case FindProductType.findGroup:
        Get.toNamed(Routes.findProductFilter,
            arguments: {Keys.id: id, Keys.type: type})?.then((value) {
          if (value != null) {
            selectGroup.value = value;
            if (selectCate.value != null || selectSub.value != null) {
              selectCate.value = null;
              selectSub.value = null;
            }
          }
        });

        break;

      case FindProductType.findCate:
        if (selectGroup.value != null) {
          Get.toNamed(Routes.findProductFilter, arguments: {
            Keys.id: id,
            Keys.parentID: selectGroup.value!.id,
            Keys.type: type
          })?.then((value) {
            if (value != null) {
              selectCate.value = value;
              if (selectSub.value != null) selectSub.value = null;
            }
          });
        } else {
          DialogCustom.showSnackBar(message: "Please select group");
        }

        break;
      case FindProductType.findSub:
        if (selectCate.value != null) {
          Get.toNamed(Routes.findProductFilter, arguments: {
            Keys.id: id,
            Keys.parentID: selectCate.value!.id,
            Keys.type: type
          })?.then((value) {
            if (value != null) {
              selectSub.value = value;
            }
          });
        } else {
          DialogCustom.showSnackBar(message: "Please select category");
        }
        break;
      default:
    }
  }

  void goToProductPage() {
    if (selectGroup.value != null &&
        selectCate.value != null &&
        selectSub.value != null) {
      Get.toNamed(Routes.product, arguments: {
        Keys.name: selectSub.value?.name,
        Keys.data: shopModel,
        Keys.settingID: selectSub.value?.id
      });
    } else {
      DialogCustom.showSnackBar(message: validateMessage());
    }
  }

  String validateMessage() {
    if (selectGroup.value == null) {
      return "Please select group";
    } else if (selectCate.value == null) {
      return "Please select category";
    } else {
      return "Please select subcategory";
    }
  }
}
