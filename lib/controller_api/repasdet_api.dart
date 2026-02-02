import 'dart:convert';
import 'package:ohresto/Structures/respasdet_structure.dart';
import 'package:http/http.dart' as http;
import 'package:ohresto/config.dart';

Future<List<Repasdets>> getrestos(String aliments)async {
    var response =
        await http.get(Uri.parse('${api_link}/infoalimts.php?q=$aliments'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
         data = jsonDecode(response.body);
  print(data);
    } 
      return repasdetFromJson(response.body);
  
  }
 

