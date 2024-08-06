// To parse this JSON data, do
//
//     final profileHistory = profileHistoryFromJson(jsonString);

import 'dart:convert';

ProfileHistory profileHistoryFromJson(String str) => ProfileHistory.fromJson(json.decode(str));

String profileHistoryToJson(ProfileHistory data) => json.encode(data.toJson());

class ProfileHistory {
  ProfileHistory({
    required this.categorycount,
    required this.isSuccess,
    required this.messages,
    required this.totalCount,
  });

  List<Categorycount> categorycount;
  bool isSuccess;
  String messages;
  List<TotalCount> totalCount;

  factory ProfileHistory.fromJson(Map<String, dynamic> json) => ProfileHistory(
    categorycount: List<Categorycount>.from(json["categorycount"].map((x) => Categorycount.fromJson(x))),
    isSuccess: json["is_success"],
    messages: json["messages"],
    totalCount: List<TotalCount>.from(json["TotalCount"].map((x) => TotalCount.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "categorycount": List<dynamic>.from(categorycount.map((x) => x.toJson())),
    "is_success": isSuccess,
    "messages": messages,
    "TotalCount": List<dynamic>.from(totalCount.map((x) => x.toJson())),
  };
}

class Categorycount {
  Categorycount({
    required this.coutn,
    required this.pickCategory,
  });

  String coutn;
  String pickCategory;

  factory Categorycount.fromJson(Map<String, dynamic> json) => Categorycount(
    coutn: json["coutn"],
    pickCategory: json["pick_category"],
  );

  Map<String, dynamic> toJson() => {
    "coutn": coutn,
    "pick_category": pickCategory,
  };
}

class TotalCount {
  TotalCount({
    required this.totalItem,
    required this.totalAmt,
    required this.totalCount,
  });

  String totalItem;
  String totalAmt;
  String totalCount;

  factory TotalCount.fromJson(Map<String, dynamic> json) => TotalCount(
    totalItem: json["total_item"],
    totalAmt: json["total_amt"],
    totalCount: json["total_count"],
  );

  Map<String, dynamic> toJson() => {
    "total_item": totalItem,
    "total_amt": totalAmt,
    "total_count": totalCount,
  };
}
