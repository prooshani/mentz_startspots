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
          leading: null,
          backgroundColor: const Color(0xff9d9d9c),
          title: const Text('Mentz StartSpots'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0, bottom: 20.0),
              child: Obx(
                () => Form(
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
            const SizedBox(
              height: 20,
            ),
            Obx(() => SingleChildScrollView(
                child: controller.locationsList.isNotEmpty
                    ? SizedBox(
                        height: Get.height * 0.7,
                        child: ListView.builder(
                          itemCount: controller.locationsList.length,
                          itemBuilder: (context, index) {
                            var location = controller.locationsList[index];
                            return ListTile(
                              dense: true,
                              tileColor: index.isEven ? Colors.black26 : Colors.black87,
                              isThreeLine: true,
                              title: Text(
                                location['disassembledName'] ?? '',
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                'Name: ${location['name']}',
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(
                                'Type: ${location['type']}',
                              ),
                            );
                          },
                        ),
                      )
                    : const Text('No locations found')))
          ],
        ));
  }
}
