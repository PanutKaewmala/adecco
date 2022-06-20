import 'dart:async';

import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/models/merchandising/FindProductModel.dart';
import 'package:ahead_adecco/src/services/merchandising.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class ProductController extends GetxController
    with StateMixin<List<ProductModel>> {
  BuildContext context;
  ShopModel shopModel;
  int setting;
  ProductController(this.context,
      {required this.shopModel, required this.setting});

  final showSearch = false.obs;
  TextEditingController textSearch = TextEditingController();
  Timer? _debounce;
  final tabList = [true.obs, false.obs, false.obs];
  final isSelected = 0.obs;
  ProductTabbarType _type = ProductTabbarType.osa;
  late MerchandisingService merchandisingService;

  int page = 1;
  bool hasMore = true;
  final isLoading = false.obs;
  final List<ProductModel> _productModelList = [];
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

  onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (textSearch.text.length > 2 || textSearch.text.isEmpty) refreshData();
    });
  }

  void onClickClear() {
    showSearch.value = !showSearch.value;
    if (!showSearch.value) {
      textSearch.clear();
      refreshData();
    }
  }

  void clearPage() {
    page = 1;
    _productModelList.clear();
    hasMore = true;
  }

  void loadMore() {
    if (hasMore &&
        listViewCtrl.position.maxScrollExtent == listViewCtrl.position.pixels &&
        !isLoading.value) {
      callAPIProductFilterList();
    }
  }

  void getBack(FindProductModel findProductModel) {
    Get.back(result: findProductModel);
  }

  Future callAPIProductFilterList() async {
    isLoading.value = true;
    page == 1
        ? change([], status: RxStatus.loading())
        : change(_productModelList, status: RxStatus.loadingMore());
    try {
      await merchandisingService
          .getProductList(
              textSearch: textSearch.text,
              page: page,
              merchandizerID: shopModel.id,
              settingID: setting)
          .then((value) async {
        if (value.data.isNotEmpty) {
          page++;
          _productModelList.addAll(value.data);
          hasMore = value.hasMore;
          change(_productModelList, status: RxStatus.success());
        } else {
          hasMore = false;
          change(_productModelList, status: RxStatus.empty());
        }
      });
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      debugPrint("$e");
      change([], status: RxStatus.error('Error: $e'));
    }
  }

  void onPressedTab(ProductTabbarType type) async {
    page = 1;
    _productModelList.clear();
    hasMore = true;
    isSelected.value = type.index;
    for (int i = 0; i < tabList.length; i++) {
      tabList[i].value = i == type.index;
    }
    switch (type) {
      case ProductTabbarType.osa:
        _type = ProductTabbarType.osa;
        break;
      case ProductTabbarType.priceTracking:
        _type = ProductTabbarType.priceTracking;
        break;
      case ProductTabbarType.sku:
        _type = ProductTabbarType.sku;
        break;
      default:
    }
    LoadingCustom.showOverlay(context);
    await callAPIProductFilterList();
    LoadingCustom.hideOverlay(context);
  }

  void goToProductDate(ProductModel productModel) {
    Get.toNamed(Routes.productDate,
        arguments: {Keys.type: _type, Keys.product: productModel});
  }
}
