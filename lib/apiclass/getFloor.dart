// To parse this JSON data, do
//
//     final getfloor = getfloorFromJson(jsonString);

import 'dart:convert';

Getfloor getfloorFromJson(String str) => Getfloor.fromJson(json.decode(str));

String getfloorToJson(Getfloor data) => json.encode(data.toJson());

class Getfloor {
  bool isSuccess;
  String messages;
  List<FloorLocation> floorLocation;

  Getfloor({
    required this.isSuccess,
    required this.messages,
    required this.floorLocation,
  });

  factory Getfloor.fromJson(Map<String, dynamic> json) => Getfloor(
    isSuccess: json["is_success"],
    messages: json["messages"],
    floorLocation: List<FloorLocation>.from(json["floor_location"].map((x) => FloorLocation.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "messages": messages,
    "floor_location": List<dynamic>.from(floorLocation.map((x) => x.toJson())),
  };
}

class FloorLocation {
  String slNo;
  String floorLocation;
  String status;
  DateTime rTimestamp;

  FloorLocation({
    required this.slNo,
    required this.floorLocation,
    required this.status,
    required this.rTimestamp,
  });

  factory FloorLocation.fromJson(Map<String, dynamic> json) => FloorLocation(
    slNo: json["sl_no"],
    floorLocation: json["floor_location"],
    status: json["status"],
    rTimestamp: DateTime.parse(json["r_timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "sl_no": slNo,
    "floor_location": floorLocation,
    "status": status,
    "r_timestamp": rTimestamp.toIso8601String(),
  };
}
