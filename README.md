# mentz_startspots

MENTZ challenge for Flutter Developer Applicatnts

Developer: Hamed Prooshani

## Getting Started

This project initialy declared as a part of developer skills evaluation process for MENTZ company.


## General Conditions

The project's general conditions are:

- Develop a Cross-platform app for Android (support Android 7+) and/or iOS ( support iOS 14+)
- For evaluation purpose, the app installation must be possible on MENTZ phones
- App design according to latest platform guidelines


## The Challenge

Create part of a journey planning app that assists the search for a starting point and display journey matches.

The app should be one page (No menu or tab bar necessary).

The following requirements should be fullfilled:

- User should be able to enter a text into a search field
- The app should send the search text to an EFA server with the following request:
    https://mvvvip1.defas-fgi.de/mvv/XML_STOPFINDER_REQUEST?language=de&outputFormat=RapidJSON&coordOutputFormat=WGS84[DD:ddddd]&type_sf=any&name_sf={Suchtext}
- The search result should be displayed, but the type of display is up to your discretion
- Each match should display the following (at a minimum)
    * Name of the match
    * Type of the match
    * Possibly the locality of the match
    * Additional information

The solution has to enable users to search for and select a starting point.
Make sure to briefley describe (in writing) the main decisions that went into your solution.


## Evaluation Criteria

- Correct function
- Stability and performance
- UD design
- Usefulness of and rationale for the chosen solutions




This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
