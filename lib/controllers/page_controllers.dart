import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  @override
  void onReady() async {
    super.onReady();
  }
}

class HomeScreenController extends GetxController {
  Rx<TextEditingController> searchController = TextEditingController().obs;

  @override
  void onReady() async {
    searchController = TextEditingController().obs;
    super.onReady();
  }

  void onClosed() {
    searchController.value.dispose();
  }

  Future search() async {
    print('Search for ${searchController.value.text}');
  }
}
