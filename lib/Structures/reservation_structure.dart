// To parse this JSON data, do
//
//     final reservation = reservationFromJson(jsonString);

import 'dart:convert';

List<Reservation> reservationFromJson(String str) => List<Reservation>.from(json.decode(str).map((x) => Reservation.fromJson(x)));

String reservationToJson(List<Reservation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reservation {
    Reservation({
        this.orderTime,
        this.clientName,
        this.restaurantName,
        this.orderDate,
        this.orderNbPlace,
        this.orderStatus,
        this.proprio,
    });

    String? orderTime;
    String? clientName;
    String? restaurantName;
    DateTime? orderDate;
    String? orderNbPlace;
    String? orderStatus;
     String? proprio;


    factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
        orderTime: json["order_time"],
        clientName: json["client_name"],
        restaurantName: json["restaurant_name"],
        orderDate: DateTime.parse(json["order_date"]),
        orderNbPlace: json["order_nb_place"],
        orderStatus: json["order_status"],
        proprio: json["proprio"],
    );

    Map<String, dynamic> toJson() => {
        "order_time": orderTime,
        "client_name": clientName,
        "restaurant_name": restaurantName,
        "order_date": orderDate?.toIso8601String(),
        "order_nb_place": orderNbPlace,
        "order_status": orderStatus,
         "proprio": proprio,
    };
}
