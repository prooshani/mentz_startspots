import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SplashScreenController extends GetxController {
// This is the controller for the splash screen
}

// This is the controller for the home screen
// All the logic of the home screen is implemented here
// The controller is responsible for the business logic of the home screen
// It is responsible for the search functionality, the network connection check, and the search results
// It is also responsible for the search box's validation and the search results' expansion
// The controller is also responsible for the search results' sorting by match quality
// The controller is also responsible for the search results' display and design
class HomeScreenController extends GetxController {
  ///////////////////////// Connectivity variables /////////////////////////
  // This section includes the variables and methods related to the network connection check
  final _connectionType = ConnectivityResult.none.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;
  ConnectivityResult get connectionType => _connectionType.value;
  set connectionType(value) {
    _connectionType.value = value;
  }
  ///////////////////////////////////////////////////////////////////////////

  Rx<TextEditingController> searchController = TextEditingController().obs; // The controller of the search box. This variable is observed by Getx.
  Rx<GlobalKey> formKey = GlobalKey<FormState>().obs; // The global key of the form for validation purposes. This variable is observed by Getx and will be updated when the user types in the search box
  RxString errorMessage = ''.obs; // The error message for the search box. This variable is observed by Getx and validate on submit
  RxList locationsList = [].obs; // The list of locations that will be displayed as search results. This List is observed by Getx and will be updated when the search is submitted and completed
  RxBool isSearching = false.obs; // A boolean variable that will be true while the search is in progress. This variable is observed by Getx and will be update the UI when the search is in progress
  RxBool hasNetwork = false.obs; // An observed boolean variable that will be true if the device has an active network connection. In case of no network connection, the search will not be performed

  // // The URI of the search request. This URI will be used to search for locations in the MVV API
  // final String uri = 'mvv/XML_STOPFINDER_REQUEST?language=de&outputFormat=RapidJSON&coordOutputFormat=WGS84%5BDD:ddddd%5D&type_sf=any&name_sf=';

  @override
  void onReady() async {
    initConnectivityType(); // This method will be check the network connection type when the home screen is ready
    _streamSubscription = _connectivity.onConnectivityChanged.listen(_updateState); // This method will listen to the network connection changes and update the connection type accordingly
    super.onReady();
  }

  void onClosed() {
    searchController.value.dispose(); // This method will dispose of the search box controller when the home screen is closed
    _streamSubscription.cancel(); // This method will cancel the network connection subscription when the home screen is closed
  }

  // This method will initialize  the network connectivity check
  Future<void> initConnectivityType() async {
    late ConnectivityResult connectivityResult;
    // Because the platform sometimes return errors when checking the network connection, a try-catch block is used to handle the errors
    try {
      connectivityResult = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      if (!isClosed) {
        // This condition will check if the home screen is not closed
        //if there is a problem with connectivity check, aan Error will be displayed as a snackbar to show the error message
        Get.snackbar('Error', 'Cannoty check the network. \nError: $e',
            icon: const Icon(Icons.error), borderWidth: 3, borderColor: Colors.redAccent, colorText: Colors.red, backgroundColor: Colors.white70, snackPosition: SnackPosition.BOTTOM);
      }
    }
    return _updateState(connectivityResult); // pass the network check to update the condition of connectivity
  }

  // This method will update the network connection state
  Future<void> _updateState(result) async {
    if (result == ConnectivityResult.none) {
      hasNetwork.value = false; // If there is no network connection, the hasNetwork variable will be false. The search will not be performed on no network connection
    } else {
      hasNetwork.value = true;
    }
  }

