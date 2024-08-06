// To parse this JSON data, do
//
//     final homePage = homePageFromJson(jsonString);

import 'dart:convert';

HomePage homePageFromJson(String str) => HomePage.fromJson(json.decode(str));

String homePageToJson(HomePage data) => json.encode(data.toJson());

class HomePage {
  HomePage({
    required this.isSuccess,
    required this.messages,
    required this.courier,
    required this.local,
    required this.outstation,
    required this.town,
    required this.special,
    required this.active,
    required this.pickedcount,
    required this.SpecialBooking,
    required this.ALL,
  });

  bool isSuccess;
  String messages;
  String courier;
  String local;
  String outstation;
  String town;
  String special;
  String pickedcount;
  String SpecialBooking;
  String ALL;
  List<Active> active;

  factory HomePage.fromJson(Map<String, dynamic> json) => HomePage(
    isSuccess: json["is_success"],
    messages: json["messages"],
    courier: json["Courier"],
    local: json["Local"],
    outstation: json["Outstation"],
    town: json["Town"],
    special: json["Special"],
    pickedcount: json["pickedcount"],
    SpecialBooking: json["SpecialBooking"],
    ALL: json["ALL"],
    active: List<Active>.from(json["Active"].map((x) => Active.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "messages": messages,
    "Courier": courier,
    "Local": local,
    "Outstation": outstation,
    "Town": town,
    "Special": special,
    "pickedcount":pickedcount,
    "SpecialBooking":SpecialBooking,
    "ALL":ALL,
    "Active": List<dynamic>.from(active.map((x) => x.toJson())),
  };
}

class Active {
  Active({
    required this.pickId,
    required this.pickCategory,
    required this.pickStatus,
  });

  String pickId;
  String pickCategory;
  String pickStatus;

  factory Active.fromJson(Map<String, dynamic> json) => Active(
    pickId: json["pick_id"],
    pickCategory: json["pick_category"],
    pickStatus: json["pick_status"],
  );

  Map<String, dynamic> toJson() => {
    "pick_id": pickId,
    "pick_category": pickCategory,
    "pick_status": pickStatus,
  };
}
