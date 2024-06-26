import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class SplashScreenController extends GetxController {
  @override
  void onReady() async {
    super.onReady();
  }
}

class HomeScreenController extends GetxController {
  Rx<TextEditingController> searchController = TextEditingController().obs;
  Rx<GlobalKey> formKey = GlobalKey<FormState>().obs;
  RxString errorMessage = ''.obs;
  RxString numLocation = ''.obs;
  RxList locationsList = [].obs;

  final String uri = 'mvv/XML_STOPFINDER_REQUEST?language=de&outputFormat=RapidJSON&coordOutputFormat=WGS84%5BDD:ddddd%5D&type_sf=any&name_sf=';
  @override
  void onReady() async {
    searchController = TextEditingController().obs;
    super.onReady();
  }

  void onClosed() {
    searchController.value.dispose();
  }

  Future search() async {
    locationsList.clear();
    print('Search for ${searchController.value.text}');

    var searchRequestUrl = Uri.https('mvvvip1.defas-fgi.de', '/mvv/XML_STOPFINDER_REQUEST', {
      'language': 'de',
      'outputFormat': 'RapidJSON',
      'coordOutputFormat': 'WGS84[DD:ddddd]',
      'type_sf': 'any',
      'name_sf': searchController.value.text,
    });

    print('the url is: $searchRequestUrl');

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(searchRequestUrl);
    if (response.statusCode == 200) {
      //Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

      locationsList.addAll(jsonResponse['locations']);

      var locationCount = locationsList.length;
      numLocation.value = locationCount.toString();

      print('Number of locations returned: $locationCount. \n');
      print('First location: ${locationsList[0]}');
      print('First location name: ${locationsList[0]['name']}');
      // print(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      print(response.body);
    }
  }
}
