// To parse this JSON data, do
//
//     final orders = ordersFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Orders> ordersFromJson(String str) => List<Orders>.from(json.decode(str).map((x) => Orders.fromJson(x)));

String ordersToJson(List<Orders> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Orders {
    Orders({
        @required this.orderId,
        @required this.proprio,
        @required this.clientName,
        @required this.orderDate,
        @required this.amount,
        @required this.orderAdresse,
        @required this.orderAdresseLon,
        @required this.orderAdresseLat,
        @required this.numberClient,
        @required this.orderStatus,
        @required this.orderIdUniq,
        @required this.orderIdUniqFile,
        @required this.repas,
        @required this.quantite,
    });

    String? orderId;
    String? proprio;
    String? clientName;
    DateTime? orderDate;
    String? amount;
    String? orderAdresse;
    String? orderAdresseLon;
    String? orderAdresseLat;
    String? numberClient;
    String? orderStatus;
    String? orderIdUniq;
    String? orderIdUniqFile;
    String? repas;
    String? quantite;

    factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        orderId: json["order_id"],
        proprio: json["proprio"],
        clientName: json["client_name"],
        orderDate: DateTime.parse(json["order_date"]),
        amount: json["amount"],
        orderAdresse: json["order_adresse"],
        orderAdresseLon: json["order_adresse_lon"],
        orderAdresseLat: json["order_adresse_lat"],
        numberClient: json["number_client"],
        orderStatus: json["order_status"],
        orderIdUniq: json["order_id_uniq"],
        orderIdUniqFile: json["order_id_uniq_file"],
        repas: json["repas"],
        quantite: json["quantite"],
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "proprio": proprio,
        "client_name": clientName,
        "order_date": orderDate,
        "amount": amount,
        "order_adresse": orderAdresse,
        "order_adresse_lon": orderAdresseLon,
        "order_adresse_lat": orderAdresseLat,
        "number_client": numberClient,
        "order_status": orderStatus,
        "order_id_uniq": orderIdUniq,
        "order_id_uniq_file": orderIdUniqFile,
        "repas": repas,
        "quantite": quantite,
    };
}
