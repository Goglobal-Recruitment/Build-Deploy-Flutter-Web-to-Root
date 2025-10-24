# SkyQuest Flight Booking App - Screen Preview

This document provides a detailed preview of each screen in the SkyQuest Flight Booking application, showing how they work together to create a complete booking experience.

## 1. Home Screen

**Location**: `lib/screens/home_screen.dart`

### Functionality:
- Welcome message with app branding ("SkyQuest")
- Quick search prompt
- Display of upcoming flights (mock data)
- Recommended hotels section
- Bottom navigation bar for app navigation

### UI Elements:
- Branded header with SkyQuest logo
- Search prompt with icon
- Horizontal scrollable list of upcoming flights
- Hotel recommendations
- Bottom navigation bar with 5 tabs

### User Flow:
1. Users are greeted with a welcome message
2. Can quickly access search functionality
3. View upcoming flight information
4. Browse hotel recommendations
5. Navigate to other sections using the bottom bar

## 2. Search Screen

**Location**: `lib/screens/search_screen.dart`

### Functionality:
- Flight search form with origin/destination selection
- Date picker for departure date
- Passenger count selector
- Search button to find flights
- Promotional content display

### UI Elements:
- Origin airport dropdown (with all available airports)
- Destination airport dropdown
- Date selection field with calendar picker
- Passenger counter with +/- buttons
- "Search Flights" button
- Promotional banners

### User Flow:
1. Select origin airport from dropdown
2. Select destination airport from dropdown
3. Choose departure date using calendar picker
4. Adjust passenger count using +/- buttons
5. Click "Search Flights" to view results

## 3. Flight Results Screen

**Location**: `lib/screens/flight_results_screen.dart`

### Functionality:
- Display of available flights matching search criteria
- Sorting options (price, duration, departure time)
- Filtering capabilities (price, stops, airline)
- Flight card selection to view details
- Summary of search parameters

### UI Elements:
- Search summary bar (route, date, passengers, flight count)
- Sort dropdown menu
- "Filters" button to open filter modal
- Scrollable list of flight cards
- Each flight card shows:
  - Badge indicating flight type (Direct, Fastest, Cheapest)
  - Departure and arrival times
  - Flight duration
  - Route information
  - Airline and flight number
  - Starting price

### User Flow:
1. Review search parameters at top
2. Sort flights using dropdown
3. Apply filters using the "Filters" button
4. Browse flight options
5. Tap any flight card to view details

## 4. Flight Details Screen

**Location**: `lib/screens/flight_details_screen.dart`

### Functionality:
- Detailed flight itinerary information
- Segment information for multi-stop flights
- Layover details
- Fare options with expandable information
- Baggage allowance table
- Fare rules summary
- Continue to booking button

### UI Elements:
- Flight itinerary section with:
  - Departure/arrival times and airports
  - Flight duration
  - Aircraft type
  - Airline information
- Expandable fare options cards:
  - Light, Standard, and Flex fares
  - Price for each fare
  - Baggage allowance
  - Refundability information
- Baggage information table
- Fare rules summary
- "Continue to Passenger Info" button

### User Flow:
1. Review detailed flight information
2. Expand fare options to compare
3. Select preferred fare option
4. Review baggage information
5. Read fare rules
6. Click "Continue to Passenger Info"

## 5. Passenger Information Screen

**Location**: `lib/screens/passenger_info_screen.dart`

### Functionality:
- Form for collecting passenger details
- Validation for required fields
- Date of birth picker
- Flight summary display
- Navigation to payment screen

### UI Elements:
- Flight summary card (route, date, fare type, price)
- Passenger forms (one for each passenger):
  - First name field
  - Last name field
  - Date of birth picker
  - Email address field
  - Phone number field
- "Proceed to Payment" button

### User Flow:
1. Review flight summary
2. Fill in passenger details for each traveler
3. Select date of birth using picker
4. Enter contact information
5. Click "Proceed to Payment"

## 6. Payment Screen

