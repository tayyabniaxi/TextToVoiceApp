// ignore_for_file: avoid_print, prefer_adjacent_string_concatenation

import 'dart:convert';
import 'dart:io';

import 'package:new_wall_paper_app/data/app_exception/app_exception.dart';
import 'package:new_wall_paper_app/data/network/baseApiServices.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NetwordApiServices extends BaseApiServices {
  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;

    try {
      final SharedPreferences sp = await SharedPreferences.getInstance();

      final headers = {
        "Authorization": "Bearer ${sp.getString("token")}",
        // "Content-Type": "application/json",
      };
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 20));
      responseJson = returnResponse(response);
    } on SocketException {
      throw fetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;

    try {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      final headers = {
        "Authorization": "Bearer ${sp.getString("token")}",
        // "Content-Type": "application/json",
      };
      http.Response response = await http
          .post(Uri.parse(url), body: data, headers: headers)
          .timeout(const Duration(seconds: 30));
      responseJson = returnResponse(response);
    } on SocketException {
      throw fetchDataException("No Internet Connection");
    }
    return responseJson;
  }
}

dynamic returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      dynamic responseJson = jsonDecode(response.body);
      return responseJson;
    case 201:
      dynamic responseJson = jsonDecode(response.body);
      return responseJson;
    case 400:
      throw BadRequestException(response.body.toString());

    case 404:
      throw UnutherozidRequestException(response.body.toString());

    default:
      throw fetchDataException("Error accured while communicating with server" +
          "with status code" +
          response.statusCode.toString());
  }
}
