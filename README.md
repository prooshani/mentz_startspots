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


### Overview

This project covers this areas of skills of a Flutter Application Developer:

- Statemanagement, lifecycle, and ... development skills
- Using API skills to send request to a RESTful API and decode the JSON response to show as results
- UI/UX skills to show results both efficently and applicable for further developments
- Other skills like clean code, good commenting and structural design skills


## State Management

The state management method used to develop this project is GetX (V4.6.6).
The main reason for using getx is its extensibility and being a light weight state manager for the current aspect of project.
All the UI updates, routings, global variable definitions are observed and under control of the GetX.

## API calls

The http package (V1.2.1) is used for API calls and due to the language of requests and responses which is de (Deutch) the whole response decoded using UTF8 to show special characters correctly in the UI.
API url shows that it is a RESTful API and it is handled inside the bb search bb function from -- HomeScreen Controller --.


