import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/models/export_models.dart';
import 'package:ahead_adecco/src/models/merchandising/FindProductModel.dart';
import 'package:ahead_adecco/src/services/export_services.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';

class MerchandisingService extends HttpService {
  Future postPriceTracking(Map<String, Object> data) async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.post, ApiUrl.priceTracking, data: data);
      await checkResponse(httpRequest);
    } catch (e) {
      debugPrint("Price Tracking Error: $e");
      rethrow;
    }
  }

  Future patchPriceTracking(Map<String, Object> data, int id) async {
    try {
      var httpRequest = makeRequest(
          RequestMethod.patch, ApiUrl.priceTracking + "$id/",
          data: data);
      await checkResponse(httpRequest);
    } catch (e) {
      debugPrint("Price Tracking Error: $e");
      rethrow;
    }
  }

  Future priceTrackingEdit(int id) async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.get, ApiUrl.priceTracking + "$id/");
      var jsonString = await checkResponse(httpRequest);
      PriceTrackingEditModel _priceTrackingEditModel =
          PriceTrackingEditModel.fromJson(jsonString);
      return _priceTrackingEditModel;
    } catch (e) {
      debugPrint("Edit OT Error: $e");
      rethrow;
    }
  }

  Future<DataPagination> getShopList(
      {required String textSearch, int? page}) async {
    try {
      Map<String, String> param = {
        Keys.project: UserConfig.getProjectID().toString(),
      };
      if (textSearch.isNotEmpty) {
        param.addAll({"shop_name": textSearch});
      }
      if (page != null) {
        param.addAll({"page": "$page"});
      }
      var httpRequest = makeRequest(RequestMethod.get, ApiUrl.shopList,
          queryParameters: param);
      var jsonString = await checkResponse(httpRequest);
      DataListModel dataListModel = DataListModel.fromJson(jsonString);
      List<ShopModel> shopList = [];
      for (var item in dataListModel.results) {
        shopList.add(ShopModel.fromJson(item));
      }

      DataPagination _data = DataPagination(
          data: shopList, hasMore: dataListModel.next == null ? false : true);
      return _data;
    } catch (e) {
      rethrow;
    }
  }

  Future<DataPagination> getFindProductList(
      {required String textSearch,
      int? page,
      required FindProductType type,
      required int merchandizerID,
      int? parent}) async {
    try {
      Map<String, String> param = {};
      switch (type) {
        case FindProductType.findGroup:
          param.addAll({
            "parent_only": "true",
            "merchandizer": "$merchandizerID",
            "type": "product"
          });
          break;
        case FindProductType.findCate:
          param.addAll({
            "merchandizer": "$merchandizerID",
            "type": "product",
            "parent": "$parent"
          });
          break;
        case FindProductType.findSub:
          param.addAll({
            "merchandizer": "$merchandizerID",
            "type": "product",
            "parent": "$parent"
          });
          break;
        case FindProductType.findBarcode:
          break;
        default:
      }
      var httpRequest = makeRequest(RequestMethod.get, ApiUrl.findProduct,
          queryParameters: param);
      var jsonString = await checkResponse(httpRequest);
      DataListModel dataListModel = DataListModel.fromJson(jsonString);
      List<FindProductModel> findProductList = [];
      for (var item in dataListModel.results) {
        findProductList.add(FindProductModel.fromJson(item));
      }

      DataPagination _data = DataPagination(
          data: findProductList,
          hasMore: dataListModel.next == null ? false : true);
      return _data;
    } catch (e) {
      rethrow;
    }
  }

  Future<DataPagination> getProductList(
      {required String textSearch,
      int? page,
      required int merchandizerID,
      required int settingID}) async {
    try {
      Map<String, String> param = {
        "descendants": "true",
        "merchandizer": "$merchandizerID",
        "setting": "$settingID",
        "query": "product"
      };
      var httpRequest = makeRequest(RequestMethod.get, ApiUrl.productList,
          queryParameters: param);
      var jsonString = await checkResponse(httpRequest);
      DataListModel dataListModel = DataListModel.fromJson(jsonString);
      List<ProductModel> productList = [];
      for (var item in dataListModel.results) {
        productList.add(ProductModel.fromJson(item));
      }

      DataPagination _data = DataPagination(
          data: productList,
          hasMore: dataListModel.next == null ? false : true);
      return _data;
    } catch (e) {
      rethrow;
    }
  }

  Future<DataPagination> getPriceTrackingList(
      {int? page,
      required int productID,
      required String startDate,
      required String endDate}) async {
    try {
      Map<String, String> param = {
        "merchandizer_product": "$productID",
        "date_range_after": startDate,
        "date_range_before": endDate
      };
      var httpRequest = makeRequest(RequestMethod.get, ApiUrl.priceTracking,
          queryParameters: param);
      var jsonString = await checkResponse(httpRequest);
      DataListModel dataListModel = DataListModel.fromJson(jsonString);
      List<ProductDateModel> productDateList = [];
      for (var item in dataListModel.results) {
        productDateList.add(ProductDateModel.fromJson(item));
      }

      DataPagination _data = DataPagination(
          data: productDateList,
          hasMore: dataListModel.next == null ? false : true);
      return _data;
    } catch (e) {
      rethrow;
    }
  }

  Future cancelNewDate(int id) async {
    try {
      var httpRequest =
          makeRequest(RequestMethod.delete, ApiUrl.priceTracking + "$id/");
      await checkResponse(httpRequest);
    } catch (e) {
      debugPrint("Cancel New Date Error: $e");
      rethrow;
    }
  }

  Future<List<DropDownModel>> reasonDropDown() async {
    try {
      var param = {
        "type": "price_tracking_reason",
        "project": UserConfig.getProjectID().toString()
      };
      var httpRequest = makeRequest(RequestMethod.get, ApiUrl.dropDown,
          queryParameters: param);
      var jsonString = await checkResponse(httpRequest);
      List<DropDownModel> _pinPointList = [];
      for (var item in jsonString['price_tracking_reason'] as List) {
        _pinPointList.add(DropDownModel.fromJson(item));
      }
      return _pinPointList;
    } catch (e) {
      debugPrint("Reason Error: $e");
      return [];
    }
  }
}
