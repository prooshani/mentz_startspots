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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0, bottom: 20.0),
                child: Obx(
                  () => TextField(
                    controller: controller.searchController.value,
                    decoration: searchBoxDecoration(),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
