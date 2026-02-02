import 'dart:convert';

import 'package:ohresto/Structures/resto_structure.dart';
import 'package:http/http.dart' as http;
import 'package:ohresto/config.dart';

Future<List<Restaurants>> fetchrestos() async {
  
  String url = "${api_link}/resto.php";
final response = await http.get(Uri.parse(url));
print("checking...");
if (response.statusCode == 200) {
  final data = jsonDecode(response.body);
  print(data);
  
}
return restaurantsFromJson(response.body);

}