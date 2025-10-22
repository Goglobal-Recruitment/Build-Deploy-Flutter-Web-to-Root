class Airport {
  final String code; // IATA code (e.g., "JFK")
  final String name; // Full airport name
  final String city;
  final String country;

  const Airport({
    required this.code,
    required this.name,
    required this.city,
    required this.country,
  });

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      code: json['code'] as String,
      name: json['name'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'city': city,
      'country': country,
    };
  }

  @override
  String toString() => '$name ($code), $city, $country';
}

/// Example airports you can use for testing
const sampleAirports = <Airport>[
  Airport(code: 'JFK', name: 'John F. Kennedy International Airport', city: 'New York', country: 'USA'),
  Airport(code: 'LHR', name: 'Heathrow Airport', city: 'London', country: 'UK'),
  Airport(code: 'DXB', name: 'Dubai International Airport', city: 'Dubai', country: 'UAE'),
];