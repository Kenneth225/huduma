import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ohresto/Structures/food.dart';
import 'package:ohresto/config.dart';

abstract class SearchRepository {
  Future<List<Recipe>> searchFoods(String query);
}

class SearchRepositoryImpl extends SearchRepository {
  @override
  Future<List<Recipe>> searchFoods(String query) async {
    var response =
        await http.get(Uri.parse('${api_link}/searchfood.php?q=$query'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<Recipe> recipes = Food.fromJson(data).recipes ?? [];
      return recipes;
    } else {
      throw Exception('Failed');
    }
  }
}
