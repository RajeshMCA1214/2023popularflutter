// To parse this JSON data, do
//
//     final pickedDetailView = pickedDetailViewFromJson(jsonString);

import 'dart:convert';

PickedDetailView pickedDetailViewFromJson(String str) => PickedDetailView.fromJson(json.decode(str));

String pickedDetailViewToJson(PickedDetailView data) => json.encode(data.toJson());

class PickedDetailView {
  PickedDetailView({
    required this.isSuccess,
    required this.messages,
    required this.pickItem,
    required this.pickedList,
  });

  bool isSuccess;
  String messages;
  List<PickItem> pickItem;
  List<PickedList> pickedList;

  factory PickedDetailView.fromJson(Map<String, dynamic> json) => PickedDetailView(
    isSuccess: json["is_success"],
    messages: json["messages"],
    pickItem: List<PickItem>.from(json["PickItem"].map((x) => PickItem.fromJson(x))),
    pickedList: List<PickedList>.from(json["PickedList"].map((x) => PickedList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "messages": messages,
    "PickItem": List<dynamic>.from(pickItem.map((x) => x.toJson())),
    "PickedList": List<dynamic>.from(pickedList.map((x) => x.toJson())),
  };
}

class PickItem {
  PickItem({
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
    required this.pickedRate,
    required this.shortageQty,
    required this.rTimestamp,
    required this.remarks,
    required this.recordStatus,
    required this.pickedDate,
    required this.pickedTime,
  });

  String slno;
  String pickId;
  String partno;
  String partname;
  String quantity;
  String rate;
  String stockqty;
  String rackno;
  String repcode;
  String pickCategory;
  String picklisttime;
  String telecaller;
  String pickStatus;
  String pickedQty;
  String pickedRate;
  String shortageQty;
  DateTime rTimestamp;
  String remarks;
  String recordStatus;
  DateTime pickedDate;
  String pickedTime;

  factory PickItem.fromJson(Map<String, dynamic> json) => PickItem(
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
    pickedRate:json["picked_rate"],
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
    "picked_rate":pickedRate,
    "shortage_qty": shortageQty,
    "r_timestamp": rTimestamp.toIso8601String(),
    "remarks": remarks,
    "record_status": recordStatus,
    "picked_date": "${pickedDate.year.toString().padLeft(4, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}",
    "picked_time": pickedTime,
  };
}

class PickedList {
  PickedList({
    required this.slno,
    required this.pickId,
    required this.partno,
    required this.rate,
    required this.pickedRate,
    required this.rackQrcode,
    required this.partQrcode,
    required this.binQrcode,
    required this.pickedQty,
    required this.rTimestamp,
    required this.recordStatus,
    required this.pickstatus,
    required this.pickedtotalamt,
    required this.pickedDate,
    required this.pickedTime,
  });

  String slno;
  String pickId;
  String partno;
  String rate;
  String pickedRate;
  String rackQrcode;
  String partQrcode;
  String binQrcode;
  String pickedQty;
  DateTime rTimestamp;
  String recordStatus;
  String pickstatus;
  String pickedtotalamt;
  DateTime pickedDate;
  String pickedTime;

  factory PickedList.fromJson(Map<String, dynamic> json) => PickedList(
    slno: json["Slno"],
    pickId: json["pick_id"],
    partno: json["partno"],
    rate: json["rate"],
    pickedRate: json["picked_rate"],
    rackQrcode: json["rack_qrcode"],
    partQrcode: json["part_qrcode"],
    binQrcode: json["bin_qrcode"],
    pickedQty: json["picked_qty"],
    rTimestamp: DateTime.parse(json["r_timestamp"]),
    recordStatus: json["record_status"],
    pickstatus: json["pick_status"],
    pickedtotalamt: json["picked_total_amt"],
    pickedDate: DateTime.parse(json["picked_date"]),
    pickedTime: json["picked_time"],
  );

  Map<String, dynamic> toJson() => {
    "Slno": slno,
    "pick_id": pickId,
    "partno": partno,
    "rate": rate,
    "picked_rate": pickedRate,
    "rack_qrcode": rackQrcode,
    "part_qrcode": partQrcode,
    "bin_qrcode": binQrcode,
    "picked_qty": pickedQty,
    "r_timestamp": rTimestamp.toIso8601String(),
    "record_status": recordStatus,
    "pick_status": pickstatus,
    "picked_total_amt":pickedtotalamt,
    "picked_date": "${pickedDate.year.toString().padLeft(4, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}",
    "picked_time": pickedTime,
  };
}
