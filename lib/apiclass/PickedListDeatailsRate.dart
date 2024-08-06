// To parse this JSON data, do
//
//     final pickedListDetailsRate = pickedListDetailsRateFromJson(jsonString);

import 'dart:convert';

PickedListDetailsRate pickedListDetailsRateFromJson(String str) => PickedListDetailsRate.fromJson(json.decode(str));

String pickedListDetailsRateToJson(PickedListDetailsRate data) => json.encode(data.toJson());

class PickedListDetailsRate {
  PickedListDetailsRate({
    required this.isSuccess,
    required this.messages,
    required this.pickListMaster,
  });

  bool isSuccess;
  String messages;
  List<PickListMaster> pickListMaster;

  factory PickedListDetailsRate.fromJson(Map<String, dynamic> json) => PickedListDetailsRate(
    isSuccess: json["is_success"],
    messages: json["messages"],
    pickListMaster: List<PickListMaster>.from(json["PickListMaster"].map((x) => PickListMaster.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "messages": messages,
    "PickListMaster": List<dynamic>.from(pickListMaster.map((x) => x.toJson())),
  };
}

class PickListMaster {
  PickListMaster({
    required this.slno,
    required this.pickId,
    required this.partno,
    required this.partname,
    required this.quantity,
    required this.rate,
    required this.stockqty,
    required this.rackno,
    required this.repcode,
    required this.pickCategory,
    required this.picklisttime,
    required this.telecaller,
    required this.pickStatus,
    required this.pickedQty,
    required this.shortageQty,
    required this.rTimestamp,
    required this.remarks,
    required this.recordStatus,
    required this.pickedDate,
    required this.pickedTime,
  });

  String? slno;
  String? pickId;
  String? partno;
  String? partname;
  String? quantity;
  String? rate;
  String? stockqty;
  String? rackno;
  String? repcode;
  String? pickCategory;
  String? picklisttime;
  String? telecaller;
  String? pickStatus;
  String? pickedQty;
  String? shortageQty;
  DateTime? rTimestamp;
  String? remarks;
  String? recordStatus;
  DateTime? pickedDate;
  String? pickedTime;

  factory PickListMaster.fromJson(Map<String, dynamic> json) => PickListMaster(
    slno: json["Slno"],
    pickId: json["pick_id"],
    partno: json["partno"],
    partname: json["partname"],
    quantity: json["quantity"],
    rate: json["rate"],
    stockqty: json["stockqty"],
    rackno: json["rackno"],
    repcode: json["repcode"],
    pickCategory: json["pick_category"],
    picklisttime: json["picklisttime"],
    telecaller: json["telecaller"],
    pickStatus: json["pick_status"],
    pickedQty: json["picked_qty"],
    shortageQty: json["shortage_qty"],
    rTimestamp: DateTime.parse(json["r_timestamp"]),
    remarks: json["remarks"],
    recordStatus: json["record_status"],
    pickedDate: DateTime.parse(json["picked_date"]),
    pickedTime: json["picked_time"],
  );

  Map<String, dynamic> toJson() => {
    "Slno": slno,
    "pick_id": pickId,
    "partno": partno,
    "partname": partname,
    "quantity": quantity,
    "rate": rate,
    "stockqty": stockqty,
    "rackno": rackno,
    "repcode": repcode,
    "pick_category": pickCategory,
    "picklisttime": picklisttime,
    "telecaller": telecaller,
    "pick_status": pickStatus,
    "picked_qty": pickedQty,
    "shortage_qty": shortageQty,
    "r_timestamp": rTimestamp,
    "remarks": remarks,
    "record_status": recordStatus,
    "picked_date": pickedDate,
    "picked_time": pickedTime,
  };
}
