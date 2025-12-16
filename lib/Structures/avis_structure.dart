// To parse this JSON data, do
//
//     final avis = avisFromJson(jsonString);

import 'dart:convert';

List<Avis> avisFromJson(String str) => List<Avis>.from(json.decode(str).map((x) => Avis.fromJson(x)));

String avisToJson(List<Avis> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Avis {
    Avis({
        this.id,
        this.note,
        this.comment,
        this.auteur,
        this.proprio,
    });

    String? id;
    String? note;
    String? comment;
    String? auteur;
    String? proprio;

    factory Avis.fromJson(Map<String, dynamic> json) => Avis(
        id: json["id"],
        note: json["note"],
        comment: json["comment"],
        auteur: json["auteur"],
        proprio: json["proprio"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "note": note,
        "comment": comment,
        "auteur": auteur,
        "proprio": proprio,
    };
}
