import 'dart:async';

import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/services/merchandising.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class SelectShopController extends GetxController
    with StateMixin<List<ShopModel>> {
  BuildContext context;
  SelectShopController(this.context);

  final showSearch = false.obs;
  TextEditingController textSearch = TextEditingController();
  Timer? _debounce;
  late MerchandisingService merchandisingService;

  int page = 1;
  bool hasMore = true;
  final isLoading = false.obs;
  final List<ShopModel> _shopModelList = [];
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
    _debounce?.cancel();
    super.onClose();
  }

  Future callAllAPI() async {
    LoadingCustom.showOverlay(context);
    await callAPIShopList();
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
    _shopModelList.clear();
    hasMore = true;
  }

  void loadMore() {
    if (hasMore &&
        listViewCtrl.position.maxScrollExtent == listViewCtrl.position.pixels &&
        !isLoading.value) {
      callAPIShopList();
    }
  }

  void goToFindingProduct(ShopModel shopModel) {
    Get.toNamed(Routes.findProduct, arguments: {Keys.data: shopModel});
  }

  Future callAPIShopList() async {
    isLoading.value = true;
    page == 1
        ? change([], status: RxStatus.loading())
        : change(_shopModelList, status: RxStatus.loadingMore());
    try {
      await merchandisingService
          .getShopList(textSearch: textSearch.text, page: page)
          .then((value) async {
        if (value.data.isNotEmpty) {
          page++;
          _shopModelList.addAll(value.data);
          hasMore = value.hasMore;
          change(_shopModelList, status: RxStatus.success());
        } else {
          hasMore = false;
          change(_shopModelList, status: RxStatus.empty());
        }
      });
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      debugPrint("$e");
      change([], status: RxStatus.error('Error: $e'));
    }
  }
}
