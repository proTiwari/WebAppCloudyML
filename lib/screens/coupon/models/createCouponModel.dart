// To parse this JSON data, do
//
//     final createCouponModel = createCouponModelFromJson(jsonString);

import 'dart:convert';

CreateCouponModel createCouponModelFromJson(String str) =>
    CreateCouponModel.fromJson(json.decode(str));

String createCouponModelToJson(CreateCouponModel data) =>
    json.encode(data.toJson());

class CreateCouponModel {
  CreateCouponModel({
    this.course,
    this.couponCode,
    this.couponType,
    this.couponValue,
    this.couponDescription,
    this.couponName,
    this.couponImage,
    this.couponStatus,
    this.couponExpiryDate,
    this.couponStartDate,
    this.validforhours,
  });

  String? course;
  String? couponCode;
  String? couponType;
  CouponValue? couponValue;
  String? couponDescription;
  String? couponName;
  String? couponImage;
  String? couponStatus;
  String? couponExpiryDate;
  String? couponStartDate;
  String? validforhours;

  factory CreateCouponModel.fromJson(Map<String, dynamic> json) =>
      CreateCouponModel(
        course: json['course'],
        couponCode: json["couponCode"],
        couponType: json["couponType"],
        couponValue: json["couponValue"] == null
            ? null
            : CouponValue.fromJson(json["couponValue"]),
        couponDescription: json["couponDescription"],
        couponName: json["couponName"],
        couponImage: json["couponImage"],
        couponStatus: json["couponStatus"],
        couponExpiryDate: json["couponExpiryDate"],
        couponStartDate: json["couponStartDate"],
        validforhours: json["validforhours"],
      );

  Map<String, dynamic> toJson() => {
        "course": course,
        "couponCode": couponCode,
        "couponType": couponType,
        "couponValue": couponValue?.toJson(),
        "couponDescription": couponDescription,
        "couponName": couponName,
        "couponImage": couponImage,
        "couponStatus": couponStatus,
        "couponExpiryDate": couponExpiryDate,
        "couponStartDate": couponStartDate,
        "validforhours": validforhours,
      };
}

class CouponValue {
  CouponValue({
    this.type,
    this.value,
  });

  String? type;
  String? value;

  factory CouponValue.fromJson(Map<String, dynamic> json) => CouponValue(
        type: json["type"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "value": value,
      };
}
