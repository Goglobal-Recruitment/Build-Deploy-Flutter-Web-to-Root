class Flight {
  final String id;
  final String flightNumber;
  final String airlineCode;
  final String airlineName;
  final String originCode;
  final String destinationCode;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final int duration; // in minutes
  final int stops;
  final List<FlightSegment> segments;
  final List<FareOption> fareOptions;

  const Flight({
    required this.id,
    required this.flightNumber,
    required this.airlineCode,
    required this.airlineName,
    required this.originCode,
    required this.destinationCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.stops,
    required this.segments,
    required this.fareOptions,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    var segmentsList = json['segments'] as List;
    List<FlightSegment> segments = segmentsList
        .map((segment) => FlightSegment.fromJson(segment))
        .toList();

    var fareOptionsList = json['fareOptions'] as List;
    List<FareOption> fareOptions = fareOptionsList
        .map((fare) => FareOption.fromJson(fare))
        .toList();

    return Flight(
      id: json['id'] as String,
      flightNumber: json['flightNumber'] as String,
      airlineCode: json['airlineCode'] as String,
      airlineName: json['airlineName'] as String,
      originCode: json['originCode'] as String,
      destinationCode: json['destinationCode'] as String,
      departureTime: DateTime.parse(json['departureTime'] as String),
      arrivalTime: DateTime.parse(json['arrivalTime'] as String),
      duration: json['duration'] as int,
      stops: json['stops'] as int,
      segments: segments,
      fareOptions: fareOptions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flightNumber': flightNumber,
      'airlineCode': airlineCode,
      'airlineName': airlineName,
      'originCode': originCode,
      'destinationCode': destinationCode,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'duration': duration,
      'stops': stops,
      'segments': segments.map((segment) => segment.toJson()).toList(),
      'fareOptions': fareOptions.map((fare) => fare.toJson()).toList(),
    };
  }

  // Get the best price among all fare options
  double get bestPrice {
    if (fareOptions.isEmpty) return 0.0;
    return fareOptions
        .map((fare) => fare.price)
        .reduce((a, b) => a < b ? a : b);
  }

  // Get badge type based on flight characteristics
  String get badgeType {
    if (stops == 0) return 'Direct';
    if (duration < 180) return 'Fastest'; // Less than 3 hours
    return 'Cheapest';
  }
}

class FlightSegment {
  final String originCode;
  final String destinationCode;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String airlineCode;
  final String airlineName;
  final String aircraft;
  final int duration; // in minutes

  const FlightSegment({
    required this.originCode,
    required this.destinationCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.airlineCode,
    required this.airlineName,
    required this.aircraft,
    required this.duration,
  });

  factory FlightSegment.fromJson(Map<String, dynamic> json) {
    return FlightSegment(
      originCode: json['originCode'] as String,
      destinationCode: json['destinationCode'] as String,
      departureTime: DateTime.parse(json['departureTime'] as String),
      arrivalTime: DateTime.parse(json['arrivalTime'] as String),
      airlineCode: json['airlineCode'] as String,
      airlineName: json['airlineName'] as String,
      aircraft: json['aircraft'] as String,
      duration: json['duration'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originCode': originCode,
      'destinationCode': destinationCode,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'airlineCode': airlineCode,
      'airlineName': airlineName,
      'aircraft': aircraft,
      'duration': duration,
    };
  }
}

class FareOption {
  final String type; // Light, Standard, Flex
  final double price;
  final String cabinClass;
  final int baggageAllowance; // in kg
  final bool isRefundable;
  final String refundPolicy;

  const FareOption({
    required this.type,
    required this.price,
    required this.cabinClass,
    required this.baggageAllowance,
    required this.isRefundable,
    required this.refundPolicy,
  });

  factory FareOption.fromJson(Map<String, dynamic> json) {
    return FareOption(
      type: json['type'] as String,
      price: (json['price'] as num).toDouble(),
      cabinClass: json['cabinClass'] as String,
      baggageAllowance: json['baggageAllowance'] as int,
      isRefundable: json['isRefundable'] as bool,
      refundPolicy: json['refundPolicy'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'price': price,
      'cabinClass': cabinClass,
      'baggageAllowance': baggageAllowance,
      'isRefundable': isRefundable,
      'refundPolicy': refundPolicy,
    };
  }
}