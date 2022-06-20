import 'dart:async';

import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/services/merchandising.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class ProductDateController extends GetxController
    with StateMixin<List<ProductDateModel>> {
  BuildContext context;
  ProductModel productModel;
  ProductTabbarType type;
  ProductDateController(this.context,
      {required this.productModel, required this.type});

  final showSearch = false.obs;
  final tabList = [true.obs, false.obs, false.obs];
  final isSelected = 0.obs;
  final ProductTabbarType _type = ProductTabbarType.osa;
  late MerchandisingService merchandisingService;
  final startDate = Rx<DateTime?>(DateTime.now());
  final endDate = Rx<DateTime?>(DateTime.now());

  int page = 1;
  bool hasMore = true;
  final isLoading = false.obs;
  final List<ProductDateModel> _productDateModelList = [];
  final ScrollController listViewCtrl = ScrollController();

  @override
  void onInit() {
    merchandisingService = MerchandisingService();
    callAllAPI();
    listViewCtrl.addListener(loadMore);
    super.onInit();
  }

  @override
  void onClose() {
    listViewCtrl.removeListener(loadMore);
    listViewCtrl.dispose();
    merchandisingService.close();
    super.onClose();
  }

  Future callAllAPI() async {
    LoadingCustom.showOverlay(context);
    await callAPIProductFilterList();
    LoadingCustom.hideOverlay(context);
  }

  Future refreshData() async {
    clearPage();
    await callAllAPI();
  }

  void clearPage() {
    page = 1;
    _productDateModelList.clear();
    hasMore = true;
  }

  void loadMore() {
    if (hasMore &&
        listViewCtrl.position.maxScrollExtent == listViewCtrl.position.pixels &&
        !isLoading.value) {
      callAPIProductFilterList();
    }
  }

  void onClickNewDate() {
    Get.toNamed(Routes.productPromotion,
            arguments: {Keys.type: _type, Keys.pageType: PageType.create})!
        .then((value) => onBackRefresh(
            function: () {
              refreshData();
            },
            value: value));
  }

  void onClickEdit(int id) {
    Get.toNamed(Routes.productPromotion, arguments: {
      Keys.type: _type,
      Keys.pageType: PageType.edit,
      Keys.id: id
    })!
        .then((value) => onBackRefresh(
            function: () {
              refreshData();
            },
            value: value));
  }

  Future callAPIProductFilterList() async {
    isLoading.value = true;
    page == 1
        ? change([], status: RxStatus.loading())
        : change(_productDateModelList, status: RxStatus.loadingMore());
    try {
      await merchandisingService
          .getPriceTrackingList(
              page: page,
              productID: productModel.merchandizer_product,
              startDate: DateTimeService.getStringTimeServer(startDate.value!),
              endDate: DateTimeService.getStringTimeServer(endDate.value!))
          .then((value) async {
        if (value.data.isNotEmpty) {
          page++;
          _productDateModelList.addAll(value.data);
          hasMore = value.hasMore;
          change(_productDateModelList, status: RxStatus.success());
        } else {
          hasMore = false;
          change(_productDateModelList, status: RxStatus.empty());
        }
      });
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      debugPrint("$e");
      change([], status: RxStatus.error('Error: $e'));
    }
  }

  void onClickSelectDate(bool isStartDate, DateTime date) {
    if (isStartDate) {
      if (endDate.value != null) {
        endDate.value = null;
      }
      startDate.value = DateTimeService.setDate(
          isStartDate, date, startDate.value, endDate.value);
    } else {
      endDate.value = DateTimeService.setDate(
          isStartDate, date, startDate.value, endDate.value);
      refreshData();
    }
  }
}
