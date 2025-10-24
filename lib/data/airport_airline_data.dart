// Comprehensive airport and airline data for the flight booking app

class AirportData {
  static const List<Map<String, String>> airports = [
    // Major international airports
    {
      'code': 'JFK',
      'name': 'John F. Kennedy International Airport',
      'city': 'New York',
      'country': 'USA',
      'timezone': 'America/New_York'
    },
    {
      'code': 'LAX',
      'name': 'Los Angeles International Airport',
      'city': 'Los Angeles',
      'country': 'USA',
      'timezone': 'America/Los_Angeles'
    },
    {
      'code': 'ORD',
      'name': 'O\'Hare International Airport',
      'city': 'Chicago',
      'country': 'USA',
      'timezone': 'America/Chicago'
    },
    {
      'code': 'LHR',
      'name': 'Heathrow Airport',
      'city': 'London',
      'country': 'UK',
      'timezone': 'Europe/London'
    },
    {
      'code': 'CDG',
      'name': 'Charles de Gaulle Airport',
      'city': 'Paris',
      'country': 'France',
      'timezone': 'Europe/Paris'
    },
    {
      'code': 'FRA',
      'name': 'Frankfurt Airport',
      'city': 'Frankfurt',
      'country': 'Germany',
      'timezone': 'Europe/Berlin'
    },
    {
      'code': 'AMS',
      'name': 'Amsterdam Airport Schiphol',
      'city': 'Amsterdam',
      'country': 'Netherlands',
      'timezone': 'Europe/Amsterdam'
    },
    {
      'code': 'DXB',
      'name': 'Dubai International Airport',
      'city': 'Dubai',
      'country': 'UAE',
      'timezone': 'Asia/Dubai'
    },
    {
      'code': 'SIN',
      'name': 'Changi Airport',
      'city': 'Singapore',
      'country': 'Singapore',
      'timezone': 'Asia/Singapore'
    },
    {
      'code': 'SYD',
      'name': 'Sydney Airport',
      'city': 'Sydney',
      'country': 'Australia',
      'timezone': 'Australia/Sydney'
    },
    {
      'code': 'MEL',
      'name': 'Melbourne Airport',
      'city': 'Melbourne',
      'country': 'Australia',
      'timezone': 'Australia/Melbourne'
    },
    {
      'code': 'HND',
      'name': 'Haneda Airport',
      'city': 'Tokyo',
      'country': 'Japan',
      'timezone': 'Asia/Tokyo'
    },
    {
      'code': 'PEK',
      'name': 'Beijing Capital International Airport',
      'city': 'Beijing',
      'country': 'China',
      'timezone': 'Asia/Shanghai'
    },
    {
      'code': 'SHA',
      'name': 'Shanghai Hongqiao International Airport',
      'city': 'Shanghai',
      'country': 'China',
      'timezone': 'Asia/Shanghai'
    },
    {
      'code': 'IST',
      'name': 'Istanbul Airport',
      'city': 'Istanbul',
      'country': 'Turkey',
      'timezone': 'Europe/Istanbul'
    },
    {
      'code': 'DEL',
      'name': 'Indira Gandhi International Airport',
      'city': 'New Delhi',
      'country': 'India',
      'timezone': 'Asia/Kolkata'
    },
    {
      'code': 'BOM',
      'name': 'Chhatrapati Shivaji Maharaj International Airport',
      'city': 'Mumbai',
      'country': 'India',
      'timezone': 'Asia/Kolkata'
    },
    {
      'code': 'YYZ',
      'name': 'Toronto Pearson International Airport',
      'city': 'Toronto',
      'country': 'Canada',
      'timezone': 'America/Toronto'
    },
    {
      'code': 'YVR',
      'name': 'Vancouver International Airport',
      'city': 'Vancouver',
      'country': 'Canada',
      'timezone': 'America/Vancouver'
    },
    {
      'code': 'GRU',
      'name': 'São Paulo/Guarulhos International Airport',
      'city': 'São Paulo',
      'country': 'Brazil',
      'timezone': 'America/Sao_Paulo'
    },
    {
      'code': 'MEX',
      'name': 'Mexico City International Airport',
      'city': 'Mexico City',
      'country': 'Mexico',
      'timezone': 'America/Mexico_City'
    },
    {
      'code': 'MAD',
      'name': 'Adolfo Suárez Madrid–Barajas Airport',
      'city': 'Madrid',
      'country': 'Spain',
      'timezone': 'Europe/Madrid'
    },
    {
      'code': 'FCO',
      'name': 'Leonardo da Vinci–Fiumicino Airport',
      'city': 'Rome',
      'country': 'Italy',
      'timezone': 'Europe/Rome'
    },
    {
      'code': 'ARN',
      'name': 'Stockholm Arlanda Airport',
      'city': 'Stockholm',
      'country': 'Sweden',
      'timezone': 'Europe/Stockholm'
    },
    {
      'code': 'OSL',
      'name': 'Oslo Airport, Gardermoen',
      'city': 'Oslo',
      'country': 'Norway',
      'timezone': 'Europe/Oslo'
    },
  ];
}

class AirlineData {
  static const List<Map<String, String>> airlines = [
    // Major international airlines
    {'code': 'AA', 'name': 'American Airlines', 'country': 'USA'},
    {'code': 'BA', 'name': 'British Airways', 'country': 'UK'},
    {'code': 'AF', 'name': 'Air France', 'country': 'France'},
    {'code': 'EK', 'name': 'Emirates', 'country': 'UAE'},
    {'code': 'SQ', 'name': 'Singapore Airlines', 'country': 'Singapore'},
    {'code': 'QF', 'name': 'Qantas', 'country': 'Australia'},
    {'code': 'JL', 'name': 'Japan Airlines', 'country': 'Japan'},
    {'code': 'CA', 'name': 'Air China', 'country': 'China'},
    {'code': 'LH', 'name': 'Lufthansa', 'country': 'Germany'},
    {'code': 'KL', 'name': 'KLM Royal Dutch Airlines', 'country': 'Netherlands'},
    {'code': 'TK', 'name': 'Turkish Airlines', 'country': 'Turkey'},
    {'code': 'AI', 'name': 'Air India', 'country': 'India'},
    {'code': 'AC', 'name': 'Air Canada', 'country': 'Canada'},
    {'code': 'DL', 'name': 'Delta Air Lines', 'country': 'USA'},
    {'code': 'UA', 'name': 'United Airlines', 'country': 'USA'},
    {'code': 'CX', 'name': 'Cathay Pacific', 'country': 'Hong Kong'},
    {'code': 'NH', 'name': 'ANA All Nippon Airways', 'country': 'Japan'},
    {'code': 'AZ', 'name': 'Alitalia', 'country': 'Italy'},
    {'code': 'IB', 'name': 'Iberia', 'country': 'Spain'},
    {'code': 'SU', 'name': 'Aeroflot', 'country': 'Russia'},
    {'code': 'OS', 'name': 'Austrian Airlines', 'country': 'Austria'},
    {'code': 'SN', 'name': 'Brussels Airlines', 'country': 'Belgium'},
    {'code': 'AY', 'name': 'Finnair', 'country': 'Finland'},
    {'code': 'SK', 'name': 'SAS Scandinavian Airlines', 'country': 'Denmark/Norway/Sweden'},
    {'code': 'LX', 'name': 'Swiss International Air Lines', 'country': 'Switzerland'},
  ];
}