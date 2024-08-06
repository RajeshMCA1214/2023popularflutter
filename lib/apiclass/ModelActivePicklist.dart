// To parse this JSON data, do
//
//     final modelActivePicklist = modelActivePicklistFromJson(jsonString);

import 'package:home_service_provider/base/color_data.dart';
import 'dart:convert';
import 'dart:ui';


ModelActivePicklist modelActivePicklistFromJson(String str) => ModelActivePicklist.fromJson(json.decode(str));

String modelActivePicklistToJson(ModelActivePicklist data) => json.encode(data.toJson());

class ModelActivePicklist {
  ModelActivePicklist({
    required this.isSuccess,
    required this.messages,
    required this.assignedPickList,
  });

  bool isSuccess;
  String messages;
  List<AssignedPickList> assignedPickList;

  factory ModelActivePicklist.fromJson(Map<String, dynamic> json) => ModelActivePicklist(
    isSuccess: json["is_success"],
    messages: json["messages"],
    assignedPickList: List<AssignedPickList>.from(json["AssignedPickList"].map((x) => AssignedPickList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "messages": messages,
    "AssignedPickList": List<dynamic>.from(assignedPickList.map((x) => x.toJson())),
  };
}

class AssignedPickList{
  String? itemCnt;
  String? pickId;
  String? billno;
  String? billdate;
  String? custcode;
  String? Rapcode;
  String? custname;
  String? picklisttime;
  String? rTimestamp;
  String? pick_assign_datetime;
  String? pick_completed_datetime;
  String? remarks;
  String? pickStatus;
  String? pick_category;
  String? totalAmt;
  int? bgColor;
  int? bgError;
  Color? textColor;
  Color? errortextColor;

  AssignedPickList({
    required this.itemCnt,
    required this.pickId,
    required this.billno,
    required this.billdate,
    required this.custcode,
    required this.Rapcode,
    required this.custname,
    required this.picklisttime,
    required this.rTimestamp,
    required this.pick_assign_datetime,
    required this.pick_completed_datetime,
    required this.remarks,
    required this.pickStatus,
    required this.pick_category,
    required this.totalAmt,
    required this.bgColor,
    required this.bgError,
    required this.textColor,
    required this.errortextColor,
  });


  factory AssignedPickList.fromJson(Map<String, dynamic> json) => AssignedPickList(
    itemCnt: json["total_item_count"],
    pickId: json["pick_id"],
    billno: json["billno"],
    billdate: json["billdate"],
    custcode: json["custcode"],
    Rapcode: json["repcode"],
    custname: json["custname"],
    picklisttime: json["picklisttime"],
    rTimestamp: json["r_timestamp"],
    pick_assign_datetime: json["pick_assign_datetime"],
    pick_completed_datetime: json["pick_completed_datetime"],
    remarks: json["remarks"],
    pickStatus: json["pick_status"],
    pick_category: json["pick_category"],
    totalAmt: json["total_amt"],
    bgColor: 0xFFEEFCF0,
    bgError: 0xFFFFF3F3,
    textColor: success,
    errortextColor: error,
      );

  Map<String, dynamic> toJson() => {
    "itemCnt": itemCnt,
    "pick_id": pickId,
    "billno": billno,
    "billdate": billdate,
    "custcode": custcode,
    "repcode":Rapcode,
    "custname": custname,
    "picklisttime": picklisttime,
    "r_timestamp": rTimestamp,
    "pick_assign_datetime": pick_assign_datetime,
    "pick_completed_datetime": pick_completed_datetime,
    "remarks": remarks,
    "pick_status": pickStatus,
    "pick_category": pick_category,
    "totalAmt": totalAmt,
    "bgColor": bgColor,
    "bgError": bgError,
    "textColor": textColor,
    "errortextColor": errortextColor,
  };

  void removeAt(int index) {}
}
