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

The state management method used to develop this project is **GetX (V4.6.6)**.
The main reason for using getx is its extensibility and being a light weight state manager for the current aspect of project.
All the UI updates, routings, global variable definitions are observed and under control of the GetX.
Because the main functionallity of the app is based on an **online API call**, I have also used **Connectivity_plus (V5.0.2)** to detect the device's Internet connectivity for better state management and prevent the exceptional issues for the main function of the app. To be brief, if no Internet, no search would perform.

## API calls

The http package (V1.2.1) is used for API calls and due to the language of requests and responses which is de (Deutch) the whole response decoded using **UTF8** to show special characters correctly in the **UI**.
API url shows that it is a **RESTful** API and it is handled inside the **search** function from * *HomeScreen* * Controller__.
The response of the API call is encoded as a **RapidJSON** format and decoded reults will be extracted and stored locally on inside a list of * *locations* * for further usages.

## Project Folders Structure

According to the projects definitions, it is a **part** of a application. Therefore, we should always preserve epace for any further expansion and modification of the project.
As a result, the project's folders and files defined accordingly.
- **Screens**: While it looks like that we only have one screen, there is a folder called screens. If any new screen should add to the app, we can create a new screen file at this folder and it make the project's structure looks tidy,
- **Controller**: Each screen should have its own controller for better implementations and code readability.
- **Styles**: At this part of project we have very few stylings but, for further expansions, you can use this folder to put styling files for different part of UI designs.
-- **Assets**: to unify the address of extra assets, like logo andother stuff, a folder called assets added.

### The Solution

According to the nature of the app at this level, it seems like that it would be a feature for a more complete app for **journey planning app** and the end-users should be able to decide about their starting point based on results of their search term. 
While it looks the API would response with * *available stops* *, the other type of locations also available for better understanding of the starting point. Therefore, the whole app, at this point, should be focused on only listing the matched locations with end-users' search term. However, in a real-life app, you can automatically suggest and show stops and locations based on user's device based GPS location for much better outcomes and user experiences.

As we are limited to the responses of the API call, we should design our UI based on the information we got from the responses.
The response contains many different user-readable, such as the name of stop, locality and stop name, and non user related informations like, response id matchQuality and etc.

For better **User Experience**, I have decided to show user-readable details inside a list of **Cards** and also, reflect the non-user-readable details in the **UI design**.

*Why Cards?* Because the details and information we are going to display are mostly in text format and we need to somehow wrap these detials for each location inside an item for better **UI design** and unifying the results.
Additionally, this way, we have a lot of flexibility for any further expansions and design related modifications.
Functions like, Go to the point or show on the map and many other functionalities could be easily implement into the card's container accordingly.


## Readable Details:

Regarding the project's criteria, we should show at least:
 
    - The location name
    - Type of the location (Stop, POI, Street, Suburb, Singlehouse)
    - Locality (if available)
    - Additional information (Like coordinates and stop name and distance from the location)

## non-readable Details:

There are several important information available in resssponses which can make the user's experience much more better. 
**isBest** and **matchQuality** are 2 of these details that can affect user's experince positively. Therefore, I have decided to reflect these two parameters on my **UI designs**.

 -**isBest**: if the location defined as the best result for search term, the bottom border of the location card will be green, otherwise, it will be yellow.
 -**matchQuality**: The whole response will be sorted based on the match quality (the higher, the better)  and will shown based on this sorting element. This way, we can be sure that the user will reach the better matches faster.

