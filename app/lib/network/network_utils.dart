import 'dart:convert';
import 'dart:io';

import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/configs.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

Map<String, String> buildHeaderTokens(
    {bool isStripePayment = false, Map? request}) {
  Map<String, String> header = {
    HttpHeaders.cacheControlHeader: 'no-cache',
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Origin': '*',
    'Connection': 'keep-alive',
    'X-localization': appStore.selectedLanguageCode
  };
  if (appStore.isLoggedIn && isStripePayment) {
    //String formBody = Uri.encodeQueryComponent(jsonEncode(request));
    //List<int> bodyBytes = utf8.encode(formBody);

    header.putIfAbsent(HttpHeaders.contentTypeHeader,
        () => 'application/x-www-form-urlencoded');
    header.putIfAbsent(HttpHeaders.authorizationHeader,
        () => 'Bearer $getStringAsync("StripeKeyPayment")');
  } else {
    header.putIfAbsent(
        HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');
    header.putIfAbsent(
        HttpHeaders.authorizationHeader,
        () =>
            // 'Bearer 88|MTu1qyHx3zqM38FDVRPEF6pTeywO7XwMvPSERavw');
            'Bearer ${appStore.token}');
    header.putIfAbsent(
        HttpHeaders.acceptHeader, () => 'application/json; charset=utf-8');
  }
  log(jsonEncode(header));
  return header;
}

Uri buildBaseUrl(String endPoint) {
  Uri url = Uri.parse(endPoint);
  if (!endPoint.startsWith('http')) url = Uri.parse('$BASE_URL$endPoint');

  return url;
}

Future<Response> buildHttpResponse(String endPoint,
    {HttpMethod method = HttpMethod.GET,
    Map? request,
    bool isStripePayment = false}) async {
  if (await isNetworkAvailable()) {
    var headers = buildHeaderTokens(
      isStripePayment: isStripePayment,
      request: request,
    );
    Uri url = buildBaseUrl(endPoint);
    log(url);

    Response response;

    if (method == HttpMethod.POST) {
      log('Request: ${jsonEncode(request)}');
      response = await http
          .post(
        url,
        body: jsonEncode(request),
        headers: headers,
        encoding: isStripePayment ? Encoding.getByName("utf-8") : null,
      )
          .timeout(
        const Duration(seconds: 120),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
    } else if (method == HttpMethod.DELETE) {
      response = await delete(url, headers: headers).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
    } else if (method == HttpMethod.PUT) {
      response =
          await put(url, body: jsonEncode(request), headers: headers).timeout(
        const Duration(seconds: 120),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
    } else {
      response = await get(url, headers: headers).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
    }

    // log('Response (${method.name}) ${response.statusCode}: ${response.body}');
    // log(response.body);
    return response;
  } else {
    toast(errorInternetNotAvailable);
    appStore.setLoading(false);
    throw language.errorInternetNotAvailable;
  }
}

Future handleResponse(Response response, [bool? avoidTokenError]) async {
  log("status: ${appStore.token}");
  if (!await isNetworkAvailable()) {
    toast(errorInternetNotAvailable);
    appStore.setLoading(false);
    throw language.errorInternetNotAvailable;
  }
  if (response.statusCode == 401) {
    if (!avoidTokenError.validate()) LiveStream().emit(LIVESTREAM_TOKEN, true);
    appStore.isLoggedIn = false;
    appStore.setLoading(false);
    throw language.tokenExpired;
  }

  if (response.statusCode == 422) {
    appStore.setLoading(false);
    return jsonDecode(response.body);
  }
  if (response.statusCode == 400) {
    appStore.setLoading(false);
    throw language.somethingWentWrong;
    // return jsonDecode(response.body);
  }

  if (response.statusCode == 404) {
    appStore.setLoading(false);
    throw language.somethingWentWrong;
    // return jsonDecode(response.body);
  }

  if (response.statusCode == 408) {
    appStore.setLoading(false);
    throw language.connectionTimeOut;
  }

  if (response.statusCode == 500) {
    appStore.setLoading(false);
    throw language.somethingWentWrong;
  }

  if (response.statusCode.isSuccessful()) {
    return jsonDecode(response.body);
  } else {
    appStore.setLoading(false);
    try {
      var body = jsonDecode(response.body);
      if (PLAYERID.isEmpty) throw parseHtmlString(body['message']);
    } on Exception catch (e) {
      log(e);
      throw language.errorSomethingWentWrong;
    }
  }
}

Future<MultipartRequest> getMultiPartRequest(String endPoint,
    {String? baseUrl}) async {
  String url = '${baseUrl ?? buildBaseUrl(endPoint).toString()}';
  log(url);
  log(MultipartRequest('POST', Uri.parse(url)));
  return MultipartRequest('POST', Uri.parse(url));
}

Future<void> sendMultiPartRequest(MultipartRequest multiPartRequest,
    {Function(dynamic)? onSuccess, Function(dynamic)? onError}) async {
  print("multiPartRequest $multiPartRequest");
  http.Response response =
      await http.Response.fromStream(await multiPartRequest.send());
  print("Result: ${response.body}");

  if (response.statusCode.isSuccessful()) {
    onSuccess?.call(response.body);
  } else {
    print(multiPartRequest);
    // onError?.call(errorSomethingWentWrong);
  }
}

//region Common
enum HttpMethod { GET, POST, DELETE, PUT }
//endregion
