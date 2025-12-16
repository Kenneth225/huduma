// To parse this JSON data, do
//
//     final odets = odetsFromJson(jsonString);

import 'dart:convert';

List<Odets> odetsFromJson(String str) => List<Odets>.from(json.decode(str).map((x) => Odets.fromJson(x)));

String odetsToJson(List<Odets> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Odets {
    Odets({
        this.id,
        this.repas,
        this.quantite,
        this.orderIdUniq,
    });

    String? id;
    String? repas;
    String? quantite;
    String? orderIdUniq;

    factory Odets.fromJson(Map<String, dynamic> json) => Odets(
        id: json["id"],
        repas: json["repas"],
        quantite: json["quantite"],
        orderIdUniq: json["order_id_uniq"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "repas": repas,
        "quantite": quantite,
        "order_id_uniq": orderIdUniq,
    };
}
