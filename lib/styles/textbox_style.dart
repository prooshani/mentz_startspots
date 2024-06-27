import 'package:flutter/material.dart';
import 'package:mentz_startspots/home.dart';

InputDecoration searchBoxDecoration() {
  return InputDecoration(
    hintText: 'Search',
    hintStyle: const TextStyle(
      color: Colors.grey,
    ),
    suffixIcon: IconButton(
      icon: const Icon(
        Icons.search,
        color: Colors.grey,
      ),
      onPressed: () async {
        if (const HomeScreen().controller.searchController.value.text.isNotEmpty && const HomeScreen().controller.searchController.value.text.length > 2) {
          FocusManager.instance.primaryFocus?.unfocus();
          await const HomeScreen().controller.search();
        } else {
          const HomeScreen().controller.errorMessage.value = 'Search term must be at least 3 characters long';
          print('Search term must be at least 3 characters long');
        }
      },
    ),
    errorText: const HomeScreen().controller.errorMessage.value.isNotEmpty ? const HomeScreen().controller.errorMessage.value : null,
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.white,
        width: 0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.white,
        width: 0,
      ),
    ),
  );
}
