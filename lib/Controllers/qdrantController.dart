import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ingestion_app/endpoints/qdrant_endpoints.dart';

class qdrantController {
  // static Future<List<dynamic>> getSources() async {
  //   Uri sourcesUrl = Uri.parse(QdrantEndpoints.getSources());
  //   //print(sourcesUrl);
  //   final response = await http.get(sourcesUrl);
  //   //print(response.body);
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     return List<String>.from(data);
  //   } else {
  //     return ["failed to load Data"];
  //   }
  // }

  static Future<Map<String, dynamic>> getSources() async {
    Uri sourcesUrl = Uri.parse(QdrantEndpoints.getSources());
    //print(sourcesUrl);
    final response = await http.get(sourcesUrl);
    //print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['sources'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load sources');
    }
  }

  static Future<void> deleteDocument(String filename) async {
    Uri deletePointsUrl = Uri.parse(QdrantEndpoints.deleteDocument())
        .replace(queryParameters: {"source": filename});
    print(deletePointsUrl);
    final response = await http.get(deletePointsUrl); 
    //print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      return jsonDecode(response.statusCode.toString());
    }
  }
}
