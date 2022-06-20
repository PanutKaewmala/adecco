import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/services/leave_request.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class LeaveRequestController extends GetxController
    with StateMixin<List<LeaveRequestModel>> {
  BuildContext context;
  LeaveRequestController({required this.context}) : super();
  late LeaveRequestService leaveRequestService;
  final tabList = [true.obs, false.obs, false.obs];
  final isSelected = 0.obs;
  final leaveQuotaDetailList = <LeaveQuotaModel>[].obs;
  final ScrollController listViewCtrl = ScrollController();
  LeaveRequest _leaveRequest = LeaveRequest.upcoming;

  final total = 0.0.obs;
  final used = 0.0.obs;
  final remained = 0.0.obs;

  int page = 1;
  bool hasMore = true;
  final isLoading = false.obs;
  final List<LeaveRequestModel> _leaveRequestList = [];

  @override
  void onInit() {
    leaveRequestService = LeaveRequestService();
    callAllAPI();
    listViewCtrl.addListener(loadMore);
    super.onInit();
  }

  @override
  void onClose() {
    listViewCtrl.removeListener(loadMore);
    listViewCtrl.dispose();
    leaveRequestService.close();
    super.onClose();
  }

  Future callAllAPI() async {
    LoadingCustom.showOverlay(context);
    page = 1;
    _leaveRequestList.clear();
    hasMore = true;
    await Future.wait([
      callAPILeaveQuota(),
      callAPILeaveRequest(),
    ]);
    LoadingCustom.hideOverlay(context);
  }

  Future refreshData() async {
    await callAllAPI();
  }

  void loadMore() {
    if (hasMore &&
        listViewCtrl.position.maxScrollExtent == listViewCtrl.position.pixels &&
        !isLoading.value) {
      callAPILeaveRequest();
    }
  }

  void onPressedTab(LeaveRequest leaveRequest) async {
    page = 1;
    _leaveRequestList.clear();
    hasMore = true;
    isSelected.value = leaveRequest.index;
    for (int i = 0; i < tabList.length; i++) {
      tabList[i].value = i == leaveRequest.index;
    }
    switch (leaveRequest) {
      case LeaveRequest.upcoming:
        _leaveRequest = LeaveRequest.upcoming;
        break;
      case LeaveRequest.pending:
        _leaveRequest = LeaveRequest.pending;
        break;
      case LeaveRequest.history:
        _leaveRequest = LeaveRequest.history;
        break;
      default:
    }
    LoadingCustom.showOverlay(context);
    await callAPILeaveRequest();
    LoadingCustom.hideOverlay(context);
  }

  Future callAPILeaveQuota() async {
    leaveQuotaDetailList.clear();
    try {
      await leaveRequestService.leaveQuotaDetail().then((value) async {
        if (value.isNotEmpty) {
          leaveQuotaDetailList.assignAll(value);
          for (var item in leaveQuotaDetailList) {
            total.value = total.value + item.total;
            used.value = used.value + item.used;
            remained.value = remained.value + item.remained;
          }
        }
      });
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future callAPILeaveRequest() async {
    isLoading.value = true;
    page == 1
        ? change([], status: RxStatus.loading())
        : change(_leaveRequestList, status: RxStatus.loadingMore());
    try {
      await leaveRequestService
          .leaveRequest(status: _leaveRequest.key, page: page)
          .then((value) async {
        if (value.data.isNotEmpty) {
          page++;
          _leaveRequestList.addAll(value.data);
          hasMore = value.hasMore;
          change(_leaveRequestList, status: RxStatus.success());
        } else {
          hasMore = false;
          change(_leaveRequestList, status: RxStatus.empty());
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
    double _percent =
        leaveQuotaDetailList.isNotEmpty ? (remained.value / total.value) : 0;
    if (_percent < 0) {
      _percent = 0;
    } else if (_percent > 1) {
      _percent = 1;
    }
    return _percent;
  }

  String getRemained() {
    if (leaveQuotaDetailList.isEmpty) {
      return "-";
    } else if (remained.value == 0.0) {
      return "0";
    } else {
      return remained.value.toInt().toString();
    }
  }

  void onClickAddRequest() {
    Get.toNamed(Routes.createLeave,
            arguments: {Keys.pageType: PageType.create})!
        .then((value) {
      onBackRefresh(
          function: () {
            onPressedTab(LeaveRequest.pending);
          },
          value: value != null ? value["value"] : value);
    });
  }

  void onClickLeave(LeaveRequestModel leaveRequest) {
    if (leaveRequest.status == LeaveRequest.pending.key ||
        leaveRequest.status == LeaveRequest.upcoming.key) {
      Get.toNamed(Routes.createLeave, arguments: {
        Keys.pageType: PageType.edit,
        Keys.id: leaveRequest.leave_request_id
      })!
          .then((value) {
        onBackRefresh(
            function: () {
              onPressedTab(LeaveRequest.pending);
            },
            value: value != null ? value["value"] : value);
      });
    }
  }
}
