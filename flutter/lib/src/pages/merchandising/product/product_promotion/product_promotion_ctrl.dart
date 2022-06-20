import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/pages/merchandising/product/product_promotion/product_promotion_text_ctrl.dart';
import 'package:ahead_adecco/src/services/merchandising.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class ProductPromotionController extends GetxController with StateMixin {
  int? id;
  int merchandizerProductID;
  final PageType? pageType;
  ProductTabbarType type;
  BuildContext context;
  ProductPromotionController(this.context,
      {this.id,
      required this.type,
      this.pageType,
      required this.merchandizerProductID});

  late MerchandisingService merchandisingService;

  final selectedType = PriceTrackingType.singleCategoryProduct.obs;
  List<int> selectedList = [0, 1, 2];
  final date = Rx<DateTime?>(DateTime.now());
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);
  final buySelected = 2.obs;
  List<int> buyList = [0, 1];
  Rx<DropDownModel?> reason = Rx(null);
  List<String> reasonStringList = [];
  List<DropDownModel> reasonDropDownList = [];
  bool? validation;
  final disableButton = true.obs;

  ProductPromotionTextController textController =
      ProductPromotionTextController();

  PriceTrackingEditModel? priceTrackingEditModel;

  @override
  void onInit() {
    merchandisingService = MerchandisingService();
    callAllAPI();
    super.onInit();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  Future callAllAPI() async {
    change(null, status: RxStatus.loading());
    try {
      await callAPIReasonDropdown();
      if (pageType == PageType.edit) {
        await callAPIPriceTrackingDetail();
        disableButton.value = enableButton();
      } else {
        disableButton.value = false;
      }
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error());
    }
  }

  bool onSelectSinglePromotion(int index) {
    return buySelected.value == index ? true : false;
  }

  void onSelectPromotion(PriceTrackingType type) {
    textController.clearAll();
    buySelected.value = 3;
    selectedType.value = type;
  }

  void onSelectBuy(int index) {
    textController.buy.clear();
    textController.free.clear();
    buySelected.value = index;
  }

  void onClickSelectReason() {
    showCupertinoStringPicker(context, Texts.plsSelectReason,
        stringList: reasonStringList,
        selected: reason.value?.label, onPressed: (index) {
      reason.value = reasonDropDownList[index];
    });
  }

  Future callAPIPriceTrackingDetail() async {
    try {
      await merchandisingService.priceTrackingEdit(id!).then((value) async {
        priceTrackingEditModel = value;
      });
      await setUpEditData();
    } catch (e) {
      rethrow;
    }
  }

  Future callAPICreatePriceTracking() async {
    LoadingCustom.showOverlay(context);
    try {
      var data = {
        "merchandizer_product": "$merchandizerProductID",
        "date": DateTimeService.getStringTimeServer(date.value!),
        "normal_price": textController.normalPrice.text.replaceAll(',', ''),
        "type": selectedType.value.key,
        "additional_note": textController.additionNote.text
      };

      if (selectedType.value == PriceTrackingType.singleCategoryProduct ||
          selectedType.value == PriceTrackingType.eachCategoryProduct) {
        if (selectedType.value == PriceTrackingType.singleCategoryProduct) {
          data.addAll({
            "promotion_price":
                textController.normalPrice.text.replaceAll(',', ''),
          });
          if (buySelected.value == 0) {
            data.addAll({
              "buy_free": textController.buy.text,
              "buy_free_percentage": textController.free.text,
            });
          } else if (buySelected.value == 1) {
            data.addAll({
              "buy_off": textController.buy.text,
              "buy_off_percentage": textController.free.text,
            });
          }
        } else {
          data.addAll({
            "promotion_name": textController.productName.text,
          });
        }
        data.addAll({
          "start_date": DateTimeService.getStringTimeServer(startDate.value!),
          "end_date": DateTimeService.getStringTimeServer(endDate.value!)
        });
      }

      if (pageType == PageType.create) {
        await merchandisingService.postPriceTracking(data);
      } else {
        await merchandisingService.patchPriceTracking(data, id!);
      }

      LoadingCustom.hideOverlay(context);
      DialogCustom.showBasicAlert(Texts.saveSuccess,
          onPressed: () => Get.back(result: true));
    } catch (e) {
      LoadingCustom.hideOverlay(context);
      DialogCustom.showBasicAlert("$e");
    }
  }

  void onClickCancel() async {
    DialogCustom.showBasicAlertOkCancel(Texts.askCancelRequest,
        onPressed: (() async {
      Get.back();
      await callAPICancelNewDate();
    }));
  }

  Future callAPICancelNewDate() async {
    LoadingCustom.showOverlay(context);
    try {
      await merchandisingService.cancelNewDate(id!).then((value) async {
        LoadingCustom.hideOverlay(context);
      });
      DialogCustom.showBasicAlert(Texts.saveSuccess,
          onPressed: () => Get.back(result: true));
    } catch (e) {
      LoadingCustom.hideOverlay(context);
      DialogCustom.showBasicAlert("$e");
    }
  }

  void onClickCreate() {
    checkValidate();
  }

  void checkValidate() {
    String message = "";

    Get.focusScope!.unfocus();

    switch (selectedType.value) {
      case PriceTrackingType.singleCategoryProduct:
        if (startDate.value == null || endDate.value == null) {
          message = Texts.plsSelectStartEndTime;
        }

        if (buySelected.value == 2) {
          message = Texts.plsAddBuy;
        }
        validation = textController.isDataValidSingleProduct();

        break;
      case PriceTrackingType.eachCategoryProduct:
        if (startDate.value == null || endDate.value == null) {
          message = Texts.plsSelectStartEndTime;
        }
        validation = textController.isDataValidEachProduct();

        break;
      case PriceTrackingType.noCategoryProduct:
        if (reason.value == null) {
          message = Texts.plsSelectReason;
        }
        break;
      default:
    }

    if (date.value == null) {
      message = Texts.plsSelectDate;
    }

    if (message.isEmpty) {
      if ((validation ?? false)) {
        callAPICreatePriceTracking();
      }
    } else {
      DialogCustom.showSnackBar(title: Texts.alert, message: message);
    }
  }

  bool enableButton() {
    return priceTrackingEditModel == null;
  }

  Future setUpEditData() async {
    try {
      date.value = DateTimeService.timeServerToDateTime(
          priceTrackingEditModel!.start_date);
      textController.normalPrice.text =
          priceTrackingEditModel!.normal_price.toString();
      selectedType.value = checkPriceTrackingType(priceTrackingEditModel!.type);
      textController.additionNote.text =
          priceTrackingEditModel?.additional_note ?? "";

      if (priceTrackingEditModel!.type ==
              PriceTrackingType.singleCategoryProduct.key ||
          priceTrackingEditModel!.type ==
              PriceTrackingType.eachCategoryProduct.key) {
        startDate.value = DateTimeService.timeServerToDateTime(
            priceTrackingEditModel!.start_date);
        endDate.value = DateTimeService.timeServerToDateTime(
            priceTrackingEditModel!.end_date);

        if (priceTrackingEditModel!.type ==
            PriceTrackingType.singleCategoryProduct.key) {
          textController.promotionPrice.text =
              priceTrackingEditModel!.promotion_price.toString();

          if (priceTrackingEditModel!.buy_free != null) {
            buySelected.value = 0;
            textController.buy.text =
                priceTrackingEditModel!.buy_free.toString();
            textController.free.text =
                priceTrackingEditModel!.buy_free_percentage.toString();
          } else if (priceTrackingEditModel!.buy_off != null) {
            buySelected.value = 1;
            textController.buy.text =
                priceTrackingEditModel!.buy_off.toString();
            textController.free.text =
                priceTrackingEditModel!.buy_off_percentage.toString();
          }
        } else {
          textController.productName.text =
              priceTrackingEditModel!.promotion_name.toString();
        }
      } else if (priceTrackingEditModel!.type ==
          PriceTrackingType.noCategoryProduct.key) {
        reason.value = reasonDropDownList.singleWhere(
            (element) => element.value == priceTrackingEditModel!.reason);
      }
    } catch (e) {
      rethrow;
    }
  }

  PriceTrackingType checkPriceTrackingType(String type) {
    switch (type) {
      case Keys.singleCategoryProduct:
        return PriceTrackingType.singleCategoryProduct;
      case Keys.eachCategoryProduct:
        return PriceTrackingType.eachCategoryProduct;
      case Keys.noCategoryProduct:
        return PriceTrackingType.noCategoryProduct;
      default:
        return PriceTrackingType.singleCategoryProduct;
    }
  }

  Future callAPIReasonDropdown() async {
    reasonDropDownList = await merchandisingService.reasonDropDown();
    reasonStringList = reasonDropDownList.map((item) => item.label).toList();
  }
}
