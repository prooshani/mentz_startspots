import 'package:flutter/material.dart';
import 'package:mentz_startspots/controllers/page_controllers.dart';
import 'package:mentz_startspots/home.dart';

InputDecoration searchBoxDecoration() {
  return InputDecoration(
    hintText: 'Search',
    hintStyle: TextStyle(
      color: Colors.grey,
    ),
    suffixIcon: IconButton(
      icon: Icon(
        Icons.search,
        color: Colors.grey,
      ),
      onPressed: () async {
        await HomeScreen().controller.search();
      },
    ),
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.white,
        width: 0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.white,
        width: 0,
      ),
    ),
  );
}
