import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchData(String apiUrl, Map<String, String> data) async {
  var response = await http.post(Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'}, body: json.encode(data));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}

