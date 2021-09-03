// To parse this JSON data, do
//
//     final cities = citiesFromMap(jsonString);

import 'dart:convert';

class Cities {
  Cities({
    this.cities,
  });

  final List<String> cities;

  factory Cities.fromJson(String str) => Cities.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Cities.fromMap(Map<String, dynamic> json) => Cities(
        cities: json["data"] == null
            ? null
            : List<String>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "cities":
            cities == null ? null : List<dynamic>.from(cities.map((x) => x)),
      };
}
