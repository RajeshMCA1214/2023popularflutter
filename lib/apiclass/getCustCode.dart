// To parse this JSON data, do
//
//     final getcustcode = getcustcodeFromJson(jsonString);

import 'dart:convert';

List<Getcustcode> getcustcodeFromJson(String str) => List<Getcustcode>.from(json.decode(str).map((x) => Getcustcode.fromJson(x)));

String getcustcodeToJson(List<Getcustcode> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Getcustcode {
  int id;
  String customerName;
  String customerCode;
  dynamic customerType;
  String area;
  String address;
  String city;
  String state;
  String pincode;
  String? gstNo;
  String contactPerson;
  String? designation;
  String emailId;
  String mobileNo;
  String phoneNo;
  String branchCode;
  dynamic createdBy;
  dynamic updateBy;
  int recordStatus;
  DateTime createdAt;
  DateTime updatedAt;

  Getcustcode({
    required this.id,
    required this.customerName,
    required this.customerCode,
    required this.customerType,
    required this.area,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.gstNo,
    required this.contactPerson,
    required this.designation,
    required this.emailId,
    required this.mobileNo,
    required this.phoneNo,
    required this.branchCode,
    required this.createdBy,
    required this.updateBy,
    required this.recordStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Getcustcode.fromJson(Map<dynamic, dynamic> json) => Getcustcode(
    id: json["id"],
    customerName: json["customer_name"],
    customerCode: json["customer_code"],
    customerType: json["customer_type"],
    area: json["area"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    pincode: json["pincode"],
    gstNo: json["gst_no"],
    contactPerson: json["contact_person"],
    designation: json["designation"],
    emailId: json["email_id"],
    mobileNo: json["mobile_no"],
    phoneNo: json["phone_no"],
    branchCode: json["branch_code"],
    createdBy: json["created_by"],
    updateBy: json["update_by"],
    recordStatus: json["record_status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customer_name": customerName,
    "customer_code": customerCode,
    "customer_type": customerType,
    "area": area,
    "address": address,
    "city": city,
    "state": state,
    "pincode": pincode,
    "gst_no": gstNo,
    "contact_person": contactPerson,
    "designation": designation,
    "email_id": emailId,
    "mobile_no": mobileNo,
    "phone_no": phoneNo,
    "branch_code": branchCode,
    "created_by": createdBy,
    "update_by": updateBy,
    "record_status": recordStatus,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
