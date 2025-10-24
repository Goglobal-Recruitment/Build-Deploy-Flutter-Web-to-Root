import 'dart:convert';
import 'package:http/http.dart' as http;

class SerpService {
  // In a real implementation, you would use your actual SerpApi key
  static const String _apiKey = 'YOUR_SERPAPI_KEY_HERE';
  static const String _baseUrl = 'https://serpapi.com/search';

  /// Search for flights using SerpApi
  static Future<List<Map<String, dynamic>>> searchFlights({
    required String origin,
    required String destination,
    required String date,
    int passengers = 1,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl?engine=google_flights&'
          'departure_id=$origin&'
          'arrival_id=$destination&'
          'outbound_date=$date&'
          'currency=ZAR&'
          'adults=$passengers&'
          'api_key=$_apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Extract flight data from the response
        if (data['best_flights'] != null) {
          return List<Map<String, dynamic>>.from(data['best_flights']);
        }
      }
      return [];
    } catch (e) {
      // Return mock data if API fails
      return _getMockFlights(origin, destination, date, passengers);
    }
  }

  /// Get airline information using SerpApi
  static Future<Map<String, dynamic>?> getAirlineInfo(String airlineName) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl?engine=google&'
          'q=$airlineName&'
          'api_key=$_apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Mock data for when API is not available
  static List<Map<String, dynamic>> _getMockFlights(
    String origin,
    String destination,
    String date,
    int passengers,
  ) {
    return [
      {
        'airline': 'South African Airways',
        'flight_number': 'SA123',
        'departure_time': '08:00',
        'arrival_time': '14:30',
        'duration': '6h 30m',
        'price': 7500.00,
        'stops': 0,
      },
      {
        'airline': 'British Airways',
        'flight_number': 'BA456',
        'departure_time': '12:00',
        'arrival_time': '19:45',
        'duration': '7h 45m',
        'price': 8200.00,
        'stops': 0,
      },
      {
        'airline': 'Emirates',
        'flight_number': 'EK789',
        'departure_time': '18:30',
        'arrival_time': '05:15',
        'duration': '10h 45m',
        'price': 9800.00,
        'stops': 1,
      },
    ];
  }
}