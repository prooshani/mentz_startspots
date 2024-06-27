import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
  RxBool isSearching = false.obs;
  RxBool expandedCard = false.obs;

  final String uri = 'mvv/XML_STOPFINDER_REQUEST?language=de&outputFormat=RapidJSON&coordOutputFormat=WGS84%5BDD:ddddd%5D&type_sf=any&name_sf=';
  @override
  void onReady() async {
    searchController = TextEditingController().obs;
    super.onReady();
  }

  void onClosed() {
    searchController.value.dispose();
  }

  // ListTile locationTile(Map<String, dynamic> location, index) {
  //   return ListTile(
  //     dense: locationsList.length > 10 ? true : false,
  //     tileColor: index.isEven ? const Color(0xff9d9d9c) : const Color(0xff878786),
  //     isThreeLine: false,
  //     leading: location['type'] == 'stop'
  //         ? const Icon(
  //             Icons.tram,
  //             color: Colors.white,
  //           )
  //         : location['type'] == 'street'
  //             ? Icon(
  //                 MdiIcons.roadVariant,
  //                 color: Colors.white,
  //               )
  //             : location['type'] == 'poi'
  //                 ? const Icon(Icons.pin_drop, color: Colors.white)
  //                 : location['type'] == 'suburb'
  //                     ? Icon(MdiIcons.city, color: Colors.white)
  //                     : null,
  //     title: Text(
  //       location['disassembledName'] ?? '',
  //       style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
  //       overflow: TextOverflow.ellipsis,
  //     ),
  //     subtitle: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           location['name'] ?? '',
  //           style: const TextStyle(color: Colors.black87),
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //       ],
  //     ),
  //     trailing: Text(
  //       location['type'] ?? '',
  //       style: const TextStyle(color: Colors.black87),
  //     ),
  //   );
  // }

  locationCard(Map<String, dynamic> location, index) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: AnimatedContainer(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 500),
          height: expandedCard.value ? 120 : 90,
          decoration: BoxDecoration(
            color: index.isEven ? const Color(0xff9d9d9c) : const Color(0xff878786),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: const Border(
              bottom: BorderSide(color: Colors.amber, width: 2),
              top: BorderSide(
                color: Colors.amber,
                width: 0.2,
              ),
            ),
          ),
          child: ListTile(
            // dense: locationsList.length > 10 ? true : false,
            //tileColor: index.isEven ? const Color(0xff9d9d9c) : const Color(0xff878786),
            isThreeLine: true,
            leading: leadingTitle(location['type']),
            title: Text(
              location['disassembledName'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location['name'] ?? '',
                  style: const TextStyle(color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            trailing: Text(
              location['type'] ?? '',
              style: const TextStyle(color: Colors.black87),
            ),
          )),
    );
  }

  leadingTitle(type) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Icon(
            type == 'stop'
                ? Icons.tram
                : type == 'street'
                    ? MdiIcons.roadVariant
                    : type == 'poi'
                        ? Icons.pin_drop
                        : type == 'suburb'
                            ? MdiIcons.city
                            : null,
            color: Colors.white,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: type == 'stop'
                ? const Color(0xff017eb3)
                : type == 'street'
                    ? const Color(0xff2a281f)
                    : type == 'poi'
                        ? const Color(0xff46a318)
                        : type == 'suburb'
                            ? const Color(0xff11cabf)
                            : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              type,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Future search() async {
    locationsList.clear();
    isSearching.value = true;

    //print('Search for ${searchController.value.text}');

    var searchRequestUrl = Uri.https('mvvvip1.defas-fgi.de', '/mvv/XML_STOPFINDER_REQUEST', {
      'language': 'de',
      'outputFormat': 'RapidJSON',
      'coordOutputFormat': 'WGS84[DD:ddddd]',
      'type_sf': 'any',
      'name_sf': searchController.value.text,
    });

    // print('the url is: $searchRequestUrl');

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(searchRequestUrl);
    if (response.statusCode == 200) {
      isSearching.value = false;
      //Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

      locationsList.addAll(jsonResponse['locations']);

      // Sort results by matchQuality (higher is better match)
      locationsList.sort((a, b) => b['matchQuality'].compareTo(a['matchQuality']));

      var locationCount = locationsList.length;
      numLocation.value = locationCount.toString();

      // print('Number of locations returned: $locationCount. \n');
      // print('First location: ${locationsList[0]}');
      // print('First location name: ${locationsList[0]['name']}');
      // print(response.body);
    } else {
      isSearching.value = false;
      print('Request failed with status: ${response.statusCode}.');
      //  print(response.body);
      Get.snackbar('Error', 'Something Went Wrong! Please try again later, \nError: ${response.statusCode}',
          borderWidth: 3, borderColor: Colors.redAccent, colorText: Colors.red, backgroundColor: Colors.white24, snackPosition: SnackPosition.BOTTOM);
    }
  }
}
