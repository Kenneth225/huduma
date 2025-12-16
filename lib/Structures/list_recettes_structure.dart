// To parse this JSON data, do
//
//     final listRecette = listRecetteFromJson(jsonString);

import 'dart:convert';

List<ListRecette> listRecetteFromJson(String str) => List<ListRecette>.from(json.decode(str).map((x) => ListRecette.fromJson(x)));

String listRecetteToJson(List<ListRecette> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListRecette {
    ListRecette({
        this.id,
        this.picture,
        this.nom,
        this.explication,
    });

    String? id;
    String? picture;
    String? nom;
    String? explication;

    factory ListRecette.fromJson(Map<String, dynamic> json) => ListRecette(
        id: json["id"],
        picture: json["picture"],
        nom: json["nom"],
        explication: json["explication"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "picture": picture,
        "nom": nom,
        "explication": explication,
    };
}
