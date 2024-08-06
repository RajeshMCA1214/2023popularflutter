// To parse this JSON data, do
//
//     final binName = binNameFromJson(jsonString);

import 'dart:convert';

BinName binNameFromJson(String str) => BinName.fromJson(json.decode(str));

String binNameToJson(BinName data) => json.encode(data.toJson());

class BinName {
  bool isSuccess;
  String messages;
  List<BinNameElement> binName;

  BinName({
    required this.isSuccess,
    required this.messages,
    required this.binName,
  });

  factory BinName.fromJson(Map<String, dynamic> json) => BinName(
    isSuccess: json["is_success"],
    messages: json["messages"],
    binName: List<BinNameElement>.from(json["BinName"].map((x) => BinNameElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "messages": messages,
    "BinName": List<dynamic>.from(binName.map((x) => x.toJson())),
  };
}

class BinNameElement {
  String binId;
  String companyId;
  String warehouseId;
  String supplierCustomerId;
  BinType binType;
  String binName;
  String length;
  String breadth;
  String height;
  String sqft;
  dynamic rTimestamp;
  String recordStatus;

  BinNameElement({
    required this.binId,
    required this.companyId,
    required this.warehouseId,
    required this.supplierCustomerId,
    required this.binType,
    required this.binName,
    required this.length,
    required this.breadth,
    required this.height,
    required this.sqft,
    required this.rTimestamp,
    required this.recordStatus,
  });

  factory BinNameElement.fromJson(Map<String, dynamic> json) => BinNameElement(
    binId: json["bin_id"],
    companyId: json["company_id"],
    warehouseId: json["warehouse_id"],
    supplierCustomerId: json["supplier_customer_id"],
    binType: binTypeValues.map[json["bin_type"]]!,
    binName: json["bin_name"],
    length: json["length"],
    breadth: json["breadth"],
    height: json["height"],
    sqft: json["sqft"],
    rTimestamp: json["r_timestamp"],
    recordStatus: json["record_status"],
  );

  Map<String, dynamic> toJson() => {
    "bin_id": binId,
    "company_id": companyId,
    "warehouse_id": warehouseId,
    "supplier_customer_id": supplierCustomerId,
    "bin_type": binTypeValues.reverse[binType],
    "bin_name": binName,
    "length": length,
    "breadth": breadth,
    "height": height,
    "sqft": sqft,
    "r_timestamp": rTimestamp,
    "record_status": recordStatus,
  };
}

enum BinType { OUTWARD }

final binTypeValues = EnumValues({
  "Outward": BinType.OUTWARD
});

enum RTimestampEnum { THE_00000000000000 }

final rTimestampEnumValues = EnumValues({
  "0000-00-00 00:00:00": RTimestampEnum.THE_00000000000000
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
