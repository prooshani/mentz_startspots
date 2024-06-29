import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentz_startspots/controllers/page_controllers.dart';
import 'package:mentz_startspots/styles/textbox_style.dart';

// This is the home screen widget which is the main screen of the app
// It will show the app bar with the MENTZ logo and the app's title
// It will show the search box and the list of locations
// The home screen is a getview widget which is a GetX widget that is used to manage the state of the app
// The controller of the home screen is HomeScreenController
// The controller is used to manage the state of the home screen
class HomeScreen extends GetView<HomeScreenController> {
  static const String id = 'Home_Screen'; // This is the route name
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // This is the main scaffold widget of the home screen
        appBar: AppBar(
          // This is the app bar widget which includes the title
          leading: const SizedBox(), //this is to remove the back button
          backgroundColor: const Color(0xff017eb3),
          centerTitle: true,
          title: Row(
            // This is the row widget which includes the logo and the title
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                // This is the image widget which includes the MENTZ logo
                "images/mentz_logo_dark.png",
                scale: 6,
              ),
              const Text('StartSpots', // This is the text widget which includes the title
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ))
            ],
          ),
        ),
        body: SingleChildScrollView(
          // This is the body widget which includes the list of locations. It is scrollable and won't overflow the screen
          child: Column(
            children: [
              Obx(
                () => Container(
                  // This is the container widget which includes the search box
                  height: 90,
                  color: const Color(0xff017eb3),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      // Form used to be able to validate the search box's text before submitting
                      key: controller.formKey.value, // This is the global key of the form for validation purposes
                      child: Obx(() => TextField(
                            // TextField widget of the search box which receives the user's input
                            controller: controller.searchController.value, // Assigned a controller to the search box to reach it content
                            decoration: searchBoxDecoration(), //The decoration of the search box. defined separately in the textbox_style.dart file
                            autocorrect: false,
                            autofocus: true,
                            onChanged: (value) => {
                              controller.errorMessage.value = '', // If there is any error message, it will be removed after the user starts typing
                            },
                            style: const TextStyle(
                              // The style of the text in the search box. Color it to black for better readability
                              color: Colors.black,
                            ),
                          )),
                    ),
                  ),
                ),
              ),
              Obx(() => SingleChildScrollView(
                  //Because I have used GetX for state management, I have to use Obx to update the UI when the state changes
                  child: controller.locationsList.isNotEmpty // if there are locations in the list, show them. Otherwise, show the message (No locations found)
                      ? SizedBox(
                          //
                          height: Get.height * 0.80, // set the height of the list view to 80% of the screen height for the last 20% to be visible for longer lists of locations
                          child: ListView.builder(
                            // Main builder for the list of locations
                            itemCount: controller.locationsList.length, // The number of locations in the list (extracted in search function in the controller)
                            itemBuilder: (context, index) {
                              var location = controller.locationsList[index]; // The location object at the current index
                              return controller.locationCard(location, index); // The card widget generator for each location (defined in the controller)
                            },
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: controller.isSearching.value
                              ? const CircularProgressIndicator()
                              : const Text('No locations found'), //if there are no locations in the list, show the message. If the app is searching, show the loading indicator
                        )))
            ],
          ),
        ));
  }
}
