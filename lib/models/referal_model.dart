// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

ReferalModel ReferalModelFromJson(String str) =>
    ReferalModel.fromJson(json.decode(str));

class ReferalModel {
  ReferalModel({
    this.reward,
    this.image,
    this.role,
    this.mobilenumber,
    this.phoneVerified,
    this.paidCourseNames,
    this.referLink,
    this.password,
    this.courseBuyId,
    this.couponCodeDetails,
    this.referralCode,
    this.paid,
    this.name,
    this.id,
    this.authType,
    this.payInPartsDetails,
    this.email,
    this.referCode,
  });

  int? reward;
  dynamic? image;
  String? role;
  String? mobilenumber;
  bool? phoneVerified;
  List<dynamic>? paidCourseNames;
  String? referLink;
  String? password;
  String? courseBuyId;
  Details? couponCodeDetails;
  String? referralCode;
  String? paid;
  String? name;
  String? id;
  String? authType;
  Details? payInPartsDetails;
  String? email;
  String? referCode;

  factory ReferalModel.fromJson(Map<String, dynamic> json) => ReferalModel(
        reward: json["reward"],
        image: json["image"],
        role: json["role"],
        mobilenumber: json["mobilenumber"],
        phoneVerified: json["phoneVerified"],
        paidCourseNames:
            List<dynamic>.from(json["paidCourseNames"].map((x) => x)),
        referLink: json["refer_link"],
        password: json["password"],
        courseBuyId: json["courseBuyID"],
        couponCodeDetails: Details.fromJson(json["couponCodeDetails"]),
        referralCode: json["referral_code"],
        paid: json["paid"],
        name: json["name"],
        id: json["id"],
        authType: json["authType"],
        payInPartsDetails: Details.fromJson(json["payInPartsDetails"]),
        email: json["email"],
        referCode: json["refer_code"],
      );

  factory ReferalModel.empty() {
    return ReferalModel(
        reward: 0,
        image: '',
        role: '',
        mobilenumber: '',
        phoneVerified: false,
        paidCourseNames: [],
        referLink: '',
        password: '',
        courseBuyId: '',
        couponCodeDetails: null,
        referralCode: '',
        paid: '',
        name: '',
        id: '',
        authType: '',
        payInPartsDetails: null,
        email: '',
        referCode: '');
  }
}

class Details {
  Details();

  factory Details.fromJson(Map<String, dynamic> json) => Details();
}