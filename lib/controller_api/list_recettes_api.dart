import 'dart:convert';
import 'package:ohresto/Structures/list_recettes_structure.dart';
import 'package:http/http.dart' as http;


Future<List<ListRecette>> fetchrecettes() async {
  String url = "http://demoalito.mydevcloud.com/api/listrecettes.php";
  final response = await http.get(Uri.parse(url));
  print("checking...");
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print(data);
  }
  return  listRecetteFromJson(response.body);
}
