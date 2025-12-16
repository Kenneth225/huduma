// To parse this JSON data, do
//
//     final searchfood = searchfoodFromJson(jsonString);

import 'dart:convert';

List<Searchfood> searchfoodFromJson(String str) => List<Searchfood>.from(json.decode(str).map((x) => Searchfood.fromJson(x)));

String searchfoodToJson(List<Searchfood> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Searchfood {
    Searchfood({
        this.productId,
        this.categoryName,
        this.type,
        this.productName,
        this.productPrice,
        this.productStatus,
        this.productImage,
        this.proprio,
        this.alimts,
    });

    String? productId;
    String? categoryName;
    String? type;
    String? productName;
    String? productPrice;
    String? productStatus;
    String? productImage;
    String? proprio;
    String? alimts;

    factory Searchfood.fromJson(Map<String, dynamic> json) => Searchfood(
        productId: json["product_id"],
        categoryName: json["category_name"],
        type: json["Type"],
        productName: json["product_name"],
        productPrice: json["product_price"],
        productStatus: json["product_status"],
        productImage: json["product_image"],
        proprio: json["proprio"],
        alimts: json["alimts"],
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "category_name": categoryName,
        "Type": type,
        "product_name": productName,
        "product_price": productPrice,
        "product_status": productStatus,
        "product_image": productImage,
        "proprio": proprio,
        "alimts": alimts,
    };
}
