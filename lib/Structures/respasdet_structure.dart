// To parse this JSON data, do
//
//     final repasdet = repasdetFromJson(jsonString);

import 'dart:convert';

List<Repasdets> repasdetFromJson(String str) => List<Repasdets>.from(json.decode(str).map((x) => Repasdets.fromJson(x)));

String repasdetToJson(List<Repasdets> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Repasdets {
    Repasdets({
        this.restaurantName,
        this.restaurantLogo,
        this.restaurantLongitude,
        this.restaurantLatitude,
        this.proprio,
    });

    String? restaurantName;
    String? restaurantLogo;
    String? restaurantLongitude;
    String? restaurantLatitude;
    String? proprio;

    factory Repasdets.fromJson(Map<String, dynamic> json) => Repasdets(
        restaurantName: json["restaurant_name"],
        restaurantLogo: json["restaurant_logo"],
        restaurantLongitude: json["restaurant_longitude"],
        restaurantLatitude: json["restaurant_latitude"],
        proprio: json["proprio"],
    );

    Map<String, dynamic> toJson() => {
        "restaurant_name": restaurantName,
        "restaurant_logo": restaurantLogo,
        "restaurant_longitude": restaurantLongitude,
        "restaurant_latitude": restaurantLatitude,
        "proprio": proprio,
    };
}
