// Main application logic
document.addEventListener('DOMContentLoaded', () => {
  // App state
  const state = {
    tripType: 'return', // 'one-way', 'return', 'multi-city'
    cabinClass: 'economy', // 'economy', 'business', 'first'
    from: '',
    to: '',
    departDate: '',
    returnDate: '',
    passengers: 1,
    searchResults: [],
    selectedFlight: null,
    selectedReturnFlight: null,
    passengerInfo: {},
    bookingReference: '',
    currentScreen: 'search' // 'search', 'results', 'details', 'passenger', 'payment', 'confirmation', 'manage'
  };

  // DOM elements
  const elements = {
    // Navigation and screens
    screens: {
      search: document.getElementById('search-screen'),
      results: document.getElementById('results-screen'),
      details: document.getElementById('flight-details-screen'),
      passenger: document.getElementById('passenger-form-screen'),
      payment: document.getElementById('payment-screen'),
      confirmation: document.getElementById('confirmation-screen'),
      manage: document.getElementById('manage-bookings-screen')
    },
    // Form elements
    tripTypeRadios: document.querySelectorAll('input[name="trip-type"]'),
    cabinClassSelect: document.getElementById('cabin-class'),
    fromInput: document.getElementById('from'),
    toInput: document.getElementById('to'),
    departDateInput: document.getElementById('depart-date'),
    returnDateInput: document.getElementById('return-date'),
    passengersInput: document.getElementById('passengers'),
    searchBtn: document.getElementById('search-btn'),
    // Results elements
    resultsContainer: document.getElementById('results-container'),
    sortSelect: document.getElementById('sort-by'),
    priceFilterRange: document.getElementById('price-filter'),
    priceFilterValue: document.getElementById('price-filter-value'),
    // Progress steps
    progressSteps: document.querySelectorAll('.progress-step')
  };

  // Initialize the application
  function init() {
    // Set up airport options
    populateAirportOptions();
    
    // Set up event listeners
    setupEventListeners();
    
    // Set min date for date inputs to today
    const today = new Date().toISOString().split('T')[0];
    elements.departDateInput.min = today;
    elements.returnDateInput.min = today;
    
    // Set max date to December 31 of current year
    const endOfYear = new Date(new Date().getFullYear(), 11, 31).toISOString().split('T')[0];
    elements.departDateInput.max = endOfYear;
    elements.returnDateInput.max = endOfYear;
    
    // Initialize price filter
    updatePriceFilterRange();
    
    // Show search screen
    switchScreen('search');
  }

  // Populate airport dropdowns
  function populateAirportOptions() {
    const fromSelect = elements.fromInput;
    const toSelect = elements.toInput;
    
    // Clear existing options
    fromSelect.innerHTML = '<option value="">Select departure airport</option>';
    toSelect.innerHTML = '<option value="">Select destination airport</option>';
    
    // Add African airports to 'from' dropdown
    africanAirports.forEach(airport => {
      const option = document.createElement('option');
      option.value = airport.code;
      option.textContent = `${airport.city} (${airport.code}), ${airport.country}`;
      fromSelect.appendChild(option);
    });
    
    // Add destination airports to 'to' dropdown
    destinationAirports.forEach(airport => {
      const option = document.createElement('option');
      option.value = airport.code;
      option.textContent = `${airport.city} (${airport.code}), ${airport.country}`;
      toSelect.appendChild(option);
    });
  }

  // Set up event listeners
  function setupEventListeners() {
    // Trip type change
    elements.tripTypeRadios.forEach(radio => {
      radio.addEventListener('change', handleTripTypeChange);
    });
    
    // Cabin class change
    elements.cabinClassSelect.addEventListener('change', function() {
      state.cabinClass = this.value;
      updatePriceFilterRange();
    });
    
    // Search button
    elements.searchBtn.addEventListener('click', handleSearch);
    
    // Sort select
    elements.sortSelect.addEventListener('change', handleSort);
    
    // Price filter
    elements.priceFilterRange.addEventListener('input', handlePriceFilter);
  }

  // Handle trip type change
  function handleTripTypeChange() {
    state.tripType = this.value;
    const returnDateGroup = document.getElementById('return-date-group');
    
    if (state.tripType === 'one-way') {
      returnDateGroup.style.display = 'none';
    } else {
      returnDateGroup.style.display = 'block';
    }
  }

  // Update price filter range based on cabin class
  function updatePriceFilterRange() {
    const priceRange = elements.priceFilterRange;
    const priceValue = elements.priceFilterValue;
    
    if (state.cabinClass === 'economy') {
      priceRange.min = 12500;
      priceRange.max = 18900;
      priceRange.value = 18900;
    } else {
      priceRange.min = 85000;
      priceRange.max = 142000;
      priceRange.value = 142000;
    }
    
    priceValue.textContent = formatPrice(priceRange.value);
  }

  // Handle search
  function handleSearch() {
    // Validate form
    if (!validateSearchForm()) {
      return;
    }
    
    // Update state
    state.from = elements.fromInput.value;
    state.to = elements.toInput.value;
    state.departDate = elements.departDateInput.value;
    state.returnDate = state.tripType === 'return' ? elements.returnDateInput.value : null;
    state.passengers = parseInt(elements.passengersInput.value);
    
    // Generate search results
    state.searchResults = generateFlights(
      state.from, 
      state.to, 
      state.departDate, 
      state.returnDate, 
      state.cabinClass
    );
    
    // Display results
    displayFlights(state.searchResults);
    
    // Switch to results screen
    switchScreen('results');
    updateProgressSteps();
  }

  // Validate search form
  function validateSearchForm() {
    if (!elements.fromInput.value) {
      alert('Please select a departure airport');
      return false;
    }
    
    if (!elements.toInput.value) {
      alert('Please select a destination airport');
      return false;
    }
    
    if (!elements.departDateInput.value) {
      alert('Please select a departure date');
      return false;
    }
    
    if (state.tripType === 'return' && !elements.returnDateInput.value) {
      alert('Please select a return date');
      return false;
    }
    
    return true;
  }

  // Display flights
  function displayFlights(flights) {
    const container = elements.resultsContainer;
    container.innerHTML = '';
    
    if (flights.length === 0) {
      container.innerHTML = '<div class="no-results">No flights found. Please try different search criteria.</div>';
      return;
    }
    
    flights.forEach(flight => {
      const flightCard = createFlightCard(flight);
      container.appendChild(flightCard);
    });
  }

  // Create flight card
  function createFlightCard(flight) {
    const card = document.createElement('div');
    card.className = 'flight-card';
    card.innerHTML = `
      <div class="airline-info">
        <img src="${flight.airline.logo}" alt="${flight.airline.name}" class="airline-logo">
        <div class="airline-name">${flight.airline.name}</div>
        <div class="flight-number">${flight.flightNumber}</div>
      </div>
      <div class="flight-info">
        <div class="time-container">
          <div class="departure">
            <div class="time">${flight.departureTime}</div>
            <div class="airport">${flight.from.code}</div>
          </div>
          <div class="flight-path">
            <div class="duration">${flight.durationText}</div>
            <div class="path-line"></div>
            <div class="stops">${flight.stops.text}</div>
          </div>
          <div class="arrival">
            <div class="time">${flight.arrivalTime}</div>
            <div class="airport">${flight.to.code}</div>
          </div>
        </div>
      </div>
      <div class="price-container">
        <div class="cabin-class">${flight.cabinClass.charAt(0).toUpperCase() + flight.cabinClass.slice(1)}</div>
        <div class="price">${flight.priceText}</div>
        <button class="select-btn">Select</button>
      </div>
    `;
    
    // Add event listener to select button
    const selectBtn = card.querySelector('.select-btn');
    selectBtn.addEventListener('click', () => selectFlight(flight));
    
    return card;
  }

  // Select flight
  function selectFlight(flight) {
    if (!state.selectedFlight) {
      state.selectedFlight = flight;
      
      if (state.tripType === 'one-way' || !state.returnDate) {
        showFlightDetails();
      } else {
        // For return trips, show return flight options
        const returnFlights = state.searchResults.filter(f => f.id.startsWith('return'));
        displayFlights(returnFlights);
        alert('Please select your return flight');
        
        // Update the select button behavior for return flights
        const selectBtns = document.querySelectorAll('.select-btn');
        selectBtns.forEach(btn => {
          btn.removeEventListener('click', () => {});
          const flightCard = btn.closest('.flight-card');
          const flightIndex = Array.from(elements.resultsContainer.children).indexOf(flightCard);
          btn.addEventListener('click', () => {
            state.selectedReturnFlight = returnFlights[flightIndex];
            showFlightDetails();
          });
        });
      }
    } else if (!state.selectedReturnFlight && state.tripType === 'return') {
      state.selectedReturnFlight = flight;
      showFlightDetails();
    }
  }

  // Show flight details
  function showFlightDetails() {
    const detailsContainer = document.getElementById('flight-details-container');
    detailsContainer.innerHTML = '';
    
    // Create outbound flight details
    const outboundDetails = createFlightDetailsCard(state.selectedFlight, 'Outbound');
    detailsContainer.appendChild(outboundDetails);
    
    // Create return flight details if applicable
    if (state.selectedReturnFlight) {
      const returnDetails = createFlightDetailsCard(state.selectedReturnFlight, 'Return');
      detailsContainer.appendChild(returnDetails);
    }
    
    // Add total price
    let totalPrice = state.selectedFlight.price;
    if (state.selectedReturnFlight) {
      totalPrice += state.selectedReturnFlight.price;
    }
    
    const priceContainer = document.createElement('div');
    priceContainer.className = 'total-price-container';
    priceContainer.innerHTML = `
      <div class="total-price-label">Total Price (${state.passengers} passenger${state.passengers > 1 ? 's' : ''})</div>
      <div class="total-price-value">${formatPrice(totalPrice * state.passengers)}</div>
    `;
    detailsContainer.appendChild(priceContainer);
    
    // Add continue button
    const continueBtn = document.createElement('button');
    continueBtn.className = 'continue-btn';
    continueBtn.textContent = 'Continue to Passenger Details';
    continueBtn.addEventListener('click', () => {
      switchScreen('passenger');
      updateProgressSteps();
    });
    detailsContainer.appendChild(continueBtn);
    
    // Switch to details screen
    switchScreen('details');
    updateProgressSteps();
  }

  // Create flight details card
  function createFlightDetailsCard(flight, type) {
    const card = document.createElement('div');
    card.className = 'flight-details-card';
    
    card.innerHTML = `
      <div class="flight-route-details">
        <div class="route-date">${type} Flight - ${formatDateLong(flight.departureDate)}</div>
        <div class="route-segment">
          <div class="time-location">
            <div class="time">${flight.departureTime}</div>
            <div class="location">${flight.from.city}</div>
            <div class="airport">${flight.from.code}, ${flight.from.country}</div>
          </div>
          <div class="flight-path">
            <div class="airline-info">
              <img src="${flight.airline.logo}" alt="${flight.airline.name}" class="airline-logo">
              ${flight.airline.name} - ${flight.flightNumber}
            </div>
            <div class="duration">${flight.durationText}</div>
            <div class="path-line"></div>
            <div class="cabin-class">${flight.cabinClass.charAt(0).toUpperCase() + flight.cabinClass.slice(1)} Class</div>
          </div>
          <div class="time-location">
            <div class="time">${flight.arrivalTime}</div>
            <div class="location">${flight.to.city}</div>
            <div class="airport">${flight.to.code}, ${flight.to.country}</div>
          </div>
        </div>
      </div>
      <div class="fare-rules">
        <h3>Fare Rules</h3>
        <div class="rules-grid">
          <div class="rule-item">
            <div class="rule-label">Baggage</div>
            <div class="rule-value">2 x 23kg checked bags</div>
          </div>
          <div class="rule-item">
            <div class="rule-label">Cancellation</div>
            <div class="rule-value">Refundable with R750 fee</div>
          </div>
          <div class="rule-item">
            <div class="rule-label">Changes</div>
            <div class="rule-value">Allowed with R500 fee</div>
          </div>
          <div class="rule-item">
            <div class="rule-label">Seat Selection</div>
            <div class="rule-value">Free of charge</div>
          </div>
        </div>
      </div>
    `;
    
    return card;
  }

  // Show passenger form
  function showPassengerForm() {
    const form = document.getElementById('passenger-details-form');
    form.addEventListener('submit', function(e) {
      e.preventDefault();
      
      // Validate form
      if (!validatePassengerForm()) {
        return;
      }
      
      // Update state with passenger info
      state.passengerInfo = {
        fullName: document.getElementById('full-name').value,
        email: document.getElementById('email').value,
        phone: document.getElementById('phone').value,
        passportId: document.getElementById('passport-id').value
      };
      
      // Proceed to payment
      switchScreen('payment');
      updateProgressSteps();
      
      // Generate QR code for payment
      generatePaymentQR();
    });
    
    // Back button
    const backBtn = document.getElementById('passenger-back-btn');
    backBtn.addEventListener('click', () => {
      switchScreen('details');
      updateProgressSteps();
    });
  }

  // Validate passenger form
  function validatePassengerForm() {
    const fullName = document.getElementById('full-name').value;
    const email = document.getElementById('email').value;
    const phone = document.getElementById('phone').value;
    const passportId = document.getElementById('passport-id').value;
    
    if (!fullName) {
      alert('Please enter your full name');
      return false;
    }
    
    if (!email || !email.includes('@')) {
      alert('Please enter a valid email address');
      return false;
    }
    
    if (!phone) {
      alert('Please enter your phone number');
      return false;
    }
    
    if (!passportId) {
      alert('Please enter your passport or ID number');
      return false;
    }
    
    return true;
  }

  // Generate payment QR code
  function generatePaymentQR() {
    const qrContainer = document.getElementById('payment-qr-container');
    
    // Calculate total price
    let totalPrice = state.selectedFlight.price;
    if (state.selectedReturnFlight) {
      totalPrice += state.selectedReturnFlight.price;
    }
    totalPrice *= state.passengers;
    
    // Display payment info
    const paymentInfo = document.getElementById('payment-info');
    paymentInfo.innerHTML = `
      <h3>Payment Details</h3>
      <p>Total Amount: ${formatPrice(totalPrice)}</p>
      <p>Reference: FLT-${Math.floor(Math.random() * 1000000)}</p>
    `;
    
    // Generate QR code (using placeholder image for now)
    qrContainer.innerHTML = `
      <div class="qr-code">
        <img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=https://paystack.com/pay/flight-${Math.floor(Math.random() * 1000000)}" alt="Payment QR Code">
      </div>
      <p>Scan this QR code to pay with your banking app</p>
    `;
    
    // Simulate payment button (for demo purposes)
    const simulateBtn = document.createElement('button');
    simulateBtn.className = 'simulate-payment-btn';
    simulateBtn.textContent = 'Simulate Successful Payment';
    simulateBtn.addEventListener('click', handlePaymentSuccess);
    qrContainer.appendChild(simulateBtn);
    
    // Back button
    const backBtn = document.getElementById('payment-back-btn');
    backBtn.addEventListener('click', () => {
      switchScreen('passenger');
      updateProgressSteps();
    });
  }

  // Handle successful payment
  function handlePaymentSuccess() {
    // Generate booking reference
    state.bookingReference = 'GGF' + Math.floor(Math.random() * 1000000).toString().padStart(6, '0');
    
    // Show confirmation screen
    showConfirmation();
  }

  // Show confirmation
  function showConfirmation() {
    const confirmationContainer = document.getElementById('confirmation-details');
    
    // Calculate total price
    let totalPrice = state.selectedFlight.price;
    if (state.selectedReturnFlight) {
      totalPrice += state.selectedReturnFlight.price;
    }
    totalPrice *= state.passengers;
    
    confirmationContainer.innerHTML = `
      <div class="confirmation-header">
        <h2>Booking Confirmed!</h2>
        <p>Your booking reference: <strong>${state.bookingReference}</strong></p>
      </div>
      
      <div class="e-ticket">
        <div class="ticket-header">
          <h3>E-Ticket</h3>
          <div class="barcode">
            <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${state.bookingReference}" alt="Ticket QR Code">
          </div>
        </div>
        
        <div class="passenger-info">
          <h4>Passenger</h4>
          <p>${state.passengerInfo.fullName}</p>
        </div>
        
        <div class="flight-summary">
          <h4>Flight Summary</h4>
          <div class="flight-item">
            <div class="flight-route">
              ${state.selectedFlight.from.code} → ${state.selectedFlight.to.code}
            </div>
            <div class="flight-date">
              ${formatDateLong(state.selectedFlight.departureDate)}
            </div>
            <div class="flight-details">
              ${state.selectedFlight.airline.name} ${state.selectedFlight.flightNumber}
            </div>
          </div>
          
          ${state.selectedReturnFlight ? `
          <div class="flight-item">
            <div class="flight-route">
              ${state.selectedReturnFlight.from.code} → ${state.selectedReturnFlight.to.code}
            </div>
            <div class="flight-date">
              ${formatDateLong(state.selectedReturnFlight.departureDate)}
            </div>
            <div class="flight-details">
              ${state.selectedReturnFlight.airline.name} ${state.selectedReturnFlight.flightNumber}
            </div>
          </div>
          ` : ''}
        </div>
      </div>
      
      <div class="action-buttons">
        <button id="download-invoice" class="action-btn">Download Invoice</button>
        <button id="manage-booking" class="action-btn">Manage Booking</button>
        <button id="new-search" class="action-btn">New Search</button>
      </div>
    `;
    
    // Add event listeners
    document.getElementById('download-invoice').addEventListener('click', generateInvoice);
    document.getElementById('manage-booking').addEventListener('click', () => switchScreen('manage'));
    document.getElementById('new-search').addEventListener('click', resetAndSearch);
    
    // Switch to confirmation screen
    switchScreen('confirmation');
    updateProgressSteps();
  }

  // Generate invoice
  function generateInvoice() {
    // In a real app, this would generate a PDF
    // For this demo, we'll just show an alert
    alert('Invoice downloaded successfully');
  }

  // Reset app state and go to search
  function resetAndSearch() {
    // Reset state
    state.selectedFlight = null;
    state.selectedReturnFlight = null;
    state.passengerInfo = {};
    
    // Go to search screen
    switchScreen('search');
    updateProgressSteps();
  }

  // Switch between screens
  function switchScreen(screenName) {
    state.currentScreen = screenName;
    
    // Hide all screens
    Object.values(elements.screens).forEach(screen => {
      if (screen) screen.style.display = 'none';
    });
    
    // Show the selected screen
    if (elements.screens[screenName]) {
      elements.screens[screenName].style.display = 'block';
      
      // Initialize screen-specific functionality
      if (screenName === 'passenger') {
        showPassengerForm();
      }
    }
  }

  // Update progress steps
  function updateProgressSteps() {
    const screenOrder = ['search', 'results', 'details', 'passenger', 'payment', 'confirmation'];
    const currentIndex = screenOrder.indexOf(state.currentScreen);
    
    elements.progressSteps.forEach((step, index) => {
      if (index < currentIndex) {
        step.classList.add('completed');
        step.classList.remove('active');
      } else if (index === currentIndex) {
        step.classList.add('active');
        step.classList.remove('completed');
      } else {
        step.classList.remove('active', 'completed');
      }
    });
  }

  // Handle sorting
  function handleSort() {
    const sortBy = elements.sortSelect.value;
    let sortedFlights = [...state.searchResults];
    
    switch (sortBy) {
      case 'price-asc':
        sortedFlights.sort((a, b) => a.price - b.price);
        break;
      case 'price-desc':
        sortedFlights.sort((a, b) => b.price - a.price);
        break;
      case 'duration-asc':
        sortedFlights.sort((a, b) => {
          const durationA = a.duration.hours * 60 + a.duration.minutes;
          const durationB = b.duration.hours * 60 + b.duration.minutes;
          return durationA - durationB;
        });
        break;
      case 'stops-asc':
        sortedFlights.sort((a, b) => a.stops.count - b.stops.count);
        break;
    }
    
    displayFlights(sortedFlights);
  }

  // Handle price filter
  function handlePriceFilter() {
    const maxPrice = parseInt(elements.priceFilterRange.value);
    elements.priceFilterValue.textContent = formatPrice(maxPrice);
    
    const filteredFlights = state.searchResults.filter(flight => flight.price <= maxPrice);
    displayFlights(filteredFlights);
  }

  // Format date in long format
  function formatDateLong(dateStr) {
    const date = new Date(dateStr);
    return date.toLocaleDateString('en-ZA', { 
      weekday: 'long', 
      day: 'numeric', 
      month: 'long', 
      year: 'numeric' 
    });
  }

  // Initialize the app
  init();
});