**Location**: `lib/screens/payment_screen.dart`

### Functionality:
- Payment form for card details
- Price breakdown display
- Payment processing simulation
- Navigation to confirmation screen

### UI Elements:
- Booking summary with:
  - Route information
  - Flight date
  - Passenger count
  - Fare type
  - Price breakdown (subtotal, taxes, total)
- Payment form with:
  - Card number field
  - Expiry date field
  - CVV field
  - Cardholder name field
- "Pay" button with total amount
- Security notice

### User Flow:
1. Review booking summary
2. Enter payment details
3. Click "Pay" button
4. Wait for payment processing simulation
5. Automatically navigates to confirmation

## 7. Booking Confirmation Screen

**Location**: `lib/screens/booking_confirmation_screen.dart`

### Functionality:
- Booking confirmation message
- Booking reference display
- Flight itinerary summary
- Passenger information summary
- Invoice download option
- Navigation to home screen

### UI Elements:
- Success header with checkmark icon
- Booking reference in large, clear text
- Flight details section:
  - Departure/arrival airports and times
  - Flight duration
  - Airline and flight number
- Passenger information list
- "Download Invoice" button
- "Back to Home" button

### User Flow:
1. View booking confirmation
2. Note booking reference
3. Review flight details
4. Confirm passenger information
5. Download invoice if needed
6. Return to home screen

## 8. Manage Bookings Screen

**Location**: `lib/screens/manage_bookings_screen.dart`

### Functionality:
- List of all bookings
- Booking details view
- Empty state handling
- Navigation to booking details

### UI Elements:
- Header indicating "My Bookings"
- Empty state (if no bookings):
  - Illustration
  - Message
  - "Search Flights" button
- Booking cards with:
  - Booking reference
  - Status badge
  - Route information
  - Flight date
  - Passenger count
  - Airline information
  - "View Details" button

### User Flow:
1. View list of bookings
2. If no bookings, see empty state with search option
3. Tap "View Details" on any booking to see details
4. Access all booking information

## 9. Booking Details Screen

**Location**: `lib/screens/booking_details_screen.dart`

### Functionality:
- Detailed view of a specific booking
- Complete flight information
- Passenger details
- Price breakdown
- Invoice download

### UI Elements:
- Booking reference and status
- Flight details section
- Passenger information cards
- Price breakdown
- "Download Invoice" button

### User Flow:
1. View detailed booking information
2. Review flight details
3. Check passenger information
4. See price breakdown
5. Download invoice if needed

## 10. Profile Screen

**Location**: `lib/screens/profile_screen.dart`

### Functionality:
- User profile information
- Account settings
- Support options
- App information

### UI Elements:
- Profile header
- Account information
- Settings options
- Support links
- App version information

### User Flow:
1. View profile information
2. Access account settings
3. Get support if needed
4. View app information

## Technical Implementation

### GitHub Deployment
The app is configured for automatic deployment to GitHub Pages using GitHub Actions:
- Workflow file: `.github/workflows/deploy-flutter-web.yml`
- Builds on every push to main branch
- Deploys to docs folder for GitHub Pages
- Uses Flutter stable channel
- Enables web support automatically

### Error Prevention
To ensure no loading errors or screen errors on GitHub:
1. All imports use proper relative paths
2. All required dependencies are listed in pubspec.yaml
3. Assets are properly declared in pubspec.yaml
4. All screens are properly imported in navigation
5. No circular dependencies
6. Proper error handling in async operations
7. Consistent state management with GetX

### Performance Optimization
1. Lazy loading of screens through bottom navigation
2. Efficient widget rebuilding with StatefulWidget where needed
3. Proper disposal of controllers
4. Optimized list building with ListView.builder
5. Image assets optimized for web

## Testing the Application

To test locally:
```bash
flutter pub get
flutter run -d chrome
```

To build for production:
```bash
flutter build web --release
```

The application will be available at:
https://go-global-recruitment.github.io/Build-Deploy-Flutter-Web-to-Root/