// To parse this JSON data, do
//
//     final cancellPickList = cancellPickListFromJson(jsonString);

import 'dart:convert';

CancellPickList cancellPickListFromJson(String str) => CancellPickList.fromJson(json.decode(str));

String cancellPickListToJson(CancellPickList data) => json.encode(data.toJson());

class CancellPickList {
  CancellPickList({
    required this.isSuccess,
    required this.messages,
    required this.cancelPickList,
  });

  bool isSuccess;
  String messages;
  List<CancelPickList> cancelPickList;

  factory CancellPickList.fromJson(Map<String, dynamic> json) => CancellPickList(
    isSuccess: json["is_success"],
    messages: json["messages"],
    cancelPickList: List<CancelPickList>.from(json["CancelPickList"].map((x) => CancelPickList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "messages": messages,
    "CancelPickList": List<dynamic>.from(cancelPickList.map((x) => x.toJson())),
  };
}

class CancelPickList {
  CancelPickList({
    required this.totalItemCount,
    required this.pickId,
    required this.billno,
    required this.billdate,
    required this.custcode,
    required this.custname,
    required this.picklisttime,
    required this.rTimestamp,
    required this.remarks,
    required this.pickStatus,
    required this.totalAmt,
  });

  String totalItemCount;
  String pickId;
  String billno;
  String billdate;
  String custcode;
  String custname;
  String picklisttime;
  String rTimestamp;
  String remarks;
  String pickStatus;
  String totalAmt;

  factory CancelPickList.fromJson(Map<String, dynamic> json) => CancelPickList(
    totalItemCount: json["total_item_count"],
    pickId: json["pick_id"],
    billno: json["billno"],
    billdate: json["billdate"],
    custcode: json["custcode"],
    custname: json["custname"],
    picklisttime: json["picklisttime"],
    rTimestamp: json["r_timestamp"],
    remarks: json["remarks"],
    pickStatus: json["pick_status"],
    totalAmt: json["total_amt"],
  );

  Map<String, dynamic> toJson() => {
    "total_item_count": totalItemCount,
    "pick_id": pickId,
    "billno": billno,
    "billdate": billdate,
    "custcode": custcode,
    "custname": custname,
    "picklisttime": picklisttime,
    "r_timestamp": rTimestamp,
    "remarks": remarks,
    "pick_status": pickStatus,
    "total_amt": totalAmt,
  };
}
