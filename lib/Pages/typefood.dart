class FoodItem {
  final String? title;
  final String? category;
  FoodItem({this.title, this.category});
}

List<FoodItem> loadFoodItem() {
  var fi = <FoodItem>[
    FoodItem(title: "Riz", category: "chine"),
    FoodItem(title: "CousCous", category: "chine"),
    FoodItem(title: "Macaronni", category: "chine"),
    FoodItem(title: "Pate de Mais", category: "chine")
  ];
  return fi;
}
