import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ohresto/Structures/avis_structure.dart';

Future<List<Avis>> fetchavis(userName) async {
  var url = Uri.parse("http://demoalito.mydevcloud.com/api/avis.php");
  var data = {
    'user': userName,
  };

  var res = await http.post(url, body: data);
  print("checking...");
  if (res.statusCode == 200) {
    final data = jsonDecode(res.body);
    print(data);
  }
  return avisFromJson(res.body);
}
