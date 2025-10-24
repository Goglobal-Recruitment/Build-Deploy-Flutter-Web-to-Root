# SkyQuest Flight Booking App - Complete Flow

This document details the complete user flow through the SkyQuest Flight Booking application, showing how each screen connects and functions.

## Complete User Journey

### 1. Home Screen → Search Screen
**Starting Point**: User opens the app and lands on the Home Screen
**Navigation**: Tap the search prompt or bottom navigation "Search" tab
**Functionality**: 
- Branded welcome with SkyQuest logo
- Quick access to flight search
- Upcoming flights display (mock data)
- Hotel recommendations
- Easy navigation to all app sections

### 2. Search Screen → Flight Results Screen
**User Action**: Fill out flight search form
**Required Data**:
- Origin airport (dropdown selection)
- Destination airport (dropdown selection)
- Departure date (calendar picker)
- Passenger count (number selector)
**Navigation**: Tap "Search Flights" button
**Functionality**:
- Validates all fields are filled
- Shows error if origin/destination not selected
- Passes search parameters to results screen
- Displays loading state during transition

### 3. Flight Results Screen → Flight Details Screen
**User Action**: Browse flight options and select one
**Data Passed**:
- Selected flight object
- Search parameters (passenger count)
**Functionality**:
- Sort flights by price, duration, or departure time
- Filter by price, stops, airline, or duration
- Display flight cards with key information
- Show badge indicators (Direct, Fastest, Cheapest)

### 4. Flight Details Screen → Passenger Info Screen
**User Action**: Select fare option and continue
**Data Passed**:
- Selected flight object
- Chosen fare option
- Passenger count
**Functionality**:
- Display detailed flight itinerary
- Show fare options with expandable details
- Display baggage allowance table
- Show fare rules summary
- Validate fare selection before proceeding

### 5. Passenger Info Screen → Payment Screen
**User Action**: Fill passenger details and continue
**Data Collected**:
- First name (per passenger)
- Last name (per passenger)
- Date of birth (per passenger)
- Email address
- Phone number
**Data Passed**:
- Flight object
- Selected fare option
- Passenger list with details
**Functionality**:
- Form validation for all required fields
- Date picker for date of birth
- Error messaging for invalid data
- Flight summary display
- Navigation to payment processing

### 6. Payment Screen → Booking Confirmation Screen
**User Action**: Enter payment details and pay
**Data Processed**:
- Flight booking with passenger details
- Payment information (simulated)
**Functionality**:
- Payment form with validation
- Price breakdown display
- Simulated payment processing
- Automatic navigation on success
- Error handling for payment issues

### 7. Booking Confirmation Screen → Home/Manage Bookings
**User Action**: Review confirmation and choose next action
**Options**:
- Download invoice (HTML format)
- Return to home screen
**Data Generated**:
- Unique booking reference
- Complete booking object
- Invoice data for download
**Functionality**:
- Booking confirmation display
- Booking reference generation
- Flight itinerary summary
- Passenger information list
- Invoice download capability

### 8. Manage Bookings Screen → Booking Details Screen
**User Action**: View existing bookings
**Data Displayed**:
- List of all bookings
- Booking reference and status
- Flight route and date
- Passenger count
**Navigation**: Tap "View Details" on any booking
**Functionality**:
- Empty state handling
- Booking card display
- Status badge coloring
- Detailed booking view

## Screen-by-Screen Technical Details

### Home Screen (`lib/screens/home_screen.dart`)
**Imports**:
- Hotel and ticket view components
- App utilities and styles
- Custom widgets
**Key Components**:
- Welcome header with branding
- Search prompt
- Horizontal scrollable flight list
- Hotel recommendations
- Bottom navigation integration

### Search Screen (`lib/screens/search_screen.dart`)
**Imports**:
- Airport model
- Flight service
- App utilities
- Custom widgets
- Results screen
**Key Components**:
- Airport dropdown selectors
- Date picker
- Passenger counter
- Search button with validation
- Promotional content

