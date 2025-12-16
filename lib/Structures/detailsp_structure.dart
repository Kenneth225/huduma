// To parse this JSON data, do
//
//     final detailsp = detailspFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Detailsp> detailspFromJson(String str) => List<Detailsp>.from(json.decode(str).map((x) => Detailsp.fromJson(x)));

String detailspToJson(List<Detailsp> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Detailsp {
    Detailsp({
        required this.photto,
        required this.restaurantAddress,
    });

    String photto;
    String restaurantAddress;

    factory Detailsp.fromJson(Map<String, dynamic> json) => Detailsp(
        photto: json["photto"],
        restaurantAddress: json["restaurant_address"],
    );

    Map<String, dynamic> toJson() => {
        "photto": photto,
        "restaurant_address": restaurantAddress,
    };
}
