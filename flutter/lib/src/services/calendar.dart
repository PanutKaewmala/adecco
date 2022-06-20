import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'http.dart';

class CalendarService extends HttpService {
  Future<List<CalendarDateModel>> calendar(Map<String, String> param) async {
    try {
      var httpRequest = makeRequest(RequestMethod.get, ApiUrl.calendar,
          queryParameters: param);
      var jsonString = await checkResponse(httpRequest);
      CalendarModel _calendar = CalendarModel.fromJson(jsonString);
      return _calendar.calendars;
    } catch (e) {
      debugPrint("calendar Error: $e");
      rethrow;
    }
  }
}
