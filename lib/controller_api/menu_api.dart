import 'dart:convert';
import 'package:ohresto/Structures/menu_structure.dart';
import 'package:http/http.dart' as http;
import 'package:ohresto/config.dart';

Future<List<Menus>> fetchmenus() async {
  String url = "${api_link}/menu.php";
  final response = await http.get(Uri.parse(url));
  print("checking...");
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print(data);
  }
  return  menusFromJson(response.body);
}
