import '../models/flight.dart';
import '../models/airport.dart';

class Booking {
  final String id;
  final String bookingReference;
  final Flight flight;
  final FareOption selectedFare;
  final List<Passenger> passengers;
  final double totalPrice;
  final DateTime bookingDate;
  final BookingStatus status;

  const Booking({
    required this.id,
    required this.bookingReference,
    required this.flight,
    required this.selectedFare,
    required this.passengers,
    required this.totalPrice,
    required this.bookingDate,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    var passengersList = json['passengers'] as List;
    List<Passenger> passengers = passengersList
        .map((passenger) => Passenger.fromJson(passenger))
        .toList();

    return Booking(
      id: json['id'] as String,
      bookingReference: json['bookingReference'] as String,
      flight: Flight.fromJson(json['flight'] as Map<String, dynamic>),
      selectedFare: FareOption.fromJson(json['selectedFare'] as Map<String, dynamic>),
      passengers: passengers,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      bookingDate: DateTime.parse(json['bookingDate'] as String),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString() == 'BookingStatus.${json['status']}',
        orElse: () => BookingStatus.confirmed,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingReference': bookingReference,
      'flight': flight.toJson(),
      'selectedFare': selectedFare.toJson(),
      'passengers': passengers.map((passenger) => passenger.toJson()).toList(),
      'totalPrice': totalPrice,
      'bookingDate': bookingDate.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }
}

class Passenger {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String email;
  final String phone;

  const Passenger({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.email,
    required this.phone,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      email: json['email'] as String,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'email': email,
      'phone': phone,
    };
  }

  String get fullName => '$firstName $lastName';
}

enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed,
}