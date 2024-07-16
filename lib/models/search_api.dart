import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class ApiResponse {
  int status;
  Uint8List data;

  ApiResponse({required this.status, required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      data: json['data'],
    );
  }

  static searchCall(searchTerm) async {
    var searchRequestUrl = Uri.https('mvvvip1.defas-fgi.de', '/mvv/XML_STOPFINDER_REQUEST', {
      'language': 'de',
      'outputFormat': 'RapidJSON',
      'coordOutputFormat': 'WGS84[DD:ddddd]',
      'type_sf': 'any',
      'name_sf': searchTerm, // the user's input in the search box
    });

    var response = await http.get(searchRequestUrl);

    return ApiResponse(status: response.statusCode, data: response.bodyBytes);
  }

  static apiResponseDecode(response) async {
    return json.decode(utf8.decode(response));
  }
}

class ResponseCode {
  static String errorHandling(status) {
    switch (status) {
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorised';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not Found';
      case 500:
        return 'Internal Server Error';
      default:
        return 'Unknown Error';
    }
  }

  static exceptionHandling(exception) {
    switch (exception) {
      case SocketException():
        return 'Socket Exception: ${exception.message}';
      case TimeoutException():
        return 'Connection Timeout';
      case FormatException():
        return 'Invalid Data';
      default:
        return 'Unknown Error';
    }
  }
}
