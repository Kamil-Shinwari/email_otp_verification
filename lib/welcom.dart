import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class WelcomePage extends StatefulWidget {
  String? uid;
  WelcomePage({this.uid});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: ElevatedButton(child: Text("click"),onPressed: (){
        newwLogin();
      },),)
    );
  }
  newwLogin() async {
    // Define the body parameters as variables

    String apiEndpoint =
        'https://gentecbspro.com/MobileApp/CoreAPI/api/values/InsertData';
    String nType = "1";
    String nsType = "2";
    String GPFormId = "36";
    String UserId = "kamil";
    double Latitude =34.014599921477384;
    double Longitude = 71.52541882567984;
    String DocumentNo = "0";
    String spname = "CRM_DataEntryGeolocationSp";
    String Event = "Tracking By Kamil";

// Encode the body parameters as a JSON object
    String bodyJson = json.encode(
      {
         "SPNAME": spname,
      "ReportQueryParameters": [
        "@nType",
        "@nsType",
        "@GPFormId",
        "@UserId",
        "@Latitude",
        "@Longitude",
        "@DocumentNo",
        "@Event"
      ],
      "ReportQueryValue": [
        nType,
        nsType,
        GPFormId,
        UserId,
        Latitude,
        Longitude,
        DocumentNo,
        Event
      ]
    });

// Make the POST request to the API endpoint, including the JSON object in the request body
    http.Response response = await http.post(Uri.parse(apiEndpoint), body: bodyJson,
    
    headers: {
       "Content-Type": "application/json"
    });

// Check the status code of the response to see if the request was successful
    if (response.statusCode == 200) {
      // The request was successful
      // You can parse the response body to get the data returned by the API
      print(response.body);
    } else {
      // The request was not successful
      // You can check the status code and/or the response body to understand the error
      print("Request failed with status code: ${response.body}");
    }








  }



}
