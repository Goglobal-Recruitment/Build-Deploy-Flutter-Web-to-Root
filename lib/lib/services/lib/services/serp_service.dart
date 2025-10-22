import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_keys.dart';

class SerpService {
  static Future<Map<String, dynamic>?> searchFlights(String query) async {
    final uri = Uri.parse(
      'https://serpapi.com/search.json?q=$query&engine=google_flights&api_key=${ApiKeys.serpApiKey}',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('SERP API error: ${response.statusCode}');
      return null;
    }
  }
}
