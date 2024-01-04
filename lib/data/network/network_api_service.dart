import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../app_exceptions.dart';
import 'base_api_services.dart';


class NetworkApiService extends BaseApiService {
  @override
  Future<dynamic> getApi(String url) async {
    dynamic responseJson;
    try {
      final response =
      await http.get(Uri.parse(url)).timeout(const Duration(seconds: 20));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetExceptions('');
    }

    return responseJson;
  }

  @override
  Future<dynamic> postApi(var data, String url) async {
    try {
      print("url: $url");
      print("data: $data");
      Map<String, String> headers = {"Content-type": "application/json; charset=utf-8"};
    await http.post(Uri.parse(url), body: json.encode(data),headers: headers).timeout(const Duration(seconds: 60));

    } on SocketException {
      throw InternetExceptions('Hello Quyen,error is here');
    }
  }
  @override
  Future<dynamic> putApi(var data, String url) async {
    print("url: $url");
    print("data: $data");
    try {
      Map<String, String> headers = {"Content-type": "application/json; charset=utf-8"};
      await http.put(Uri.parse(url), body: json.encode(data), headers: headers).timeout(const Duration(seconds: 60));

    } on SocketException {
      throw InternetExceptions('Hello Quyen, error is here');
    }
  }
  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(utf8.decode(response.bodyBytes));
        return responseJson;
      case 400:
        throw TimeOutExceptions('Api returned 400');
      default:
        throw FetchDataExceptions(
            'Something other issue happaned:: check in network_api_service file');
    }
  }
}