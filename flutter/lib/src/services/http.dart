import 'dart:convert';
import 'dart:async';
import 'dart:developer';

import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/constants/export_constants.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/export_models.dart';

class HttpService {
  Duration timeOut = const Duration(seconds: 120);
  Duration timeOutFileUplaod = const Duration(seconds: 240);
  var client = http.Client();

  Map<String, String> get headers {
    var header = {
      'Content-type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
    if (UserConfig.session != null) {
      header.addAll({
        'Authorization': 'Bearer ${UserConfig.session!.access}',
      });
    }
    debugPrint("header: $header");
    return header;
  }

  Future<http.Response> makeRequest(RequestMethod method, String url,
      {Object? data,
      bool isMocki = false,
      Map<String, dynamic>? queryParameters}) async {
    Uri uri = Uri.https(
        baseUrl,
        (isMocki ? ApiUrl.backendMocki : ApiUrl.backend) + url,
        queryParameters);
    String body = jsonEncode(data);
    late Future<http.Response> httpRequest;

    try {
      switch (method) {
        case RequestMethod.get:
          httpRequest = client.get(uri, headers: headers).timeout(timeOut);
          break;
        case RequestMethod.post:
          httpRequest =
              client.post(uri, headers: headers, body: body).timeout(timeOut);
          break;
        case RequestMethod.patch:
          httpRequest =
              client.patch(uri, headers: headers, body: body).timeout(timeOut);
          break;
        case RequestMethod.put:
          httpRequest =
              client.put(uri, headers: headers, body: body).timeout(timeOut);
          break;
        case RequestMethod.delete:
          httpRequest = client.delete(uri, headers: headers).timeout(timeOut);
          break;
        default:
          httpRequest = client
              .get(uri, headers: headers)
              .timeout(const Duration(seconds: 120));
          break;
      }
      debugPrint("url: $uri");
      debugPrint("body: $body");
      return httpRequest;
    } catch (e) {
      debugPrint("makeRequest: " + e.toString());
      throw e.toString();
    }
  }

  Future<http.Response> makeRequestWithFile(RequestMethod method, String url,
      {required Map<String, String>? data,
      required List<File>? fileList,
      required String fileKey,
      bool isMocki = false,
      Map<String, dynamic>? queryParameters}) async {
    Uri uri = Uri.https(
        baseUrl,
        (isMocki ? ApiUrl.backendMocki : ApiUrl.backend) + url,
        queryParameters);
    String body = jsonEncode(data);
    late Future<http.Response> httpRequest;

    try {
      var request = http.MultipartRequest("POST", uri);
      request.fields.addAll(data as Map<String, String>);
      if (fileList!.isNotEmpty) {
        await Future.forEach(fileList, (File element) async {
          request.files
              .add(await http.MultipartFile.fromPath(fileKey, element.path));
        });
      }
      request.headers.addAll(headers);
      var streamRequest = await request.send().timeout(timeOutFileUplaod);
      debugPrint("request: ${request.fields} ${request.files}");
      httpRequest = http.Response.fromStream(streamRequest);
      debugPrint("body: $body");
      return httpRequest;
    } catch (e) {
      debugPrint("makeRequest: " + e.toString());
      throw e.toString();
    }
  }

  void close() {
    debugPrint("Close Request");
    client.close();
  }

  Future<dynamic> checkResponse(Future<http.Response> httpRequest) async {
    try {
      var response = await httpRequest;
      log("response ${utf8.decode(response.bodyBytes)}");
      debugPrint("responseCode ${response.statusCode}");

      switch (response.statusCode) {
        case 200:
          var jsonString = jsonDecode(utf8.decode(response.bodyBytes));
          return jsonString;
        case 201:
          var jsonString = jsonDecode(utf8.decode(response.bodyBytes));
          return jsonString;
        case 204:
          return;
        default:
          String textError = "";
          try {
            var jsonString = jsonDecode(response.body);
            DetailModel detailModel = DetailModel.fromJson(jsonString);
            textError = errorStatus(response.statusCode, detailModel.detail);
          } catch (e) {
            try {
              var jsonString = jsonDecode(response.body);
              ErrorModel errorModel = ErrorModel.fromJson(jsonString);
              textError = errorStatus(response.statusCode, errorModel.error);
            } catch (e) {
              try {
                textError = errorStatus(response.statusCode, response.body);
              } catch (e) {
                textError =
                    errorStatus(response.statusCode, response.reasonPhrase);
              }
            }
          }
          debugPrint("checkResponse: " + textError);
          throw textError;
      }
    } catch (e, stacktrace) {
      if (e is SocketException) {
        debugPrint("SocketException: $e");
        rethrow;
      } else if (e is TimeoutException) {
        debugPrint("TimeOutException: $e");
        rethrow;
      } else {
        debugPrint("Error: $e $stacktrace");
        rethrow;
      }
    }
  }

  String errorStatus(int resCode, String? text) {
    return kDebugMode
        ? "StatusCode: $resCode\n${text ?? defualtText(resCode)}"
        : "Error: ${text ?? defualtText(resCode)}";
  }

  String defualtText(int statusCode) {
    switch (statusCode) {
      case 200:
        return 'The request has been received.';

      case 201:
        return 'The request has been created.';

      case 202:
        return 'The request has been accepted.';

      case 204:
        return 'The response had no content.';

      case 400:
        return 'The request has an invalid format.';

      case 401:
        return 'Not found user please check your username and password.';

      case 403:
        return 'You don\'t have permission to do this.';

      case 404:
        return 'The entity of you request is not found.';

      case 409:
        return 'There is a conflicting request.';

      default:
        return 'Server error.';
    }
  }
}

class DataPagination {
  dynamic data;
  bool hasMore;

  DataPagination({required this.data, required this.hasMore});
}
