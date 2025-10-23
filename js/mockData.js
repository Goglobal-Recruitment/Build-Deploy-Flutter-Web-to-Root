// Mock flight data for African to Australia/UK routes
const airlines = [
  { id: 'sa', name: 'South African Airways', logo: 'https://via.placeholder.com/30?text=SAA' },
  { id: 'et', name: 'Ethiopian Airlines', logo: 'https://via.placeholder.com/30?text=ET' },
  { id: 'ke', name: 'Kenya Airways', logo: 'https://via.placeholder.com/30?text=KQ' },
  { id: 'ek', name: 'Emirates', logo: 'https://via.placeholder.com/30?text=EK' },
  { id: 'qf', name: 'Qantas', logo: 'https://via.placeholder.com/30?text=QF' },
  { id: 'ba', name: 'British Airways', logo: 'https://via.placeholder.com/30?text=BA' },
  { id: 'vs', name: 'Virgin Atlantic', logo: 'https://via.placeholder.com/30?text=VS' },
  { id: 'ms', name: 'EgyptAir', logo: 'https://via.placeholder.com/30?text=MS' }
];

const africanAirports = [
  { code: 'JNB', city: 'Johannesburg', country: 'South Africa' },
  { code: 'CPT', city: 'Cape Town', country: 'South Africa' },
  { code: 'DUR', city: 'Durban', country: 'South Africa' },
  { code: 'NBO', city: 'Nairobi', country: 'Kenya' },
  { code: 'ADD', city: 'Addis Ababa', country: 'Ethiopia' },
  { code: 'CAI', city: 'Cairo', country: 'Egypt' },
  { code: 'LOS', city: 'Lagos', country: 'Nigeria' },
  { code: 'ACC', city: 'Accra', country: 'Ghana' },
  { code: 'DAR', city: 'Dar es Salaam', country: 'Tanzania' },
  { code: 'MRU', city: 'Mauritius', country: 'Mauritius' }
];

const destinationAirports = [
  // Australia
  { code: 'SYD', city: 'Sydney', country: 'Australia' },
  { code: 'MEL', city: 'Melbourne', country: 'Australia' },
  { code: 'BNE', city: 'Brisbane', country: 'Australia' },
  { code: 'PER', city: 'Perth', country: 'Australia' },
  // UK
  { code: 'LHR', city: 'London', country: 'United Kingdom' },
  { code: 'MAN', city: 'Manchester', country: 'United Kingdom' },
  { code: 'EDI', city: 'Edinburgh', country: 'United Kingdom' },
  { code: 'BHX', city: 'Birmingham', country: 'United Kingdom' }
];

// Generate random time between two hours
function getRandomTime(start, end) {
  const startHour = parseInt(start.split(':')[0]);
  const endHour = parseInt(end.split(':')[0]);
  const hour = Math.floor(Math.random() * (endHour - startHour + 1)) + startHour;
  const minute = Math.floor(Math.random() * 12) * 5; // 5-minute intervals
  return `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}`;
}

// Generate random duration between min and max hours
function getRandomDuration(min, max) {
  const hours = Math.floor(Math.random() * (max - min + 1)) + min;
  const minutes = Math.floor(Math.random() * 12) * 5;
  return { hours, minutes };
}

// Format duration as string
function formatDuration(duration) {
  return `${duration.hours}h ${duration.minutes}m`;
}

// Generate random price within range based on cabin class
function getRandomPrice(cabinClass) {
  if (cabinClass === 'economy') {
    return Math.floor(Math.random() * (18900 - 12500 + 1)) + 12500;
  } else {
    return Math.floor(Math.random() * (142000 - 85000 + 1)) + 85000;
  }
}

