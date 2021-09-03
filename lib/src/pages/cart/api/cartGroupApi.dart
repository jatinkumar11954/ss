// To parse this JSON data, do
//
//     final CartGroupData = CartGroupDataFromMap(jsonString);

import 'dart:convert';

import 'package:ECom/src/models/productListApi.dart';

import 'CartData.dart';

class CartGroupData {
  CartGroupData({
    this.vendor,
    this.vendorDetails,
    this.items,
    this.subTotal,
    this.deliveryCharges,
    this.total,
  });
  final double subTotal;
  final double deliveryCharges;
  final double total;
  final String vendor;
  final VendorDetails vendorDetails;
  final List<Product> items;

  factory CartGroupData.fromJson(String str) =>
      CartGroupData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CartGroupData.fromMap(Map<String, dynamic> json) => CartGroupData(
        vendor: json["vendor"] == null ? null : json["vendor"],
        vendorDetails: json["vendorDetails"] == null
            ? null
            : VendorDetails.fromMap(json["vendorDetails"]),
        items: json["items"] == null
            ? null
            : List<Product>.from(json["items"].map((x) => Product.fromMap(x))),
        subTotal: json["subTotal"] == null
            ? null
            : double.parse(json["subTotal"].toString()),
        deliveryCharges: json["delivery_charges"] == null
            ? null
            : double.parse(json["delivery_charges"].toString()),
        total: json["total"] == null
            ? null
            : double.parse(json["total"].toString()),
      );

  Map<String, dynamic> toMap() => {
        "vendor": vendor == null ? null : vendor,
        "vendorDetails": vendorDetails == null ? null : vendorDetails.toMap(),
        "items": items == null
            ? null
            : List<dynamic>.from(items.map((x) => x.toMap())),
      };
}

class VendorDetails {
  VendorDetails({
    this.id,
    this.deliveryDetails,
    this.deliveryCharges,
    this.shipping_by,
  });

  final String id;
  final String shipping_by;
  final DeliveryDetails deliveryDetails;
  final DeliveryCharges deliveryCharges;

  factory VendorDetails.fromJson(String str) =>
      VendorDetails.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VendorDetails.fromMap(Map<String, dynamic> json) => VendorDetails(
        id: json["_id"] == null ? null : json["_id"],
        shipping_by: json["shipping_by"] == null ? null : json["shipping_by"],
        deliveryDetails: json["delivery_details"] == null
            ? null
            : DeliveryDetails.fromMap(json["delivery_details"]),
        deliveryCharges: json["delivery_charges"] == null
            ? null
            : DeliveryCharges.fromMap(json["delivery_charges"]),
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "delivery_details":
            deliveryDetails == null ? null : deliveryDetails.toMap(),
        "delivery_charges":
            deliveryCharges == null ? null : deliveryCharges.toMap(),
      };
}

class DeliveryCharges {
  DeliveryCharges({
    this.minOrderAmount,
    this.deliveryCharges,
  });

  final dynamic minOrderAmount;
  final int deliveryCharges;

  factory DeliveryCharges.fromJson(String str) =>
      DeliveryCharges.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DeliveryCharges.fromMap(Map<String, dynamic> json) => DeliveryCharges(
        minOrderAmount: json["min_order_amount"],
        deliveryCharges: json["delivery_charges"] == null
            ? null
            : int.parse(json["delivery_charges"].toString()),
      );

  Map<String, dynamic> toMap() => {
        "min_order_amount": minOrderAmount,
        "delivery_charges": deliveryCharges == null ? null : deliveryCharges,
      };
}

class DeliveryDetails {
  DeliveryDetails({
    this.daysOfSkip,
    this.deliveryHours,
    this.sundayDelivery,
  });

  final String daysOfSkip;
  final String deliveryHours;
  final bool sundayDelivery;

  factory DeliveryDetails.fromJson(String str) =>
      DeliveryDetails.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DeliveryDetails.fromMap(Map<String, dynamic> json) => DeliveryDetails(
        daysOfSkip: json["days_of_skip"] == null ? null : json["days_of_skip"],
        deliveryHours:
            json["delivery_hours"] == null ? null : json["delivery_hours"],
        sundayDelivery:
            json["sunday_delivery"] == null ? null : json["sunday_delivery"],
      );

  Map<String, dynamic> toMap() => {
        "days_of_skip": daysOfSkip == null ? null : daysOfSkip,
        "delivery_hours": deliveryHours == null ? null : deliveryHours,
        "sunday_delivery": sundayDelivery == null ? null : sundayDelivery,
      };
}
