import 'dart:math';
import '../data/airport_airline_data.dart';
import '../data/mock_flights.dart';
import '../models/airport.dart';
import '../models/flight.dart';
import '../models/booking.dart';

class FlightService {
  // Sample airports data
  static final List<Airport> _airports = AirportData.airports
      .map((data) => Airport(
            code: data['code']!,
            name: data['name']!,
            city: data['city']!,
            country: data['country']!,
          ))
      .toList();

  // Sample airlines data
  static final List<Map<String, String>> _airlines = AirlineData.airlines;

  // Get all airports
  List<Airport> getAirports() => _airports;

  // Get airport by code
  Airport? getAirportByCode(String code) {
    try {
      return _airports.firstWhere((airport) => airport.code == code);
    } catch (e) {
      return null;
    }
  }

  // Get all airlines
  List<Map<String, String>> getAirlines() => _airlines;

  // Get mock flights
  List<Flight> getMockFlights() {
    return MockFlights.flights
        .map((data) => Flight.fromJson(data))
        .toList();
  }

  // Generate mock flights
  List<Flight> generateMockFlights({
    required String originCode,
    required String destinationCode,
    required DateTime date,
    int count = 50,
  }) {
    final List<Flight> flights = [];
    final Random random = Random();

    for (int i = 0; i < count; i++) {
      // Generate random departure time within the day
      final int hour = 6 + random.nextInt(15); // Between 6 AM and 9 PM
      final int minute = random.nextInt(4) * 15; // 0, 15, 30, or 45
      final DateTime departureTime = DateTime(
        date.year,
        date.month,
        date.day,
        hour,
        minute,
      );

      // Generate random flight duration (1-15 hours)
      final int durationHours = 1 + random.nextInt(15);
      final int durationMinutes = random.nextInt(4) * 15;
      final int totalDuration = durationHours * 60 + durationMinutes;

      // Calculate arrival time
      final DateTime arrivalTime = departureTime.add(Duration(minutes: totalDuration));

      // Determine stops (0-2)
      final int stops = random.nextInt(3);

      // Create segments
      final List<FlightSegment> segments = [];
      String currentOrigin = originCode;
      
      if (stops == 0) {
        // Direct flight
        final airline = _airlines[random.nextInt(_airlines.length)];
        segments.add(FlightSegment(
          originCode: currentOrigin,
          destinationCode: destinationCode,
          departureTime: departureTime,
          arrivalTime: arrivalTime,
          airlineCode: airline['code']!,
          airlineName: airline['name']!,
          aircraft: 'Boeing 7${random.nextInt(9)}7',
          duration: totalDuration,
        ));
      } else {
        // Flight with stops
        final int segmentDuration = totalDuration ~/ (stops + 1);
        DateTime currentDeparture = departureTime;
        
        for (int j = 0; j <= stops; j++) {
          final String segmentDestination = (j == stops) 
            ? destinationCode 
            : _airports[random.nextInt(_airports.length)].code;
            
          // Ensure we don't use the origin or destination as a stopover
          if (segmentDestination == originCode || segmentDestination == destinationCode) {
            continue;
          }
          
          final DateTime segmentArrival = currentDeparture.add(Duration(minutes: segmentDuration));
          final airline = _airlines[random.nextInt(_airlines.length)];
          
          segments.add(FlightSegment(
            originCode: currentOrigin,
            destinationCode: segmentDestination,
            departureTime: currentDeparture,
            arrivalTime: segmentArrival,
            airlineCode: airline['code']!,
            airlineName: airline['name']!,
            aircraft: 'Boeing 7${random.nextInt(9)}7',
            duration: segmentDuration,
          ));
          
          // Add layover time (30-120 minutes)
          if (j < stops) {
            final int layoverMinutes = 30 + random.nextInt(91);
            currentDeparture = segmentArrival.add(Duration(minutes: layoverMinutes));
            currentOrigin = segmentDestination;
          }
        }
      }

      // Generate fare options
      final List<FareOption> fareOptions = [
        FareOption(
          type: 'Light',
          price: 100.0 + (totalDuration * 0.5) + random.nextDouble() * 500,
          cabinClass: 'Economy',
          baggageAllowance: 0,
          isRefundable: false,
          refundPolicy: 'Non-refundable',
        ),
        FareOption(
          type: 'Standard',
          price: 150.0 + (totalDuration * 0.7) + random.nextDouble() * 600,
          cabinClass: 'Economy',
          baggageAllowance: 20,
          isRefundable: false,
          refundPolicy: 'Refundable with fee',
        ),
        FareOption(
          type: 'Flex',
          price: 250.0 + (totalDuration * 1.0) + random.nextDouble() * 800,
          cabinClass: 'Economy',
          baggageAllowance: 30,
          isRefundable: true,
          refundPolicy: 'Fully refundable',
        ),
      ];

      // Sort fare options by price
      fareOptions.sort((a, b) => a.price.compareTo(b.price));

      flights.add(Flight(
        id: 'FL${random.nextInt(10000)}',
        flightNumber: '${_airlines[random.nextInt(_airlines.length)]['code']!}${random.nextInt(900) + 100}',
        airlineCode: segments.first.airlineCode,
        airlineName: segments.first.airlineName,
        originCode: originCode,
        destinationCode: destinationCode,
        departureTime: departureTime,
        arrivalTime: arrivalTime,
        duration: totalDuration,
        stops: stops,
        segments: segments,
        fareOptions: fareOptions,
      ));
    }

    return flights;
  }