  // The method will create a card widget for each location in the search results
  // The card will include the location's name, type,  coordinates, and assigned stops and its distance (if available)
  Widget locationCard(Map<String, dynamic> location, index) {
    RxBool expandedCard = false.obs; // An observerd bolean to check if the card is expanded for extra information or not
    RxBool expansionEnd = false.obs; // An observed boolean to check if the card expansion animation is ended or not
    RxDouble extraHeight = 0.0.obs; // An observed double to be added to the height of the card when it expanded. This is a dynamic value according to the number of assigned stops
    List stopsList = []; // A list of assigned stops to the location

    if (location['assignedStops'] != null) {
      // According to the number of stops, it will calculate the extra height to be added to the card. Each stop should add 22 pixels to the card height
      extraHeight.value = (location['assignedStops'].length * 22).toDouble();
      stopsList.addAll(location['assignedStops']); // Add the assigned stops to the stopsList if available
    } else {
      extraHeight.value = 0.0; // If there are no assigned stops, the extra height will be 0
      stopsList.clear(); // If there are no assigned stops, the stopsList will be cleared
    }

    // This part will return the card widget for each location in the search results of the main UI
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Obx(() => AnimatedContainer(
          // To animate the card expansion, an AnimatedContainer is used
          onEnd: () {
            // This part will check if the card expansion animation is ended or not. This will used to show the extra information of the location after the card expansion animation is ended
            expandedCard.value ? expansionEnd.value = true : expansionEnd.value = false;
          },
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 400),
          // If the location has no stops, the card height will be 75 pixels. On expanded, the card height will be 100 pixels. If the location has stops, the card height will be 100 + (22 * number of stops) pixels
          height: expandedCard.value ? 100 + extraHeight.value : 75, //
          decoration: BoxDecoration(
            // decoration of the card
            color: index.isEven ? const Color(0xff9d9d9c) : const Color(0xff878786),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border(
              bottom: BorderSide(
                  color: location['isBest'] == true ? Colors.greenAccent : Colors.amber,
                  width: 3), // If the location isBest as a match result, the border color will be green. Otherwise, it will be amber
            ),
          ),
          child: ListTile(
            isThreeLine: true,
            leading: leadingTitle(location['type']), // The leading title of the card. It will show the type of the location. defined in the leadingTitle method.
            title: AutoSizeText(
              // To prevent overflow, the title of the card is an AutoSizeText widget which changes the font size according to the text length
              location['disassembledName'] ?? '', // The name of the location
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              maxLines: 1,
              minFontSize: 12,
              maxFontSize: 16,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  // To prevent overflow, the subtitle of the card is an AutoSizeText widget which changes the font size according to the text length
                  location['parent']['name'] ?? '', // The name of locality of the location
                  style: const TextStyle(color: Colors.black87),
                  maxLines: 1,
                  minFontSize: 12,
                  maxFontSize: 16,
                ),
                expandedCard.value // check for the card expansion. If the card is expanded, the extra information of the location will be shown
                    ? Visibility(
                        // use the visibility widget to show the extra information of the location after the card expansion animation is ended
                        visible: expansionEnd.value, // check if the card expansion animation is ended or not. if ended, show the extra information
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.location_on, color: Colors.black87, size: 18),
                                  Text(
                                    '${location['coord'][0]}, ${location['coord'][1]}', // The coordinates of the location
                                    style: const TextStyle(color: Colors.black87),
                                  ),
                                ],
                              ),
                              location.containsKey('assignedStops') // check to find if there are assignedStops to the location or not
                                  //if yes, show them below the coordinates of the location
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: SizedBox(
                                        // define a constrain for the listview of assigned stops
                                        height: extraHeight.value, // calculate the height of the listview according to the number of assigned stops
                                        child: ListView.builder(
                                          // create a listview for the assigned stops
                                          itemCount: location['assignedStops'].length,
                                          itemBuilder: (context, index) {
                                            var stop = stopsList[index];
                                            return assignedStopsInfo(stop); // create a widget for each assigned stop. defined in the assignedStopsInfo method
                                          },
                                        ),
                                      ),
                                    )
                                  : const SizedBox(), // if there are no assigned stops, show nothing
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(), // if the card is not expanded, show nothing extra
              ],
            ),
            trailing: IconButton(
              // The trailing icon button of the card. It will show an arrow icon to expand or collapse the card
              icon: Icon(expandedCard.value ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              onPressed: () {
                expandedCard.value = !expandedCard.value; // toogle the card expansion state
              },
            ),
          ))),
    );
  }

  // This method will create the leading title widget of the location card based on the location's type
  // The type will passed to the method as a parameter
  Widget leadingTitle(type) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          // assign an icon to the type of the location
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
          // create a container to show the type of the location inside that like a chip for better user experience
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
            // the text inside the container for the type of the location.
            padding: const EdgeInsets.all(3.0),
            child: Text(
              type == 'singlehouse' ? 'Building' : type, // just singlehouse will be shown as Building for better reading experience
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // This method will create the assigned stops info widget for each assigned stop to the location
  Widget assignedStopsInfo(stop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(Icons.directions_bus, color: Colors.black87, size: 15), // the icon for stop. (should improve for a better icon based on stop type)
        Flexible(
          child: AutoSizeText(
            // To prevent overflow, the text of the assigned stop is an AutoSizeText widget which changes the font size according to the text length
            // this part will show the name of the stop and its distance (if available) in the assigned stops list. if there is no distance, it will show only the name of the stop
            stop['distance'] != null ? '${stop['name']} (${stop['distance'] ?? '?'}m)' : '${stop['name']}',
            style: const TextStyle(color: Colors.black87),
            maxLines: 1,
            minFontSize: 12,
            maxFontSize: 16,
          ),
        ),
      ],
    );
  }

  // The main search method of the home screen
  // This method will search for locations using the MVV API based on the user's input in the search box
  // The search results will be stored in the locationsList variable
  Future search() async {
    locationsList.clear(); // clear the locationsList before starting a new search
    isSearching.value = true; // start the loading indicator
    if (hasNetwork.value) {
      // check if the device has an active network connection to perform the search
      // try-catch block to handle the errors during the search
      try {
        // create the search request URL based on the user's input in the search box for API call
        // This API which looks like a RESTful, is used to search for stop locations in the MVV API
        var searchRequestUrl = Uri.https('mvvvip1.defas-fgi.de', '/mvv/XML_STOPFINDER_REQUEST', {
          'language': 'de',
          'outputFormat': 'RapidJSON',
          'coordOutputFormat': 'WGS84[DD:ddddd]',
          'type_sf': 'any',
          'name_sf': searchController.value.text, // the user's input in the search box
        });

        // Await the http get response, then decode the json-formatted response.
        var response = await http.get(searchRequestUrl);
        if (response.statusCode == 200) {
          // check if the response status code is 200 (OK)
          isSearching.value = false; // set the isSearching variable to false to hide the loading indicator after the search is completed
          // decode the json-formatted response and store the locations in the locationsList variable. It will be decode in utf8 format for non-enlish characters
          Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

          locationsList.addAll(jsonResponse['locations']); // add the extracted locations to the locationsList

          // Sort results by matchQuality (higher is better match)
          locationsList.sort((a, b) => b['matchQuality'].compareTo(a['matchQuality']));
        } else {
          isSearching.value = false; // stop the loading indicator. Even on errors user should know that the search is finished
          // if the response status code is not 200 (OK), show an error message as a snackbar to display the error message
          Get.snackbar('Error', 'Something Went Wrong! Please try again later, \nError: ${response.statusCode}',
              icon: const Icon(Icons.error), borderWidth: 3, borderColor: Colors.redAccent, colorText: Colors.red, backgroundColor: Colors.white70, snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        // if there is an error during the search, show an error message as a snackbar to display the error message
        isSearching.value = false; // stop the loading indicator. Even on errors user should know that the search is finished
        Get.snackbar('Error', 'Something Went Wrong! Please try again later, \nError: $e',
            icon: const Icon(Icons.error), borderWidth: 3, borderColor: Colors.redAccent, colorText: Colors.red, backgroundColor: Colors.white70, snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      isSearching.value = false; // stop the loading indicator. Even on errors user should know that the search is finished
      Get.snackbar('Error', 'No Network Connection! Please check your internet connection',
          icon: const Icon(Icons.wifi_off), borderWidth: 3, borderColor: Colors.redAccent, colorText: Colors.red, backgroundColor: Colors.white70, snackPosition: SnackPosition.BOTTOM);
    }
  }
}

enum MConnectivityResult { none, wifi, mobile } // The network connection types enummeration
