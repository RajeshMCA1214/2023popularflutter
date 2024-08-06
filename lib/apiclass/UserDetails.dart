// To parse this JSON data, do
//
//     final userDetails = userDetailsFromJson(jsonString);

import 'dart:convert';

UserDetails userDetailsFromJson(String str) => UserDetails.fromJson(json.decode(str));

String userDetailsToJson(UserDetails data) => json.encode(data.toJson());

class UserDetails {
  UserDetails({
    required this.isSuccess,
    required this.messages,
    required this.userDetails,
  });

  bool isSuccess;
  String messages;
  List<UserDetail> userDetails;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
    isSuccess: json["is_success"],
    messages: json["messages"],
    userDetails: List<UserDetail>.from(json["UserDetails"].map((x) => UserDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "messages": messages,
    "UserDetails": List<dynamic>.from(userDetails.map((x) => x.toJson())),
  };
}

class UserDetail {
  UserDetail({
    required this.userId,
    required this.companyId,
    required this.warehouseId,
    required this.employeeCode,
    required this.username,
    required this.userGroup,
    required this.designation,
    required this.emailId,
    required this.mobileNo,
    required this.password,
    required this.createdBy,
    required this.updatedBy,
    required this.userImage,
    required this.timestamp,
    required this.recordStatus,
  });

  String userId;
  String companyId;
  String warehouseId;
  String employeeCode;
  String username;
  String userGroup;
  String designation;
  String emailId;
  String mobileNo;
  String password;
  String createdBy;
  String updatedBy;
  String userImage;
  DateTime timestamp;
  String recordStatus;

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
    userId: json["user_id"],
    companyId: json["company_id"],
    warehouseId: json["warehouse_id"],
    employeeCode: json["employee_code"],
    username: json["username"],
    userGroup: json["user_group"],
    designation: json["designation"],
    emailId: json["email_id"],
    mobileNo: json["mobile_no"],
    password: json["password"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    userImage: json["user_image"],
    timestamp: DateTime.parse(json["timestamp"]),
    recordStatus: json["record_status"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "company_id": companyId,
    "warehouse_id": warehouseId,
    "employee_code": employeeCode,
    "username": username,
    "user_group": userGroup,
    "designation": designation,
    "email_id": emailId,
    "mobile_no": mobileNo,
    "password": password,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "user_image": userImage,
    "timestamp": timestamp.toIso8601String(),
    "record_status": recordStatus,
  };
}