  // Search flights
  List<Flight> searchFlights({
    required String originCode,
    required String destinationCode,
    required DateTime date,
    int passengers = 1,
  }) {
    // First check if we have predefined mock flights for this route
    final List<Flight> predefinedFlights = MockFlights.flights
        .where((flightData) =>
            flightData['originCode'] == originCode &&
            flightData['destinationCode'] == destinationCode)
        .map((data) => Flight.fromJson(data))
        .toList();

    if (predefinedFlights.isNotEmpty) {
      return predefinedFlights;
    }

    // Otherwise generate mock flights
    return generateMockFlights(
      originCode: originCode,
      destinationCode: destinationCode,
      date: date,
    );
  }

  // Filter flights
  List<Flight> filterFlights({
    required List<Flight> flights,
    double? maxPrice,
    int? maxStops,
    String? airlineCode,
    int? maxDuration,
  }) {
    return flights.where((flight) {
      // Price filter
      if (maxPrice != null && flight.bestPrice > maxPrice) {
        return false;
      }
      
      // Stops filter
      if (maxStops != null && flight.stops > maxStops) {
        return false;
      }
      
      // Airline filter
      if (airlineCode != null && flight.airlineCode != airlineCode) {
        return false;
      }
      
      // Duration filter
      if (maxDuration != null && flight.duration > maxDuration) {
        return false;
      }
      
      return true;
    }).toList();
  }

  // Sort flights
  List<Flight> sortFlights(List<Flight> flights, FlightSortOption sortOption) {
    switch (sortOption) {
      case FlightSortOption.priceLowToHigh:
        return List.from(flights)..sort((a, b) => a.bestPrice.compareTo(b.bestPrice));
      case FlightSortOption.priceHighToLow:
        return List.from(flights)..sort((a, b) => b.bestPrice.compareTo(a.bestPrice));
      case FlightSortOption.durationShortToLong:
        return List.from(flights)..sort((a, b) => a.duration.compareTo(b.duration));
      case FlightSortOption.durationLongToShort:
        return List.from(flights)..sort((a, b) => b.duration.compareTo(a.duration));
      case FlightSortOption.departureEarlyToLate:
        return List.from(flights)..sort((a, b) => a.departureTime.compareTo(b.departureTime));
      case FlightSortOption.departureLateToEarly:
        return List.from(flights)..sort((a, b) => b.departureTime.compareTo(a.departureTime));
      default:
        return flights;
    }
  }

  // Generate booking reference
  String generateBookingReference() {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Random random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  // Create booking
  Booking createBooking({
    required Flight flight,
    required FareOption selectedFare,
    required List<Passenger> passengers,
  }) {
    return Booking(
      id: 'BKG${DateTime.now().millisecondsSinceEpoch}',
      bookingReference: generateBookingReference(),
      flight: flight,
      selectedFare: selectedFare,
      passengers: passengers,
      totalPrice: selectedFare.price * passengers.length,
      bookingDate: DateTime.now(),
      status: BookingStatus.confirmed,
    );
  }
}

enum FlightSortOption {
  priceLowToHigh,
  priceHighToLow,
  durationShortToLong,
  durationLongToShort,
  departureEarlyToLate,
  departureLateToEarly,
}