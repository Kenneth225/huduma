// To parse this JSON data, do
//
//     final detail = detailFromJson(jsonString);

import 'dart:convert';

List<Detail> detailFromJson(String str) => List<Detail>.from(json.decode(str).map((x) => Detail.fromJson(x)));

String detailToJson(List<Detail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Detail {
    Detail({
        required this.photto,
        required this.restaurantLatitude,
        required this.restaurantLongitude,
        required this.restaurantAddress,
    });

    String photto;
    String restaurantLatitude;
    String restaurantLongitude;
    String restaurantAddress;

    factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        photto: json["photto"],
        restaurantLatitude: json["restaurant_latitude"],
        restaurantLongitude: json["restaurant_longitude"],
        restaurantAddress: json["restaurant_address"],
    );

    Map<String, dynamic> toJson() => {
        "photto": photto,
        "restaurant_latitude": restaurantLatitude,
        "restaurant_longitude": restaurantLongitude,
        "restaurant_address": restaurantAddress,
    };
}
