import 'dart:convert';

import 'package:ohresto/Structures/resto_structure.dart';
import 'package:http/http.dart' as http;

Future<List<Restaurants>> fetchrestos() async {
  
  String url = "http://demoalito.mydevcloud.com/api/resto.php";
final response = await http.get(Uri.parse(url));
print("checking...");
if (response.statusCode == 200) {
  final data = jsonDecode(response.body);
  print(data);
  
}
return restaurantsFromJson(response.body);

}