import 'dart:convert';

List<Menus> menusFromJson(String str) =>
    List<Menus>.from(json.decode(str).map((x) => Menus.fromJson(x)));

String menusToJson(List<Menus> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Menus {
  Menus({
    this.restaurantId,
    this.restaurantName,
    this.restaurantAddress,
    this.restaurantContactNo,
    this.restaurantEmail,
    this.restaurantLogo,
    this.proprio,
  });

  String? restaurantId;
  String? restaurantName;
  String? restaurantAddress;
  String? restaurantContactNo;
  String? restaurantEmail;
  String? restaurantLogo;
  String? proprio;

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
        restaurantId: json["restaurant_id"],
        restaurantName: json["restaurant_name"],
        restaurantAddress: json["restaurant_address"],
        restaurantContactNo: json["restaurant_contact_no"],
        restaurantEmail: json["restaurant_email"],
        restaurantLogo: json["restaurant_logo"],
        proprio: json["proprio"],
      );

  Map<String, dynamic> toJson() => {
        "restaurant_id": restaurantId,
        "restaurant_name": restaurantName,
        "restaurant_address": restaurantAddress,
        "restaurant_contact_no": restaurantContactNo,
        "restaurant_email": restaurantEmail,
        "restaurant_logo": restaurantLogo,
        "proprio": proprio,
      };
}
