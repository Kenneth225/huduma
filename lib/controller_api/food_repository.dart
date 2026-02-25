import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ohresto/Structures/food.dart';
import 'package:ohresto/config.dart';

abstract class FoodRepository {
  Future<List<Recipe>> getFoods();
}

class FoodRepositoryImpl extends FoodRepository {
 @override
Future<List<Recipe>> getFoods() async {
  var response =
      await http.get(Uri.parse('${api_link}/searchfood.php?q=#4'));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);

    List<Recipe> recipes =
        Food.fromJson(data).recipes ?? [];

    return recipes;
  } else {
    throw Exception('Failed');
  }
}
}

