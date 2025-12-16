import 'dart:convert';
import 'package:ohresto/Structures/orderitem_structure.dart';
import 'package:http/http.dart' as http;



Future<List<Odets>>  viewdets(name) async {

  var url = Uri.parse("http://demoalito.mydevcloud.com/api/ordersdet.php");
  var data = {
    'user': name,
  };

  var res = await http.post(url, body: data);
  print("checking...");
  if (res.statusCode == 200) {
    final data = jsonDecode(res.body);
    print(data);
  }
  return odetsFromJson(res.body);
}
