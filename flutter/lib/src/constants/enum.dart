import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

import 'export_constants.dart';

enum CheckPassword { none, pass, fail }

enum Numpad {
  num0,
  num1,
  num2,
  num3,
  num4,
  num5,
  num6,
  num7,
  num8,
  num9,
  space,
  delete
}

enum HomeMenu {
  timeAndLocation,
  calendar,
  roster,
  merchandising,
  sales,
  event,
  leave,
  overTime,
  survey
}

extension HomeMenuExtension on HomeMenu {
  String get code {
    switch (this) {
      case HomeMenu.timeAndLocation:
        return 'time_location';
      case HomeMenu.calendar:
        return 'calendar';
      case HomeMenu.roster:
        return 'roster_plan';
      case HomeMenu.merchandising:
        return 'merchandising';
      case HomeMenu.sales:
        return 'sales_report';
      case HomeMenu.event:
        return 'event_stock';
      case HomeMenu.leave:
        return 'leave_request';
      case HomeMenu.overTime:
        return 'overtime';
      case HomeMenu.survey:
        return 'survey';
      default:
        return 'Title is null';
    }
  }

  String get title {
    switch (this) {
      case HomeMenu.timeAndLocation:
        return Texts.checkInMenu;
      case HomeMenu.calendar:
        return Texts.calendarMenu;
      case HomeMenu.roster:
        return Texts.rosterPlanMenu;
      case HomeMenu.merchandising:
        return Texts.merchandisingMenu;
      case HomeMenu.sales:
        return Texts.salesReportMenu;
      case HomeMenu.event:
        return Texts.eventStockMenu;
      case HomeMenu.leave:
        return Texts.leaveRequestMenu;
      case HomeMenu.overTime:
        return Texts.overtimeMenu;
      case HomeMenu.survey:
        return Texts.surveyMenu;
      default:
        return 'Title is null';
    }
  }
}

enum CalendarStatus { workDay, leave, overTime, onTime, lated, pending, dayOff }

extension CalendarStatusExtension on CalendarStatus {
  Color get color {
    switch (this) {
      case CalendarStatus.workDay:
        return AppTheme.green2;
      case CalendarStatus.leave:
        return AppTheme.purple;
      case CalendarStatus.overTime:
        return AppTheme.redText;
      case CalendarStatus.onTime:
        return AppTheme.peach2;
      case CalendarStatus.lated:
        return AppTheme.redText;
      case CalendarStatus.pending:
        return AppTheme.purple;
      case CalendarStatus.dayOff:
        return AppTheme.redText;
      default:
        return AppTheme.greyText;
    }
  }

  String get title {
    switch (this) {
      case CalendarStatus.workDay:
        return Texts.workDay;
      case CalendarStatus.leave:
        return Texts.leave;
      case CalendarStatus.overTime:
        return Texts.overTime;
      case CalendarStatus.onTime:
        return Texts.onTime;
      case CalendarStatus.lated:
        return Texts.late;
      case CalendarStatus.pending:
        return Texts.pending;
      case CalendarStatus.dayOff:
        return Texts.dayOff;
      default:
        return 'Title is null';
    }
  }

  String get key {
    switch (this) {
      case CalendarStatus.workDay:
        return Keys.workDay;
      case CalendarStatus.leave:
        return Keys.leave;
      case CalendarStatus.overTime:
        return Keys.overTime;
      case CalendarStatus.onTime:
        return Keys.onTime;
      case CalendarStatus.lated:
        return Keys.late;
      case CalendarStatus.pending:
        return Keys.pending;
      case CalendarStatus.dayOff:
        return Keys.dayOff;
      default:
        return 'key is null';
    }
  }
}

enum RequestMethod { get, post, put, delete, postWithFile, patch }

enum Passcode { create, confirm, enter }

extension PasscodeExtension on Passcode {
  String get title {
    switch (this) {
      case Passcode.create:
        return Texts.createPinCode;
      case Passcode.confirm:
        return Texts.confirmPinCode;
      case Passcode.enter:
        return Texts.enterPinCode;
      default:
        return 'Title is null';
    }
  }
}

enum CheckInOut { checkIn, checkOut }

enum LeaveRequest { upcoming, pending, history, reject }

