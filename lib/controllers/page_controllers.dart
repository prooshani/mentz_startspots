import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  final String uri = 'mvv/XML_STOPFINDER_REQUEST?language=de&outputFormat=RapidJSON&coordOutputFormat=WGS84%5BDD:ddddd%5D&type_sf=any&name_sf=';
  @override
  void onReady() async {
    searchController = TextEditingController().obs;
    super.onReady();
  }

  void onClosed() {
    searchController.value.dispose();
  }

  locationCard(Map<String, dynamic> location, index) {
    RxBool expandedCard = false.obs;
    RxBool expansionEnd = false.obs;
    RxDouble extraHeight = 0.0.obs;
    List stopsList = [];

    location['assignedStops'] != null ? extraHeight.value = (location['assignedStops'].length * 22).toDouble() : extraHeight.value = 0.0;
    location['assignedStops'] != null ? stopsList.addAll(location['assignedStops']) : stopsList.clear();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Obx(() => AnimatedContainer(
          onEnd: () {
            expandedCard.value ? expansionEnd.value = true : expansionEnd.value = false;
          },
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 400),
          height: expandedCard.value ? 100 + extraHeight.value : 75,
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
            title: AutoSizeText(
              location['disassembledName'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              maxLines: 1,
              minFontSize: 12,
              maxFontSize: 16,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  location['parent']['name'] ?? '',
                  style: const TextStyle(color: Colors.black87),
                  maxLines: 1,
                  minFontSize: 12,
                  maxFontSize: 16,
                ),
                expandedCard.value
                    ? Visibility(
                        visible: expansionEnd.value,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.location_on, color: Colors.black87, size: 18),
                                  Text(
                                    '${location['coord'][0]}, ${location['coord'][1]}' ?? '',
                                    style: const TextStyle(color: Colors.black87),
                                  ),
                                ],
                              ),
                              location.containsKey('assignedStops')
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: SizedBox(
                                        height: extraHeight.value,
                                        child: ListView.builder(
                                          itemCount: location['assignedStops'].length,
                                          itemBuilder: (context, index) {
                                            var stop = stopsList[index];
                                            return assignedStopsInfo(stop);
                                          },
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            trailing: IconButton(
              icon: Icon(expandedCard.value ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              onPressed: () {
                expandedCard.value = !expandedCard.value;
              },
            ),
          ))),
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
                            : type == 'singlehouse'
                                ? Icons.home
                                : Icons.question_mark,
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
                            : type == 'singlehouse'
                                ? Colors.purple
                                : Colors.redAccent,
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              type == 'singlehouse' ? 'House' : type,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget assignedStopsInfo(stop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(Icons.directions_bus, color: Colors.black87, size: 15),
        Flexible(
          child: AutoSizeText(
            '${stop['name']} (${stop['distance'] ?? '?'}m)',
            style: const TextStyle(color: Colors.black87),
            maxLines: 1,
            minFontSize: 12,
            maxFontSize: 16,
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