// Format price with commas
function formatPrice(price) {
  return 'R' + price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

// Generate random flight number
function getRandomFlightNumber(airlineId) {
  return airlineId.toUpperCase() + Math.floor(Math.random() * 1000 + 100);
}

// Generate a random date between today and Dec 31
function getRandomDate() {
  const today = new Date();
  const endDate = new Date(today.getFullYear(), 11, 31); // Dec 31
  const randomTime = today.getTime() + Math.random() * (endDate.getTime() - today.getTime());
  return new Date(randomTime);
}

// Format date as YYYY-MM-DD
function formatDate(date) {
  return date.toISOString().split('T')[0];
}

// Generate random stops
function getRandomStops() {
  const stopsCount = Math.floor(Math.random() * 3); // 0, 1, or 2 stops
  if (stopsCount === 0) {
    return { count: 0, text: 'Nonstop' };
  } else if (stopsCount === 1) {
    return { count: 1, text: '1 Stop' };
  } else {
    return { count: 2, text: '2 Stops' };
  }
}

// Generate mock flights
function generateFlights(from, to, departDate, returnDate, cabinClass, count = 20) {
  const flights = [];
  
  // Find airport objects
  const fromAirport = africanAirports.find(airport => airport.code === from) || 
                      africanAirports.find(airport => airport.city.toLowerCase().includes(from.toLowerCase()));
  
  const toAirport = destinationAirports.find(airport => airport.code === to) ||
                    destinationAirports.find(airport => airport.city.toLowerCase().includes(to.toLowerCase()));
  
  if (!fromAirport || !toAirport) {
    return [];
  }
  
  // Generate outbound flights
  for (let i = 0; i < count; i++) {
    const airline = airlines[Math.floor(Math.random() * airlines.length)];
    const departureTime = getRandomTime('06:00', '23:00');
    const stops = getRandomStops();
    
    // Duration depends on destination (longer for Australia, shorter for UK)
    let durationMin, durationMax;
    if (toAirport.country === 'Australia') {
      durationMin = stops.count === 0 ? 14 : 16;
      durationMax = stops.count === 0 ? 18 : 24;
    } else {
      durationMin = stops.count === 0 ? 10 : 12;
      durationMax = stops.count === 0 ? 13 : 18;
    }
    
    const duration = getRandomDuration(durationMin, durationMax);
    
    // Calculate arrival time
    const departureDate = new Date(`2023-01-01T${departureTime}:00`);
    const arrivalDate = new Date(departureDate.getTime() + (duration.hours * 60 + duration.minutes) * 60000);
    const arrivalTime = `${arrivalDate.getHours().toString().padStart(2, '0')}:${arrivalDate.getMinutes().toString().padStart(2, '0')}`;
    
    const price = getRandomPrice(cabinClass);
    
    const flight = {
      id: `flight-${i}`,
      airline: airline,
      flightNumber: getRandomFlightNumber(airline.id),
      from: fromAirport,
      to: toAirport,
      departureDate: departDate,
      departureTime: departureTime,
      arrivalTime: arrivalTime,
      duration: duration,
      durationText: formatDuration(duration),
      stops: stops,
      price: price,
      priceText: formatPrice(price),
      cabinClass: cabinClass,
      seatsAvailable: Math.floor(Math.random() * 30) + 1
    };
    
    flights.push(flight);
  }
  
  // Generate return flights if returnDate is provided
  if (returnDate) {
    for (let i = 0; i < count; i++) {
      const airline = airlines[Math.floor(Math.random() * airlines.length)];
      const departureTime = getRandomTime('06:00', '23:00');
      const stops = getRandomStops();
      
      // Duration depends on destination (longer for Australia, shorter for UK)
      let durationMin, durationMax;
      if (toAirport.country === 'Australia') {
        durationMin = stops.count === 0 ? 14 : 16;
        durationMax = stops.count === 0 ? 18 : 24;
      } else {
        durationMin = stops.count === 0 ? 10 : 12;
        durationMax = stops.count === 0 ? 13 : 18;
      }
      
      const duration = getRandomDuration(durationMin, durationMax);
      
      // Calculate arrival time
      const departureDate = new Date(`2023-01-01T${departureTime}:00`);
      const arrivalDate = new Date(departureDate.getTime() + (duration.hours * 60 + duration.minutes) * 60000);
      const arrivalTime = `${arrivalDate.getHours().toString().padStart(2, '0')}:${arrivalDate.getMinutes().toString().padStart(2, '0')}`;
      
      const price = getRandomPrice(cabinClass);
      
      const flight = {
        id: `return-flight-${i}`,
        airline: airline,
        flightNumber: getRandomFlightNumber(airline.id),
        from: toAirport,
        to: fromAirport,
        departureDate: returnDate,
        departureTime: departureTime,
        arrivalTime: arrivalTime,
        duration: duration,
        durationText: formatDuration(duration),
        stops: stops,
        price: price,
        priceText: formatPrice(price),
        cabinClass: cabinClass,
        seatsAvailable: Math.floor(Math.random() * 30) + 1,
        isReturn: true
      };
      
      flights.push(flight);
    }
  }
  
  return flights;
}

// Generate fare rules
function generateFareRules(cabinClass) {
  const rules = {
    economy: {
      changeFee: 'R1,500',
      cancellationFee: 'R2,000',
      baggage: '1 x 23kg',
      mealIncluded: true,
      seatSelection: 'Paid',
      refundable: 'Partially refundable'
    },
    business: {
      changeFee: 'R2,500',
      cancellationFee: 'R3,500',
      baggage: '2 x 32kg',
      mealIncluded: true,
      seatSelection: 'Free',
      refundable: 'Fully refundable'
    },
    first: {
      changeFee: 'No fee',
      cancellationFee: 'R5,000',
      baggage: '3 x 32kg',
      mealIncluded: true,
      seatSelection: 'Free',
      refundable: 'Fully refundable'
    }
  };
  
  return rules[cabinClass];
}

// Generate booking reference
function generateBookingReference() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  let ref = '';
  for (let i = 0; i < 6; i++) {
    ref += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return ref;
}

// Export mock data functions
const mockData = {
  airlines,
  africanAirports,
  destinationAirports,
  generateFlights,
  generateFareRules,
  generateBookingReference,
  formatPrice
};