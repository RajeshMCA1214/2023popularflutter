// To parse this JSON data, do
//
//     final report = reportFromJson(jsonString);

import 'dart:convert';

Report reportFromJson(String str) => Report.fromJson(json.decode(str));

String reportToJson(Report data) => json.encode(data.toJson());

class Report {
  bool isSuccess;
  String messages;
  List<Total> total;
  List<TotalCount> totalCount;

  Report({
    required this.isSuccess,
    required this.messages,
    required this.total,
    required this.totalCount,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
    isSuccess: json["is_success"],
    messages: json["messages"],
    total: List<Total>.from(json["Total"].map((x) => Total.fromJson(x))),
    totalCount: List<TotalCount>.from(json["TotalCount"].map((x) => TotalCount.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "messages": messages,
    "Total": List<dynamic>.from(total.map((x) => x.toJson())),
    "TotalCount": List<dynamic>.from(totalCount.map((x) => x.toJson())),
  };
}

class Total {
  String pickedQty;
  String pickedRate;
  String totalQty;
  String totalamt;
  String countPickId;

  Total({
    required this.pickedQty,
    required this.pickedRate,
    required this.totalQty,
    required this.totalamt,
    required this.countPickId,
  });

  factory Total.fromJson(Map<String, dynamic> json) => Total(
    pickedQty: json["pickedQty"],
    pickedRate: json["pickedRate"],
    totalQty: json["totalQty"],
    totalamt: json["totalamt"],
    countPickId: json["COUNT(pick_id)"],
  );

  Map<String, dynamic> toJson() => {
    "pickedQty": pickedQty,
    "pickedRate": pickedRate,
    "totalQty": totalQty,
    "totalamt": totalamt,
    "COUNT(pick_id)": countPickId,
  };
}

class TotalCount {
  String slno;
  String pickId;
  DateTime pickDate;
  Compcode compcode;
  Billtype billtype;
  String billno;
  Date billdate;
  String custcode;
  String custname;
  Repcode repcode;
  PickCategory pickCategory;
  String picklisttime;
  Telecaller telecaller;
  String totalItemCount;
  String pickitemCompletedQty;
  String pickedRate;
  String pickitemPendingQty;
  String totalAmt;
  PickStatus pickStatus;
  DateTime rTimestamp;
  String remarks;
  String recordStatus;
  String pickAssignedStatus;
  PickerEmpCode pickerEmpCode;
  DateTime pickAssignDate;
  dynamic pickCompletedDate;
  String pickAssignTime;
  String pickCompletedTime;
  String priority;

  TotalCount({
    required this.slno,
    required this.pickId,
    required this.pickDate,
    required this.compcode,
    required this.billtype,
    required this.billno,
    required this.billdate,
    required this.custcode,
    required this.custname,
    required this.repcode,
    required this.pickCategory,
    required this.picklisttime,
    required this.telecaller,
    required this.totalItemCount,
    required this.pickitemCompletedQty,
    required this.pickedRate,
    required this.pickitemPendingQty,
    required this.totalAmt,
    required this.pickStatus,
    required this.rTimestamp,
    required this.remarks,
    required this.recordStatus,
    required this.pickAssignedStatus,
    required this.pickerEmpCode,
    required this.pickAssignDate,
    required this.pickCompletedDate,
    required this.pickAssignTime,
    required this.pickCompletedTime,
    required this.priority,
  });

  factory TotalCount.fromJson(Map<String, dynamic> json) => TotalCount(
    slno: json["Slno"],
    pickId: json["pick_id"],
    pickDate: DateTime.parse(json["pick_date"]),
    compcode: compcodeValues.map[json["compcode"]]!,
    billtype: billtypeValues.map[json["billtype"]]!,
    billno: json["billno"],
    billdate: dateValues.map[json["billdate"]]!,
    custcode: json["custcode"],
    custname: json["custname"],
    repcode: repcodeValues.map[json["repcode"]]!,
    pickCategory: pickCategoryValues.map[json["pick_category"]]!,
    picklisttime: json["picklisttime"],
    telecaller: telecallerValues.map[json["telecaller"]]!,
    totalItemCount: json["total_item_count"],
    pickitemCompletedQty: json["pickitem_completed_qty"],
    pickedRate: json["picked_rate"],
    pickitemPendingQty: json["pickitem_pending_qty"],
    totalAmt: json["total_amt"],
    pickStatus: pickStatusValues.map[json["pick_status"]]!,
    rTimestamp: DateTime.parse(json["r_timestamp"]),
    remarks: json["remarks"],
    recordStatus: json["record_status"],
    pickAssignedStatus: json["pick_assigned_status"],
    pickerEmpCode: pickerEmpCodeValues.map[json["picker_emp_code"]]!,
    pickAssignDate: DateTime.parse(json["pick_assign_date"]),
    pickCompletedDate: json["pick_completed_date"],
    pickAssignTime: json["pick_assign_time"],
    pickCompletedTime: json["pick_completed_time"],
    priority: json["priority"],
  );

  Map<String, dynamic> toJson() => {
    "Slno": slno,
    "pick_id": pickId,
    "pick_date": "${pickDate.year.toString().padLeft(4, '0')}-${pickDate.month.toString().padLeft(2, '0')}-${pickDate.day.toString().padLeft(2, '0')}",
    "compcode": compcodeValues.reverse[compcode],
    "billtype": billtypeValues.reverse[billtype],
    "billno": billno,
    "billdate": dateValues.reverse[billdate],
    "custcode": custcode,
    "custname": custname,
    "repcode": repcodeValues.reverse[repcode],
    "pick_category": pickCategoryValues.reverse[pickCategory],
    "picklisttime": picklisttime,
    "telecaller": telecallerValues.reverse[telecaller],
    "total_item_count": totalItemCount,
    "pickitem_completed_qty": pickitemCompletedQty,
    "picked_rate": pickedRate,
    "pickitem_pending_qty": pickitemPendingQty,
    "total_amt": totalAmt,
    "pick_status": pickStatusValues.reverse[pickStatus],
    "r_timestamp": rTimestamp.toIso8601String(),
    "remarks": remarks,
    "record_status": recordStatus,
    "pick_assigned_status": pickAssignedStatus,
    "picker_emp_code": pickerEmpCodeValues.reverse[pickerEmpCode],
    "pick_assign_date": "${pickAssignDate.year.toString().padLeft(4, '0')}-${pickAssignDate.month.toString().padLeft(2, '0')}-${pickAssignDate.day.toString().padLeft(2, '0')}",
    "pick_completed_date": pickCompletedDate,
    "pick_assign_time": pickAssignTime,
    "pick_completed_time": pickCompletedTime,
    "priority": priority,
  };
}

enum Date { THE_00000000 }

final dateValues = EnumValues({
  "0000-00-00": Date.THE_00000000
});

enum Billtype { ROYL }

final billtypeValues = EnumValues({
  "ROYL": Billtype.ROYL
});

enum Compcode { MOTO }

final compcodeValues = EnumValues({
  "MOTO": Compcode.MOTO
});

enum PickCategory { ROUTE }

final pickCategoryValues = EnumValues({
  "ROUTE": PickCategory.ROUTE
});

enum PickStatus { COMPLETED, COMPLETE }

final pickStatusValues = EnumValues({
  "Complete": PickStatus.COMPLETE,
  "Completed": PickStatus.COMPLETED
});

enum PickerEmpCode { ROY1 }

final pickerEmpCodeValues = EnumValues({
  "ROY1": PickerEmpCode.ROY1
});

enum Repcode { V_PRABA_BU, SURESH_BUL, JAK_BULLET }

final repcodeValues = EnumValues({
  "JAK/BULLET": Repcode.JAK_BULLET,
  "SURESH/BUL": Repcode.SURESH_BUL,
  "V.PRABA/BU": Repcode.V_PRABA_BU
});

enum Telecaller { P7, P24 }

final telecallerValues = EnumValues({
  "P24": Telecaller.P24,
  "P7": Telecaller.P7
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
