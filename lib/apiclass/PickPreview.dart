// To parse this JSON data, do
//
//     final pickListPreview = pickListPreviewFromJson(jsonString);

import 'dart:convert';

PickListPreview pickListPreviewFromJson(String str) => PickListPreview.fromJson(json.decode(str));

String pickListPreviewToJson(PickListPreview data) => json.encode(data.toJson());

class PickListPreview {
  PickListPreview({
    required this.isSuccess,
    required this.messages,
    required this.pickPreview,
  });

  bool isSuccess;
  String messages;
  List<PickPreview> pickPreview;

  factory PickListPreview.fromJson(Map<String, dynamic> json) => PickListPreview(
    isSuccess: json["is_success"],
    messages: json["messages"],
    pickPreview: List<PickPreview>.from(json["PickPreview"].map((x) => PickPreview.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "messages": messages,
    "PickPreview": List<dynamic>.from(pickPreview.map((x) => x.toJson())),
  };
}

class PickPreview {
  PickPreview({
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
    required this.binQrcode,
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
  String binQrcode;
  DateTime rTimestamp;
  String remarks;
  String recordStatus;
  DateTime pickedDate;
  String pickedTime;

  factory PickPreview.fromJson(Map<String, dynamic> json) =>
      PickPreview(
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
        pickedRate: json["picked_rate"],
        shortageQty: json["shortage_qty"],
        binQrcode: json["bin_qrcode"],
        rTimestamp: DateTime.parse(json["r_timestamp"]),
        remarks: json["remarks"],
        recordStatus: json["record_status"],
        pickedDate: DateTime.parse(json["picked_date"]),
        pickedTime: json["picked_time"],
      );

  Map<String, dynamic> toJson() =>
      {
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
        "picked_rate": pickedRate,
        "shortage_qty": shortageQty,
        "bin_qrcode": binQrcode,
        "r_timestamp": rTimestamp.toIso8601String(),
        "remarks": remarks,
        "record_status": recordStatus,
        "picked_date": "${pickedDate.year.toString().padLeft(
            4, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate
            .day.toString().padLeft(2, '0')}",
        "picked_time": pickedTime,
      };

}
