// Mock flight data with realistic routes and pricing in South African Rands (ZAR)
// This file contains sample flight data for demonstration purposes

class MockFlights {
  static const List<Map<String, dynamic>> flights = [
    // JFK to LHR (New York to London)
    {
      'id': 'FL001',
      'flightNumber': 'BA178',
      'airlineCode': 'BA',
      'airlineName': 'British Airways',
      'originCode': 'JFK',
      'destinationCode': 'LHR',
      'departureTime': '2025-11-15T18:30:00',
      'arrivalTime': '2025-11-16T06:45:00',
      'duration': 405, // 6h 45m
      'stops': 0,
      'segments': [
        {
          'originCode': 'JFK',
          'destinationCode': 'LHR',
          'departureTime': '2025-11-15T18:30:00',
          'arrivalTime': '2025-11-16T06:45:00',
          'airlineCode': 'BA',
          'airlineName': 'British Airways',
          'aircraft': 'Boeing 777',
          'duration': 405,
        }
      ],
      'fareOptions': [
        {
          'type': 'Light',
          'price': 8500.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 0,
          'isRefundable': false,
          'refundPolicy': 'Non-refundable',
        },
        {
          'type': 'Standard',
          'price': 12500.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 20,
          'isRefundable': false,
          'refundPolicy': 'Refundable with fee',
        },
        {
          'type': 'Flex',
          'price': 18500.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 30,
          'isRefundable': true,
          'refundPolicy': 'Fully refundable',
        }
      ]
    },
    
    // JFK to CDG (New York to Paris)
    {
      'id': 'FL002',
      'flightNumber': 'AF021',
      'airlineCode': 'AF',
      'airlineName': 'Air France',
      'originCode': 'JFK',
      'destinationCode': 'CDG',
      'departureTime': '2025-11-15T21:15:00',
      'arrivalTime': '2025-11-16T11:30:00',
      'duration': 435, // 7h 15m
      'stops': 0,
      'segments': [
        {
          'originCode': 'JFK',
          'destinationCode': 'CDG',
          'departureTime': '2025-11-15T21:15:00',
          'arrivalTime': '2025-11-16T11:30:00',
          'airlineCode': 'AF',
          'airlineName': 'Air France',
          'aircraft': 'Airbus A350',
          'duration': 435,
        }
      ],
      'fareOptions': [
        {
          'type': 'Light',
          'price': 8200.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 0,
          'isRefundable': false,
          'refundPolicy': 'Non-refundable',
        },
        {
          'type': 'Standard',
          'price': 11200.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 20,
          'isRefundable': false,
          'refundPolicy': 'Refundable with fee',
        },
        {
          'type': 'Flex',
          'price': 17200.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 30,
          'isRefundable': true,
          'refundPolicy': 'Fully refundable',
        }
      ]
    },
    
    // LHR to DXB (London to Dubai)
    {
      'id': 'FL003',
      'flightNumber': 'EK003',
      'airlineCode': 'EK',
      'airlineName': 'Emirates',
      'originCode': 'LHR',
      'destinationCode': 'DXB',
      'departureTime': '2025-11-16T13:45:00',
      'arrivalTime': '2025-11-16T23:15:00',
      'duration': 390, // 6h 30m
      'stops': 0,
      'segments': [
        {
          'originCode': 'LHR',
          'destinationCode': 'DXB',
          'departureTime': '2025-11-16T13:45:00',
          'arrivalTime': '2025-11-16T23:15:00',
          'airlineCode': 'EK',
          'airlineName': 'Emirates',
          'aircraft': 'Boeing 777',
          'duration': 390,
        }
      ],
      'fareOptions': [
        {
          'type': 'Light',
          'price': 7800.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 0,
          'isRefundable': false,
          'refundPolicy': 'Non-refundable',
        },
        {
          'type': 'Standard',
          'price': 10800.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 20,
          'isRefundable': false,
          'refundPolicy': 'Refundable with fee',
        },
        {
          'type': 'Flex',
          'price': 16800.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 30,
          'isRefundable': true,
          'refundPolicy': 'Fully refundable',
        }
      ]
    },
    
    // DXB to SIN (Dubai to Singapore)
    {
      'id': 'FL004',
      'flightNumber': 'SQ491',
      'airlineCode': 'SQ',
      'airlineName': 'Singapore Airlines',
      'originCode': 'DXB',
      'destinationCode': 'SIN',
      'departureTime': '2025-11-17T02:30:00',
      'arrivalTime': '2025-11-17T12:45:00',
      'duration': 435, // 7h 15m
      'stops': 0,
      'segments': [
        {
          'originCode': 'DXB',
          'destinationCode': 'SIN',
          'departureTime': '2025-11-17T02:30:00',
          'arrivalTime': '2025-11-17T12:45:00',
          'airlineCode': 'SQ',
          'airlineName': 'Singapore Airlines',
          'aircraft': 'Airbus A380',
          'duration': 435,
        }
      ],
      'fareOptions': [
        {
          'type': 'Light',
          'price': 8100.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 0,
          'isRefundable': false,
          'refundPolicy': 'Non-refundable',
        },
        {
          'type': 'Standard',
          'price': 11100.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 20,
          'isRefundable': false,
          'refundPolicy': 'Refundable with fee',
        },
        {
          'type': 'Flex',
          'price': 17100.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 30,
          'isRefundable': true,
          'refundPolicy': 'Fully refundable',
        }
      ]
    },
    
    // SIN to SYD (Singapore to Sydney)
    {
      'id': 'FL005',
      'flightNumber': 'QF012',
      'airlineCode': 'QF',
      'airlineName': 'Qantas',
      'originCode': 'SIN',
      'destinationCode': 'SYD',
      'departureTime': '2025-11-17T15:20:00',
      'arrivalTime': '2025-11-17T22:30:00',
      'duration': 370, // 6h 10m
      'stops': 0,
      'segments': [
        {
          'originCode': 'SIN',
          'destinationCode': 'SYD',
          'departureTime': '2025-11-17T15:20:00',
          'arrivalTime': '2025-11-17T22:30:00',
          'airlineCode': 'QF',
          'airlineName': 'Qantas',
          'aircraft': 'Boeing 787',
          'duration': 370,
        }
      ],
      'fareOptions': [
        {
          'type': 'Light',
          'price': 7900.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 0,
          'isRefundable': false,
          'refundPolicy': 'Non-refundable',
        },
        {
          'type': 'Standard',
          'price': 10900.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 20,
          'isRefundable': false,
          'refundPolicy': 'Refundable with fee',
        },
        {
          'type': 'Flex',
          'price': 16900.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 30,
          'isRefundable': true,
          'refundPolicy': 'Fully refundable',
        }
      ]
    },
    
    // HND to LAX (Tokyo to Los Angeles)
    {
      'id': 'FL006',
      'flightNumber': 'JL005',
      'airlineCode': 'JL',
      'airlineName': 'Japan Airlines',
      'originCode': 'HND',
      'destinationCode': 'LAX',
      'departureTime': '2025-11-18T16:45:00',
      'arrivalTime': '2025-11-18T11:30:00',
      'duration': 645, // 10h 45m
      'stops': 0,
      'segments': [
        {
          'originCode': 'HND',
          'destinationCode': 'LAX',
          'departureTime': '2025-11-18T16:45:00',
          'arrivalTime': '2025-11-18T11:30:00',
          'airlineCode': 'JL',
          'airlineName': 'Japan Airlines',
          'aircraft': 'Boeing 777',
          'duration': 645,
        }
      ],
      'fareOptions': [
        {
          'type': 'Light',
          'price': 9200.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 0,
          'isRefundable': false,
          'refundPolicy': 'Non-refundable',
        },
        {
          'type': 'Standard',
          'price': 13200.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 20,
          'isRefundable': false,
          'refundPolicy': 'Refundable with fee',
        },
        {
          'type': 'Flex',
          'price': 19200.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 30,
          'isRefundable': true,
          'refundPolicy': 'Fully refundable',
        }
      ]
    },
    
    // LAX to JFK (Los Angeles to New York)
    {
      'id': 'FL007',
      'flightNumber': 'AA025',
      'airlineCode': 'AA',
      'airlineName': 'American Airlines',
      'originCode': 'LAX',
      'destinationCode': 'JFK',
      'departureTime': '2025-11-19T08:30:00',
      'arrivalTime': '2025-11-19T16:45:00',
      'duration': 315, // 5h 15m
      'stops': 0,
      'segments': [
        {
          'originCode': 'LAX',
          'destinationCode': 'JFK',
          'departureTime': '2025-11-19T08:30:00',
          'arrivalTime': '2025-11-19T16:45:00',
          'airlineCode': 'AA',
          'airlineName': 'American Airlines',
          'aircraft': 'Boeing 737',
          'duration': 315,
        }
      ],
      'fareOptions': [
        {
          'type': 'Light',
          'price': 6800.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 0,
          'isRefundable': false,
          'refundPolicy': 'Non-refundable',
        },
        {
          'type': 'Standard',
          'price': 8800.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 20,
          'isRefundable': false,
          'refundPolicy': 'Refundable with fee',
        },
        {
          'type': 'Flex',
          'price': 14800.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 30,
          'isRefundable': true,
          'refundPolicy': 'Fully refundable',
        }
      ]
    },
    
    // JFK to FRA (New York to Frankfurt) with connection in LHR
    {
      'id': 'FL008',
      'flightNumber': 'BA081',
      'airlineCode': 'BA',
      'airlineName': 'British Airways',
      'originCode': 'JFK',
      'destinationCode': 'FRA',
      'departureTime': '2025-11-20T10:15:00',
      'arrivalTime': '2025-11-21T08:30:00',
      'duration': 465, // 7h 45m + layover
      'stops': 1,
      'segments': [
        {
          'originCode': 'JFK',
          'destinationCode': 'LHR',
          'departureTime': '2025-11-20T10:15:00',
          'arrivalTime': '2025-11-20T22:30:00',
          'airlineCode': 'BA',
          'airlineName': 'British Airways',
          'aircraft': 'Boeing 777',
          'duration': 405,
        },
        {
          'originCode': 'LHR',
          'destinationCode': 'FRA',
          'departureTime': '2025-11-21T06:15:00',
          'arrivalTime': '2025-11-21T08:30:00',
          'airlineCode': 'BA',
          'airlineName': 'British Airways',
          'aircraft': 'Airbus A320',
          'duration': 90,
        }
      ],
      'fareOptions': [
        {
          'type': 'Light',
          'price': 8800.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 0,
          'isRefundable': false,
          'refundPolicy': 'Non-refundable',
        },
        {
          'type': 'Standard',
          'price': 11800.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 20,
          'isRefundable': false,
          'refundPolicy': 'Refundable with fee',
        },
        {
          'type': 'Flex',
          'price': 17800.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 30,
          'isRefundable': true,
          'refundPolicy': 'Fully refundable',
        }
      ]
    },
    
    // FRA to DEL (Frankfurt to New Delhi)
    {
      'id': 'FL009',
      'flightNumber': 'LH765',
      'airlineCode': 'LH',
      'airlineName': 'Lufthansa',
      'originCode': 'FRA',
      'destinationCode': 'DEL',
      'departureTime': '2025-11-21T12:45:00',
      'arrivalTime': '2025-11-22T01:30:00',
      'duration': 525, // 8h 45m
      'stops': 0,
      'segments': [
        {
          'originCode': 'FRA',
          'destinationCode': 'DEL',
          'departureTime': '2025-11-21T12:45:00',
          'arrivalTime': '2025-11-22T01:30:00',
          'airlineCode': 'LH',
          'airlineName': 'Lufthansa',
          'aircraft': 'Airbus A380',
          'duration': 525,
        }
      ],
      'fareOptions': [
        {
          'type': 'Light',
          'price': 9100.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 0,
          'isRefundable': false,
          'refundPolicy': 'Non-refundable',
        },
        {
          'type': 'Standard',
          'price': 12100.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 20,
          'isRefundable': false,
          'refundPolicy': 'Refundable with fee',
        },
        {
          'type': 'Flex',
          'price': 18100.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 30,
          'isRefundable': true,
          'refundPolicy': 'Fully refundable',
        }
      ]
    },
    
    // DEL to SIN (New Delhi to Singapore)
    {
      'id': 'FL010',
      'flightNumber': 'SQ481',
      'airlineCode': 'SQ',
      'airlineName': 'Singapore Airlines',
      'originCode': 'DEL',
      'destinationCode': 'SIN',
      'departureTime': '2025-11-22T04:20:00',
      'arrivalTime': '2025-11-22T12:45:00',
      'duration': 325, // 5h 25m
      'stops': 0,
      'segments': [
        {
          'originCode': 'DEL',
          'destinationCode': 'SIN',
          'departureTime': '2025-11-22T04:20:00',
          'arrivalTime': '2025-11-22T12:45:00',
          'airlineCode': 'SQ',
          'airlineName': 'Singapore Airlines',
          'aircraft': 'Boeing 787',
          'duration': 325,
        }
      ],
      'fareOptions': [
        {
          'type': 'Light',
          'price': 6900.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 0,
          'isRefundable': false,
          'refundPolicy': 'Non-refundable',
        },
        {
          'type': 'Standard',
          'price': 8900.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 20,
          'isRefundable': false,
          'refundPolicy': 'Refundable with fee',
        },
        {
          'type': 'Flex',
          'price': 14900.00,
          'cabinClass': 'Economy',
          'baggageAllowance': 30,
          'isRefundable': true,
          'refundPolicy': 'Fully refundable',
        }
      ]
    },
  ];
}