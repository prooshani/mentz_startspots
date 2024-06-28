import 'package:flutter/material.dart';
import 'package:mentz_startspots/home.dart';

// This is the decoration of the search box also, it includes input decoration, validation and search function call
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
        // This function is called when the search icon is pressed. It will call the search function in the controller
        if (const HomeScreen().controller.searchController.value.text.length > 2) {
          FocusManager.instance.primaryFocus?.unfocus(); // This is to dismiss the keyboard after the search icon is pressed
          await const HomeScreen().controller.search(); // This is to call the search function in the controller
        } else {
          // If the search term is less than 3 characters, an error message will be displayed under the search box and the search function will not be called
          //The reason for this is that the API will return much more accurate results if the search term is at least 3 characters long.
          const HomeScreen().controller.errorMessage.value = 'Search term must be at least 3 characters long';
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
