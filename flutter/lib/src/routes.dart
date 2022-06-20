import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/pages/export_page.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class Routes {
  static const home = '/home';
  static const login = '/login';
  static const createPassword = '/create_password';
  static const pincode = '/pincode';
  static const forgotPassword = '/forgot_password';
  static const otpVerification = '/otp_verification';
  static const checkIn = '/check_in';
  static const checkInMap = '/check_in_map';
  static const history = '/history';
  static const historyDetail = '/history_detail';
  static const calendar = '/calendar';
  static const createTask = '/create_task';
  static const createLeave = '/create_leave';
  static const leaveRequest = '/leave_request';
  static const rosterPlan = '/roster_plan';
  static const createRoster = '/create_roster';
  static const createDayOff = '/create_day_off';
  static const previewRoster = '/preview_roster';
  static const editRosterShift = '/edit_roster_shift';
  static const setting = '/setting';
  static const adjustRequest = '/adjust_request';
  static const createPinPoint = '/create_pin_point';
  static const otRequest = '/ot_request';
  static const createOT = '/create_ot';
  static const historyPinPoint = '/history_pin_point';
  static const selectShop = '/select_shop';
  static const findProduct = '/find_product';
  static const findProductFilter = '/find_product_filter';
  static const product = '/product';
  static const productDate = '/product_date';
  static const productPromotion = '/product_promotion';
  static const barcodeScan = '/barcode_scan';
  static const checkInLocation = '/check_in_location';

  static List<GetPage<dynamic>>? getAll() => _route;

  static final List<GetPage<dynamic>>? _route = [
    GetPage(
      name: home,
      page: () => const HomePage(),
    ),
    GetPage(
        name: login,
        page: () => const LoginPage(),
        transition: Transition.fadeIn),
    GetPage(
        name: createPassword,
        page: () => const CreatePasswordPage(),
        transition: Transition.fadeIn),
    GetPage(name: pincode, page: () => const PincodePage()),
    GetPage(
        name: forgotPassword,
        page: () => const ForgotPasswordPage(),
        transition: Transition.fadeIn),
    GetPage(
      name: otpVerification,
      page: () => OTPVerificationPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: checkIn,
      page: () => CheckInPage(),
    ),
    GetPage(
      name: checkInMap,
      page: () => CheckInMapPage(),
    ),
    GetPage(
      name: history,
      page: () => const HistoryPage(),
    ),
    GetPage(
      name: historyDetail,
      page: () => HistoryDetailPage(),
    ),
    GetPage(
      name: calendar,
      page: () => const CalendarPage(),
    ),
    GetPage(
      name: createTask,
      page: () => const CreateTaskPage(),
    ),
    GetPage(
      name: createLeave,
      page: () => CreateLeavePage(),
    ),
    GetPage(
      name: leaveRequest,
      page: () => const LeaveRequestPage(),
    ),
    GetPage(
      name: rosterPlan,
      page: () => const RosterPlanPage(),
    ),
    GetPage(
      name: createRoster,
      page: () => CreateRosterPage(),
    ),
    GetPage(
      name: createDayOff,
      page: () => CreateDayOffPage(),
    ),
    GetPage(
      name: previewRoster,
      page: () => PreviewRosterPage(),
    ),
    GetPage(
      name: editRosterShift,
      page: () => EditRosterShift(),
    ),
    GetPage(
      name: setting,
      page: () => const SettingPage(),
    ),
    GetPage(
      name: adjustRequest,
      page: () => AdjustRequestPage(),
    ),
    GetPage(
      name: createPinPoint,
      page: () => CreatePinPoint(),
    ),
    GetPage(
      name: otRequest,
      page: () => const OTRequestPage(),
    ),
    GetPage(
      name: createOT,
      page: () => CreateOTRequest(),
    ),
    GetPage(
      name: historyPinPoint,
      page: () => const HistoryDetailPinPointPage(),
    ),
    GetPage(
      name: selectShop,
      page: () => const SelectShopPage(),
    ),
    GetPage(
      name: findProduct,
      page: () => FindProductPage(),
    ),
    GetPage(
      name: product,
      page: () => ProductPage(),
    ),
    GetPage(
      name: productDate,
      page: () => ProductDatePage(),
    ),
    GetPage(
      name: productPromotion,
      page: () => ProductPromotionPage(),
    ),
    GetPage(
      name: barcodeScan,
      page: () => const BarcodeScanPage(),
    ),
    GetPage(
      name: findProductFilter,
      page: () => FindProductFilterPage(),
    ),
    GetPage(
      name: checkInLocation,
      page: () => CheckInLocationPage(),
    ),
  ];
}
