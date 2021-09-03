// To parse this JSON data, do
//
//     final cartVerify = cartVerifyFromMap(jsonString);

import 'dart:convert';

import 'package:flutter/widgets.dart';

class CartVerify {
  CartVerify({
    this.status,
    this.message,
    this.userEarning,
  });

  final bool status;
  final String message;
  final List<EarningData> userEarning;

  factory CartVerify.fromJson(String str) =>
      CartVerify.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CartVerify.fromMap(Map<String, dynamic> json) => CartVerify(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        userEarning: json["userEarning"] == null
            ? null
            : List<EarningData>.from(
                json["userEarning"].map((x) => EarningData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "userEarning": userEarning == null
            ? null
            : List<dynamic>.from(userEarning.map((x) => x.toMap())),
      };
}

class MyEarningData extends ChangeNotifier {
  MyEarningData({
    this.count,
    this.earningList,
    this.page,
    this.limit,
    this.pages,
  });

  MyEarningData get earningListData => _earningListData;

  final int count;
  List<EarningData> earningList = [];
  int page;
  final int limit;
  final int pages;
  MyEarningData _earningListData;
  setProductListData(Map<String, dynamic> json) {
    _earningListData = MyEarningData.fromMap(json);
    notifyListeners();
  }

  increasePage(int pageI) {
    _earningListData.page = pageI;
    notifyListeners();
  }

  setData(
    List<EarningData> list,
  ) {
    earningList = [];
    earningList = list ?? [];
    notifyListeners();
  }

  addData(
    List<EarningData> list,
  ) {
    earningList.addAll(list ?? []);
    notifyListeners();
  }

  factory MyEarningData.fromJson(String str) =>
      MyEarningData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MyEarningData.fromMap(Map<String, dynamic> json) => MyEarningData(
        count: json["count"] == null ? null : json["count"],
        earningList: json["items"] == null
            ? null
            : List<EarningData>.from(
                json["items"].map((x) => EarningData.fromMap(x))),
        page: json["page"] == null ? null : json["page"],
        limit: json["limit"] == null ? null : json["limit"],
        pages: json["pages"] == null ? null : json["pages"],
      );

  Map<String, dynamic> toMap() => {
        "count": count == null ? null : count,
        "items": earningList == null
            ? null
            : List<dynamic>.from(earningList.map((x) => x.toMap())),
        "page": page == null ? null : page,
        "limit": limit == null ? null : limit,
        "pages": pages == null ? null : pages,
      };
}

class EarningData {
  EarningData(
      {this.id,
      this.userEarningId,
      this.pincode,
      this.amountPaid,
      this.phone,
      this.cashback_type,
      this.type,
      this.datecreated,
      this.cashbackAmount,
      this.cashbackPercent,
      this.weekId,
      this.createdon,
      this.description});

  final String id;
  final String type;
  final String cashback_type;
  final int userEarningId;
  final String pincode;
  String description;
  final int amountPaid;
  final String phone;
  final DateTime datecreated;
  final double cashbackAmount;
  final int cashbackPercent;
  final String weekId;
  final DateTime createdon;

  factory EarningData.fromJson(String str) =>
      EarningData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EarningData.fromMap(Map<String, dynamic> json) => EarningData(
        id: json["_id"] == null ? null : json["_id"],
        type: json["type"] == null ? null : json["type"],
        description: json["description"] == null ? null : json["description"],
        cashback_type:
            json["cashback_type"] == null ? null : json["cashback_type"],
        pincode: json["pincode"] == null ? null : json["pincode"],
        amountPaid: json["amount_paid"] == null ? null : json["amount_paid"],
        phone: json["phone"] == null ? null : json["phone"],
        datecreated: json["datecreated"] == null
            ? null
            : DateTime.parse(json["datecreated"]),
        cashbackAmount: json["cashback_amount"] == null
            ? null
            : double.parse(json["cashback_amount"].toString()),
        cashbackPercent: json["cashback_percent"] == null
            ? null
            : int.parse(json["cashback_percent"].toString()),
        weekId: json["weekId"] == null ? null : json["weekId"],
        createdon: json["createdon"] == null
            ? null
            : DateTime.parse(json["createdon"]),
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "id": userEarningId == null ? null : userEarningId,
        "pincode": pincode == null ? null : pincode,
        "amount_paid": amountPaid == null ? null : amountPaid,
        "phone": phone == null ? null : phone,
        "datecreated":
            datecreated == null ? null : datecreated.toIso8601String(),
        "cashback_amount": cashbackAmount == null ? null : cashbackAmount,
        "cashback_percent": cashbackPercent == null ? null : cashbackPercent,
        "weekId": weekId == null ? null : weekId,
        "createdon": createdon == null ? null : createdon.toIso8601String(),
      };
}
// To parse this JSON data, do
//
//     final cartVerify = cartVerifyFromMap(jsonString);

class UsedData {
  UsedData({
    this.totalEarned,
    this.totalUsed,
    this.balance,
  });

  final double totalEarned;
  final double totalUsed;
  final double balance;

  factory UsedData.fromJson(String str) => UsedData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UsedData.fromMap(Map<String, dynamic> json) => UsedData(
        totalEarned: json["TotalEarned"] == null
            ? null
            : double.parse(json["TotalEarned"].toString()),
        totalUsed: json["totalUsed"] == null
            ? null
            : double.parse(json["totalUsed"].toString()),
        balance: json["balance"] == null
            ? null
            : double.parse(json["balance"].toString()),
      );

  Map<String, dynamic> toMap() => {
        "TotalEarned": totalEarned == null ? null : totalEarned,
        "totalUsed": totalUsed == null ? null : totalUsed,
        "balance": balance == null ? null : balance,
      };
}
