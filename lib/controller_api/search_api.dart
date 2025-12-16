import 'dart:convert';
import 'package:ohresto/Structures/search_structure.dart';
import 'package:http/http.dart' as http;

Future<List<Searchfood>>loadfood() async {
   
    var url = Uri.parse("http://demoalito.mydevcloud.com/api/searchfood.php");
    var data = {
      'tag': 'utap',
    };
    var res = await http.post(url, body: data);
    if (res.statusCode == 200) {
    final datas = jsonDecode(res.body);
    print(datas);
  }
  return searchfoodFromJson(res.body);
    
  }