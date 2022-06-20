import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/services/overtime.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class OTRequestController extends GetxController
    with StateMixin<List<OverTimeModel>> {
  BuildContext context;
  OTRequestController({required this.context}) : super();
  late OvertimeService overtimeService;
  final tabList = [true.obs, false.obs, false.obs];
  final isSelected = 0.obs;
  final overTimeQuotaModel = Rx<OverTimeQuotaModel?>(null);
  final ScrollController listViewCtrl = ScrollController();
  TabbarType _leaveRequest = TabbarType.upcoming;

  int page = 1;
  bool hasMore = true;
  final isLoading = false.obs;
  final List<OverTimeModel> _overTimeList = [];

  @override
  void onInit() {
    overtimeService = OvertimeService();
    listViewCtrl.addListener(loadMore);
    callAllAPI();
    super.onInit();
  }

  @override
  void onClose() {
    listViewCtrl.removeListener(loadMore);
    listViewCtrl.dispose();
    overtimeService.close();
    super.onClose();
  }

  Future callAllAPI() async {
    clearPage();
    LoadingCustom.showOverlay(context);
    await Future.wait([
      callAPIOvertimeQuota(),
      callAPIOvertime(),
    ]);
    LoadingCustom.hideOverlay(context);
  }

  Future refreshData() async {
    clearPage();
    await callAllAPI();
  }

  void clearPage() {
    page = 1;
    _overTimeList.clear();
    hasMore = true;
  }

  void loadMore() {
    if (hasMore &&
        listViewCtrl.position.maxScrollExtent == listViewCtrl.position.pixels &&
        !isLoading.value) {
      callAPIOvertime();
    }
  }

  void onPressedTab(TabbarType otRequest) async {
    clearPage();
    isSelected.value = otRequest.index;
    for (int i = 0; i < tabList.length; i++) {
      tabList[i].value = i == otRequest.index;
    }
    switch (otRequest) {
      case TabbarType.upcoming:
        _leaveRequest = TabbarType.upcoming;
        break;
      case TabbarType.pending:
        _leaveRequest = TabbarType.pending;
        break;
      case TabbarType.history:
        _leaveRequest = TabbarType.history;
        break;
      default:
    }
    LoadingCustom.showOverlay(context);
    await refreshData();
    LoadingCustom.hideOverlay(context);
  }

  Future callAPIOvertimeQuota() async {
    try {
      await overtimeService.getOvertimeQuota().then((value) async {
        debugPrint("quota $value");
        overTimeQuotaModel.value = value;
      });
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future callAPIOvertime() async {
    isLoading.value = true;
    page == 1
        ? change([], status: RxStatus.loading())
        : change(_overTimeList, status: RxStatus.loadingMore());
    try {
      await overtimeService
          .getOvertime(status: _leaveRequest.key, page: page)
          .then((value) async {
        if (value.data.isNotEmpty) {
          page++;
          _overTimeList.addAll(value.data);
          hasMore = value.hasMore;
          change(_overTimeList, status: RxStatus.success());
        } else {
          hasMore = false;
          change(_overTimeList, status: RxStatus.empty());
        }
      });
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      debugPrint("$e");
      change([], status: RxStatus.error('Error: $e'));
    }
  }

  double getPrecent() {
    double _percent = overTimeQuotaModel.value != null
        ? (overTimeQuotaModel.value!.ot_quota_used /
            overTimeQuotaModel.value!.ot_quota)
        : 0;
    if (_percent < 0) {
      _percent = 0;
    } else if (_percent > 1) {
      _percent = 1;
    }
    return _percent;
  }

  String getRemained() {
    if (overTimeQuotaModel.value == null) {
      return "-";
    } else if (overTimeQuotaModel.value!.ot_quota_used < 0) {
      return "0";
    } else {
      return overTimeQuotaModel.value!.ot_quota_used.toInt().toString();
    }
  }

  void onClickAddRequest() {
    Get.toNamed(Routes.createOT, arguments: {Keys.pageType: PageType.create})!
        .then((value) {
      onBackRefresh(
          function: () {
            onPressedTab(TabbarType.pending);
          },
          value: value);
    });
  }

  void onClickOT(OverTimeModel overTimeModel) {
    if (overTimeModel.status == LeaveRequest.pending.key) {
      Get.toNamed(Routes.createOT, arguments: {
        Keys.pageType: PageType.edit,
        Keys.overTime: overTimeModel
      })!
          .then((value) {
        onBackRefresh(
            function: () {
              onPressedTab(TabbarType.pending);
            },
            value: value);
      });
    }
  }
}