extension LeaveRequestExtension on LeaveRequest {
  String get title {
    switch (this) {
      case LeaveRequest.upcoming:
        return Texts.upcoming;
      case LeaveRequest.pending:
        return Texts.pending;
      case LeaveRequest.history:
        return Texts.history;
      case LeaveRequest.reject:
        return Texts.rejected;
      default:
        return 'Title is null';
    }
  }

  String get key {
    switch (this) {
      case LeaveRequest.upcoming:
        return Keys.upcoming;
      case LeaveRequest.pending:
        return Keys.pending;
      case LeaveRequest.history:
        return Keys.history;
      case LeaveRequest.reject:
        return Keys.reject;
      default:
        return 'key is null';
    }
  }
}

enum RosterPlan { currentRoster, pending, rejected }

extension RosterPlanExtension on RosterPlan {
  String get title {
    switch (this) {
      case RosterPlan.currentRoster:
        return Keys.currentRoster;
      case RosterPlan.pending:
        return Keys.pending;
      case RosterPlan.rejected:
        return Keys.rejected;
      default:
        return 'Title is null';
    }
  }
}

enum PageType { create, edit }

enum RosterPageType { createRoster, createDayOff }

enum CheckInPageType { checkIn, checkOut, pinPoint, trackRoute }

enum DayType { mon, tue, wed, thu, fri, sat, sun }

extension DayTypeExtension on DayType {
  String get key {
    switch (this) {
      case DayType.mon:
        return Keys.monday;
      case DayType.tue:
        return Keys.tuesday;
      case DayType.wed:
        return Keys.wednesday;
      case DayType.thu:
        return Keys.thursday;
      case DayType.fri:
        return Keys.friday;
      case DayType.sat:
        return Keys.saturday;
      case DayType.sun:
        return Keys.sunday;
      default:
        return 'Key is null';
    }
  }
}

enum Language { eng, th }

extension LabguageExtension on Language {
  String get title {
    switch (this) {
      case Language.eng:
        return Texts.eng;
      case Language.th:
        return Texts.th;
      default:
        return 'title is null';
    }
  }
}

enum TabbarType { upcoming, pending, history, reject }

extension TabbarTypeExtension on TabbarType {
  String get title {
    switch (this) {
      case TabbarType.upcoming:
        return Texts.upcoming;
      case TabbarType.pending:
        return Texts.pending;
      case TabbarType.history:
        return Texts.history;
      case TabbarType.reject:
        return Texts.rejected;
      default:
        return 'Title is null';
    }
  }

  String get key {
    switch (this) {
      case TabbarType.upcoming:
        return Keys.upcoming;
      case TabbarType.pending:
        return Keys.pending;
      case TabbarType.history:
        return Keys.history;
      case TabbarType.reject:
        return Keys.reject;
      default:
        return 'key is null';
    }
  }
}

enum TabbarTypeCheckIn { shop, workPlace }

extension TabbarTypeCheckInExtension on TabbarTypeCheckIn {
  String get title {
    switch (this) {
      case TabbarTypeCheckIn.shop:
        return Texts.shop;
      case TabbarTypeCheckIn.workPlace:
        return Texts.workPlace;

      default:
        return 'Title is null';
    }
  }
}

enum PriceTrackingType {
  singleCategoryProduct,
  eachCategoryProduct,
  noCategoryProduct
}

extension PriceTrackingTypeExtension on PriceTrackingType {
  String get key {
    switch (this) {
      case PriceTrackingType.singleCategoryProduct:
        return Keys.singleCategoryProduct;
      case PriceTrackingType.eachCategoryProduct:
        return Keys.eachCategoryProduct;
      case PriceTrackingType.noCategoryProduct:
        return Keys.noCategoryProduct;
      default:
        return 'Key is null';
    }
  }
}

enum FindProductType { findGroup, findCate, findSub, findBarcode }

enum ProductTabbarType { osa, priceTracking, sku }

extension ProductTabbarTypeExtension on ProductTabbarType {
  String get title {
    switch (this) {
      case ProductTabbarType.osa:
        return Texts.osa;
      case ProductTabbarType.priceTracking:
        return Texts.priceTracking;
      case ProductTabbarType.sku:
        return Texts.sku;
      default:
        return 'Title is null';
    }
  }
}
