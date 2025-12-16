import 'dart:convert';

Food foodFromJson(String str) => Food.fromJson(json.decode(str));

String foodToJson(Food data) => json.encode(data.toJson());

class Food {
  Food({
    this.count,
    this.recipes,
  });

  int? count;
  List<Recipe>? recipes;

  // Si recipes est null dans le JSON, on initialise une liste vide
  factory Food.fromJson(Map<String, dynamic> json) => Food(
        count: json["count"],
        recipes: json["recipes"] != null
            ? List<Recipe>.from(json["recipes"].map((x) => Recipe.fromJson(x)))
            : <Recipe>[],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "recipes": List<dynamic>.from(recipes!.map((x) => x.toJson())),
      };
}

class Recipe {
  Recipe({
    required this.restaurantName,
    required this.restaurantLogo,
    required this.restaurantLongitude,
    required this.restaurantLatitude,
    required this.proprio,
  });

  String restaurantName;
  String restaurantLogo;
  String restaurantLongitude;
  String restaurantLatitude;
  String proprio;

  // Ici on transforme les champs null en string vide pour éviter les null
  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        restaurantName: json["restaurant_name"] ?? '',
        restaurantLogo: json["restaurant_logo"] ?? '',
        restaurantLongitude: json["restaurant_longitude"] ?? '',
        restaurantLatitude: json["restaurant_latitude"] ?? '',
        proprio: json["proprio"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "restaurant_name": restaurantName,
        "restaurant_logo": restaurantLogo,
        "restaurant_longitude": restaurantLongitude,
        "restaurant_latitude": restaurantLatitude,
        "proprio": proprio,
      };
}
