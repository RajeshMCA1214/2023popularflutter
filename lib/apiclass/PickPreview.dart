// To parse this JSON data, do
//
//     final pickPreview = pickPreviewFromJson(jsonString);

import 'dart:convert';

PickPreview pickPreviewFromJson(String str) => PickPreview.fromJson(json.decode(str));

String pickPreviewToJson(PickPreview data) => json.encode(data.toJson());

class PickPreview {
  bool isSuccess;
  String messages;
  List<PickPreviewElement> pickPreview;

  PickPreview({
    required this.isSuccess,
    required this.messages,
    required this.pickPreview,
  });

  factory PickPreview.fromJson(Map<String, dynamic> json) => PickPreview(
    isSuccess: json["is_success"],
    messages: json["messages"],
    pickPreview: List<PickPreviewElement>.from(json["PickPreview"].map((x) => PickPreviewElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "messages": messages,
    "PickPreview": List<dynamic>.from(pickPreview.map((x) => x.toJson())),
  };
}

class PickPreviewElement {
  String partno;
  String pickQty;
  String pickedQty;
  String rate;
  String pickedTotalAmt;
  String pickedRate;
  String pickStatus;
  String rackno;
  String binQrcode;
  String stockqty;

  PickPreviewElement({
    required this.partno,
    required this.pickQty,
    required this.pickedQty,
    required this.rate,
    required this.pickedTotalAmt,
    required this.pickedRate,
    required this.pickStatus,
    required this.rackno,
    required this.binQrcode,
    required this.stockqty,
  });

  factory PickPreviewElement.fromJson(Map<String, dynamic> json) => PickPreviewElement(
    partno: json["partno"],
    pickQty: json["pick_qty"],
    pickedQty: json["picked_qty"],
    rate: json["rate"],
    pickedTotalAmt: json["picked_total_amt"],
    pickedRate: json["picked_rate"],
    pickStatus: json["pick_status"],
    rackno: json["rackno"],
    binQrcode: json["bin_qrcode"],
    stockqty: json["stockqty"],
  );

  Map<String, dynamic> toJson() => {
    "partno": partno,
    "pick_qty": pickQty,
    "picked_qty": pickedQty,
    "rate": rate,
    "picked_total_amt": pickedTotalAmt,
    "picked_rate": pickedRate,
    "pick_status": pickStatus,
    "rackno": rackno,
    "bin_qrcode": binQrcode,
    "stockqty": stockqty,
  };
}


