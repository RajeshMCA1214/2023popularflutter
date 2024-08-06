// To parse this JSON data, do
//
//     final pickDetailView = pickDetailViewFromJson(jsonString);

import 'dart:convert';

PickDetailView pickDetailViewFromJson(String str) => PickDetailView.fromJson(json.decode(str));

String pickDetailViewToJson(PickDetailView data) => json.encode(data.toJson());

class PickDetailView {
  PickDetailView({
    required this.isSuccess,
    required this.messages,
    required this.pickListMaster,
    required this.pickListDetails,
  });

  bool isSuccess;
  String messages;
  List<PickListMaster> pickListMaster;
  List<PickListDetails> pickListDetails;

  factory PickDetailView.fromJson(Map<String, dynamic> json) => PickDetailView(
    isSuccess: json["is_success"],
    messages: json["messages"],
    pickListMaster: List<PickListMaster>.from(json["PickListMaster"].map((x) => PickListMaster.fromJson(x))),
    pickListDetails: List<PickListDetails>.from(json["PickListDetails"].map((x) => PickListDetails.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "messages": messages,
    "PickListMaster": List<dynamic>.from(pickListMaster.map((x) => x.toJson())),
    "PickListDetails": List<dynamic>.from(pickListDetails.map((x) => x.toJson())),
  };
}

class PickListDetails {
  PickListDetails({
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
    required this.compulsory,
    required this.picklisttime,
    required this.telecaller,
    required this.pickStatus,
    required this.pickedQty,
    required this.pickedRate,
    required this.rTimestamp,
    required this.remarks,
    required this.recordStatus,
    required this.pickedDate,
    required this.pickedTime,
    required this.pendingQty,
  });

  String slno;
  String pickId;
  String partno;
  String? partname;
  String quantity;
  String rate;
  String stockqty;
  String rackno;
  String repcode;
  String pickCategory;
  String compulsory;
  String picklisttime;
  String telecaller;
  String pickStatus;
  String pickedQty;
  String pickedRate;
  DateTime rTimestamp;
  String remarks;
  String recordStatus;
  DateTime pickedDate;
  String pickedTime;
  String pendingQty;

  factory PickListDetails.fromJson(Map<String, dynamic> json) => PickListDetails(
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
    compulsory: json["compulsory"],
    picklisttime: json["picklisttime"],
    telecaller: json["telecaller"],
    pickStatus: json["pick_status"],
    pickedQty: json["picked_qty"],
    pickedRate: json["picked_rate"],
    rTimestamp: DateTime.parse(json["r_timestamp"]),
    remarks: json["remarks"],
    recordStatus: json["record_status"],
    pickedDate: DateTime.parse(json["picked_date"]),
    pickedTime: json["picked_time"],
    pendingQty: json["pending_qty"],
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
    "compulsory": compulsory,
    "picklisttime": picklisttime,
    "telecaller": telecaller,
    "pick_status": pickStatus,
    "picked_qty": pickedQty,
    "picked_rate":pickedRate,
    "r_timestamp": rTimestamp.toIso8601String(),
    "remarks": remarks,
    "record_status": recordStatus,
    "picked_date": "${pickedDate.year.toString().padLeft(4, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}",
    "picked_time": pickedTime,
    "pending_qty": pendingQty,
  };
}

class PickListMaster {
  PickListMaster({
    required this.slno,
    required this.pickId,
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
    required this.pickitemPendingQty,
    required this.totalAmt,
    required this.pickRate,
    required this.pickStatus,
    required this.totalbinqr,
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

  String slno;
  String pickId;
  String compcode;
  String billtype;
  String billno;
  DateTime billdate;
  String custcode;
  String custname;
  String repcode;
  String pickCategory;
  String picklisttime;
  String telecaller;
  String totalItemCount;
  String pickitemCompletedQty;
  String pickitemPendingQty;
  String totalAmt;
  String pickRate;
  String pickStatus;
  String totalbinqr;
  DateTime rTimestamp;
  String remarks;
  String recordStatus;
  String pickAssignedStatus;
  String pickerEmpCode;
  String? pickAssignDate;
  String pickCompletedDate;
  String pickAssignTime;
  String pickCompletedTime;
  String priority;

  factory PickListMaster.fromJson(Map<String, dynamic> json) => PickListMaster(
    slno: json["Slno"],
    pickId: json["pick_id"],
    compcode: json["compcode"],
    billtype: json["billtype"],
    billno: json["billno"],
    billdate: DateTime.parse(json["billdate"]),
    custcode: json["custcode"],
    custname: json["custname"],
    repcode: json["repcode"],
    pickCategory: json["pick_category"],
    picklisttime: json["picklisttime"],
    telecaller: json["telecaller"],
    totalItemCount: json["total_item_count"],
    pickitemCompletedQty: json["pickitem_completed_qty"],
    pickitemPendingQty: json["pickitem_pending_qty"],
    totalAmt: json["total_amt"],
    pickRate: json["picked_rate"],
    pickStatus: json["pick_status"],
    totalbinqr: json["total_bin_qr"],
    rTimestamp: DateTime.parse(json["r_timestamp"]),
    remarks: json["remarks"],
    recordStatus: json["record_status"],
    pickAssignedStatus: json["pick_assigned_status"],
    pickerEmpCode: json["picker_emp_code"],
    pickAssignDate: json["pick_assign_date"],
    pickCompletedDate: json["pick_completed_date"],
    pickAssignTime: json["pick_assign_time"],
    pickCompletedTime: json["pick_completed_time"],
    priority: json["priority"],
  );

  Map<String, dynamic> toJson() => {
    "Slno": slno,
    "pick_id": pickId,
    "compcode": compcode,
    "billtype": billtype,
    "billno": billno,
    "billdate": "${billdate.year.toString().padLeft(4, '0')}-${billdate.month.toString().padLeft(2, '0')}-${billdate.day.toString().padLeft(2, '0')}",
    "custcode": custcode,
    "custname": custname,
    "repcode": repcode,
    "pick_category": pickCategory,
    "picklisttime": picklisttime,
    "telecaller": telecaller,
    "total_item_count": totalItemCount,
    "pickitem_completed_qty": pickitemCompletedQty,
    "pickitem_pending_qty": pickitemPendingQty,
    "total_amt": totalAmt,
    "picked_rate": pickRate,
    "pick_status": pickStatus,
    "total_bin_qr": totalbinqr,
    "r_timestamp": rTimestamp.toIso8601String(),
    "remarks": remarks,
    "record_status": recordStatus,
    "pick_assigned_status": pickAssignedStatus,
    "picker_emp_code": pickerEmpCode,
    "pick_assign_date": pickAssignDate,
    "pick_completed_date": pickCompletedDate,
    "pick_assign_time": pickAssignTime,
    "pick_completed_time": pickCompletedTime,
    "priority": priority,
  };
}
