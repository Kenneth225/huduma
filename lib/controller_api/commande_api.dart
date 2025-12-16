import 'dart:convert';
import 'package:ohresto/Structures/commande_structure.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Orders>> fetchorders() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userName= prefs.getString('username');

  var url = Uri.parse("http://demoalito.mydevcloud.com/api/myorders.php");
  var data = {
    'user': userName,
  };

  var res = await http.post(url, body: data);
  print("checking...");
  if (res.statusCode == 200) {
    final data = jsonDecode(res.body);
    print(data);
  }
  return ordersFromJson(res.body);
}