### Flight Results Screen (`lib/screens/flight_results_screen.dart`)
**Imports**:
- Airport model
- Flight model
- Flight service
- App utilities
- Custom widgets
- Flight details screen
**Key Components**:
- Search summary bar
- Sort dropdown
- Filter modal
- Flight card list
- Empty state handling

### Flight Details Screen (`lib/screens/flight_details_screen.dart`)
**Imports**:
- Flight model
- App utilities
- Custom widgets
- Passenger info screen
**Key Components**:
- Detailed itinerary display
- Expandable fare options
- Baggage information table
- Fare rules summary
- Continue button with validation

### Passenger Info Screen (`lib/screens/passenger_info_screen.dart`)
**Imports**:
- Booking model
- Flight model
- Flight service
- App utilities
- Payment screen
- UUID for unique IDs
**Key Components**:
- Flight summary
- Passenger forms (dynamic based on count)
- Date pickers
- Form validation
- Continue button

### Payment Screen (`lib/screens/payment_screen.dart`)
**Imports**:
- Booking model
- App utilities
- Custom widgets
- Confirmation screen
**Key Components**:
- Booking summary
- Payment form
- Price breakdown
- Simulated processing
- Success navigation

### Booking Confirmation Screen (`lib/screens/booking_confirmation_screen.dart`)
**Imports**:
- Booking model
- App utilities
- Custom widgets
- HTML for invoice generation
**Key Components**:
- Success messaging
- Booking reference display
- Flight itinerary
- Passenger list
- Invoice download
- Home navigation

### Manage Bookings Screen (`lib/screens/manage_bookings_screen.dart`)
**Imports**:
- Booking model
- Flight service
- App utilities
- Custom widgets
- Booking details screen
**Key Components**:
- Empty state handling
- Booking card list
- Status badges
- View details navigation

### Booking Details Screen (`lib/screens/booking_details_screen.dart`)
**Imports**:
- Booking model
- App utilities
- Custom widgets
- HTML for invoice generation
**Key Components**:
- Detailed booking information
- Flight itinerary
- Passenger details
- Price breakdown
- Invoice download

## Data Flow

### Models
1. **Airport** - Airport information (code, name, city, country)
2. **Flight** - Complete flight information with segments and fares
3. **FlightSegment** - Individual flight segments for multi-stop flights
4. **FareOption** - Different fare types with pricing and rules
5. **Passenger** - Passenger details (name, DOB, contact)
6. **Booking** - Complete booking with flight, passengers, and fare

### Services
1. **FlightService** - Handles all flight-related operations:
   - Airport data management
   - Flight search and filtering
   - Mock data generation
   - Booking creation

### Data Sources
1. **Mock Flights** - Predefined flight routes in `lib/data/mock_flights.dart`
2. **Airport Data** - Comprehensive airport list in `lib/data/airport_airline_data.dart`
3. **Airline Data** - Airline information in `lib/data/airport_airline_data.dart`

## Error Handling

### Form Validation
- All required fields validated
- Proper error messaging
- Visual feedback for invalid entries

### Navigation Safety
- Null checks before screen transitions
- Proper data passing between screens
- Error states for missing data

### User Feedback
- Snackbar notifications for errors
- Loading indicators for processing
- Success confirmations

## Performance Considerations

### Efficient Rendering
- ListView.builder for long lists
- Proper widget rebuilding
- Memory management for controllers

### Asset Management
- Optimized image sizes
- Proper caching
- Efficient loading

### State Management
- GetX for navigation and state
- Proper disposal of resources
- Minimal rebuilds

## GitHub Deployment

The app is configured to automatically deploy to GitHub Pages:
- Builds on every push to main branch
- Deploys to docs folder
- Available at: https://go-global-recruitment.github.io/Build-Deploy-Flutter-Web-to-Root/

All paths and references are configured correctly for GitHub Pages deployment with the proper base href.