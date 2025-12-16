// To parse this JSON data, do
//
//     final restaurants = restaurantsFromJson(jsonString);

import 'dart:convert';

List<Restaurants> restaurantsFromJson(String str) => List<Restaurants>.from(json.decode(str).map((x) => Restaurants.fromJson(x)));

String restaurantsToJson(List<Restaurants> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Restaurants {
    Restaurants({
        this.restaurantId,
        this.restaurantName,
        this.restaurantAddress,
        this.restaurantContactNo,
        this.restaurantEmail,
        this.restaurantLogo,
        this.restaurantLongitude,
        this.restaurantLatitude,
        this.proprio,
    });

    String? restaurantId;
    String? restaurantName;
    String? restaurantAddress;
    String? restaurantContactNo;
    String? restaurantEmail;
    String? restaurantLogo;
    String? restaurantLongitude;
    String? restaurantLatitude;
    String? proprio;

    factory Restaurants.fromJson(Map<String, dynamic> json) => Restaurants(
        restaurantId: json["restaurant_id"],
        restaurantName: json["restaurant_name"],
        restaurantAddress: json["restaurant_address"],
        restaurantContactNo: json["restaurant_contact_no"],
        restaurantEmail: json["restaurant_email"],
        restaurantLogo: json["restaurant_logo"],
        restaurantLongitude: json["restaurant_longitude"],
        restaurantLatitude: json["restaurant_latitude"],
        proprio: json["proprio"],
    );

    Map<String, dynamic> toJson() => {
        "restaurant_id": restaurantId,
        "restaurant_name": restaurantName,
        "restaurant_address": restaurantAddress,
        "restaurant_contact_no": restaurantContactNo,
        "restaurant_email": restaurantEmail,
        "restaurant_logo": restaurantLogo,
        "restaurant_longitude": restaurantLongitude,
        "restaurant_latitude": restaurantLatitude,
        "proprio": proprio,
    };
}
