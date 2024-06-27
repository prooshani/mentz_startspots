import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentz_startspots/controllers/page_controllers.dart';
import 'package:mentz_startspots/styles/textbox_style.dart';

class HomeScreen extends GetView<HomeScreenController> {
  static const String id = 'Home_Screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const SizedBox(
            width: 0,
          ),
          backgroundColor: const Color(0xff017eb3),
          centerTitle: true,
          title: const Text('Mentz StartSpots'),
        ),
        body: Column(
          children: [
            Obx(
              () => Container(
                height: 65,
                color: const Color(0xff017eb3),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: controller.formKey.value,
                    child: TextField(
                      controller: controller.searchController.value,
                      decoration: searchBoxDecoration(),
                      onChanged: (value) => {controller.searchController.value.text = value, controller.errorMessage.value = ''},
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Obx(() => SingleChildScrollView(
                child: controller.locationsList.isNotEmpty
                    ? SizedBox(
                        height: Get.height * 0.75,
                        child: ListView.builder(
                          itemCount: controller.locationsList.length,
                          itemBuilder: (context, index) {
                            var location = controller.locationsList[index];
                            return controller.locationCard(location, index);
                          },
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: controller.isSearching.value ? const CircularProgressIndicator() : const Text('No locations found'),
                      )))
          ],
        ));
  }
}
