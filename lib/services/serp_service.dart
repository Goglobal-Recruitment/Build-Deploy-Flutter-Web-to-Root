import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/env_config.dart';

class SerpService {
  /// Search for flights using SerpApi
  static Future<List<Map<String, dynamic>>> searchFlights({
    required String origin,
    required String destination,
    required String date,
    int passengers = 1,
  }) async {
    try {
      // Check if API key is configured
      if (EnvConfig.serpApiKey == 'YOUR_SERPAPI_KEY_HERE' || 
          EnvConfig.serpApiKey.isEmpty) {
        // Return mock data if no API key is configured
        return _getMockFlights(origin, destination, date, passengers);
      }

      final response = await http.get(
        Uri.parse(
          '${EnvConfig.serpApiBaseUrl}?engine=google_flights&'
          'departure_id=$origin&'
          'arrival_id=$destination&'
          'outbound_date=$date&'
          'currency=${EnvConfig.currencyCode}&'
          'adults=$passengers&'
          'api_key=${EnvConfig.serpApiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Extract flight data from the response
        if (data['best_flights'] != null) {
          return List<Map<String, dynamic>>.from(data['best_flights']);
        }
      }
      // Return mock data if API call fails
      return _getMockFlights(origin, destination, date, passengers);
    } catch (e) {
      // Return mock data if API fails
      return _getMockFlights(origin, destination, date, passengers);
    }
  }

  /// Get airline information using SerpApi
  static Future<Map<String, dynamic>?> getAirlineInfo(String airlineName) async {
    try {
      // Check if API key is configured
      if (EnvConfig.serpApiKey == 'YOUR_SERPAPI_KEY_HERE' || 
          EnvConfig.serpApiKey.isEmpty) {
        return null;
      }

      final response = await http.get(
        Uri.parse(
          '${EnvConfig.serpApiBaseUrl}?engine=google&'
          'q=$airlineName&'
          'api_key=${EnvConfig.serpApiKey}',
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
    // Parse the date to ensure we use current/future dates
    DateTime searchDate;
    try {
      List<String> dateParts = date.split('-');
      searchDate = DateTime(
        int.parse(dateParts[0]), 
        int.parse(dateParts[1]), 
        int.parse(dateParts[2])
      );
    } catch (e) {
      searchDate = DateTime.now().add(Duration(days: 7)); // Default to next week
    }

    // Ensure we don't use dates in the past
    if (searchDate.isBefore(DateTime.now())) {
      searchDate = DateTime.now().add(Duration(days: 1));
    }

    return [
      {
        'airline': 'South African Airways',
        'flight_number': 'SA123',
        'departure_time': '08:00',
        'arrival_time': '14:30',
        'duration': '6h 30m',
        'price': 7500.00,
        'stops': 0,
        'origin': origin,
        'destination': destination,
        'date': searchDate.toIso8601String().split('T')[0],
      },
      {
        'airline': 'British Airways',
        'flight_number': 'BA456',
        'departure_time': '12:00',
        'arrival_time': '19:45',
        'duration': '7h 45m',
        'price': 8200.00,
        'stops': 0,
        'origin': origin,
        'destination': destination,
        'date': searchDate.toIso8601String().split('T')[0],
      },
      {
        'airline': 'Emirates',
        'flight_number': 'EK789',
        'departure_time': '18:30',
        'arrival_time': '05:15',
        'duration': '10h 45m',
        'price': 9800.00,
        'stops': 1,
        'origin': origin,
        'destination': destination,
        'date': searchDate.toIso8601String().split('T')[0],
      },
      {
        'airline': 'Qatar Airways',
        'flight_number': 'QR321',
        'departure_time': '22:00',
        'arrival_time': '12:30',
        'duration': '14h 30m',
        'price': 11500.00,
        'stops': 1,
        'origin': origin,
        'destination': destination,
        'date': searchDate.toIso8601String().split('T')[0],
      },
      {
        'airline': 'Lufthansa',
        'flight_number': 'LH654',
        'departure_time': '06:30',
        'arrival_time': '18:45',
        'duration': '12h 15m',
        'price': 9200.00,
        'stops': 1,
        'origin': origin,
        'destination': destination,
        'date': searchDate.toIso8601String().split('T')[0],
      },
    ];
  }
}