# SkyQuest Flight Booking App

A fully functional flight booking Flutter web application with a complete booking flow from search to confirmation.

## Features

### Core Functionality
- **Flight Search**: Search flights by origin, destination, date, and passenger count
- **Flight Results**: View available flights with sorting and filtering options
- **Flight Details**: Detailed flight information with fare options and baggage rules
- **Passenger Information**: Collect passenger details with form validation
- **Payment Simulation**: Secure payment processing simulation with both card and QR code options
- **Booking Confirmation**: Complete booking confirmation with itinerary and QR code e-ticket
- **Manage Bookings**: View and manage all bookings with detailed information
- **Invoice Generation**: Download booking invoices in HTML format

### Advanced Features
- **Flight Comparison**: Compare multiple flights side-by-side to make the best choice
- **Advanced Search**: Comprehensive search with filters for price, stops, airlines, and more
- **Web Scraping Integration**: Real flight data fetching using SerpApi with mock data fallback
- **Responsive Design**: Works seamlessly across all device sizes
- **Modern UI**: Clean, intuitive interface with consistent branding

## Technology Stack

- **Framework**: Flutter
- **Language**: Dart
- **Platform**: Web (static deployment)
- **State Management**: GetX
- **UI Components**: Custom widgets with Material Design
- **Build & Deployment**: GitHub Actions
- **Hosting**: GitHub Pages
- **Payment Processing**: Paystack integration
- **Web Scraping**: SerpApi integration
- **QR Code Generation**: Barcode widget package

## Project Structure

```
lib/
├── data/                 # Mock data files
├── models/               # Data models (Flight, Booking, Passenger, etc.)
├── screens/              # UI screens (Search, Results, Booking, etc.)
├── services/             # Business logic and data services
├── utils/                # Utility functions and constants
├── widgets/              # Reusable UI components
└── main.dart             # Application entry point
```

## Getting Started

### Prerequisites
- Flutter SDK (2.17.5 or higher)
- Dart SDK

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Configure API keys in `lib/utils/env_config.dart`:
   - SerpApi key for flight data
   - Paystack keys for payment processing
4. Run `flutter run -d chrome` to start the development server

### Building for Production
Run `flutter build web` to generate production-ready static files in the `build/web` directory.

## Deployment
The app is automatically deployed to GitHub Pages using GitHub Actions whenever changes are pushed to the main branch.

Live URL: https://go-global-recruitment.github.io/Build-Deploy-Flutter-Web-to-Root/

## Branding

### App Name
**SkyQuest** - Conveys adventure, exploration, and the quest to find the best flights

### Color Palette
- Primary Blue: #1D6ED6 (Vibrant Blue)
- Secondary Blue: #0E2D5D (Deep Navy)
- Accent Blue: #ACD4FC (Light Sky Blue)
- Neutral Gray: #F4F6FD (Light Gray)
- Text Dark: #3B3B3B (Charcoal)
- Text Light: #8F8F8F (Medium Gray)
- Success Green: #4CAF50
- Warning Orange: #FF9800
- Error Red: #F44336

## Data

### Mock Data
The app includes comprehensive mock data for:
- 25+ Airports worldwide
- 25+ Airlines
- 10+ Predefined flight routes
- Dynamic flight generation for other routes

### Flight Information
Each flight includes:
- Flight number and airline information
- Departure and arrival times
- Duration and stop information
- Segment details for multi-stop flights
- Multiple fare options (Light, Standard, Flex)
- Baggage allowances and refund policies

## Screens

1. **Home Screen**: Welcome screen with quick search access
2. **Search Screen**: Flight search with origin/destination selection
3. **Advanced Search Screen**: Comprehensive search with additional filters
4. **Results Screen**: Flight listings with sorting and filtering
5. **Flight Comparison Screen**: Compare multiple flights side-by-side
6. **Flight Details Screen**: Detailed flight information and fare selection
7. **Passenger Info Screen**: Passenger details collection
8. **Payment Screen**: Payment processing with card or QR code options
9. **Confirmation Screen**: Booking confirmation with QR e-ticket and invoice download
10. **Manage Bookings Screen**: List and details of all bookings

## Custom Widgets

The app includes several custom widgets for consistent UI:
- CustomAppBar: Styled app bar with consistent branding
- CustomButton: Reusable button with loading states
- CustomCard: Consistent card styling with shadows and rounded corners
- BadgeWidget: Color-coded badges for flight types
- FlightCard: Standardized flight display component
- PriceDisplay: Consistent price formatting
- PassengerInfoCard: Standardized passenger information display

## API Integration

### SerpApi (Flight Data)
The app integrates with SerpApi to fetch real flight data. In case the API is unavailable, it falls back to mock data.

Configuration:
1. Sign up at [SerpApi](https://serpapi.com/) to get an API key
2. Update `serpApiKey` in `lib/utils/env_config.dart`

### Paystack (Payments)
The app uses Paystack for payment processing with both card and QR code payment options.

Configuration:
1. Sign up at [Paystack](https://paystack.com/) to get API keys
2. Update `paystackPublicKey` and `paystackSecretKey` in `lib/utils/env_config.dart`

## QR Code Features

### Payment QR Codes
Users can choose to pay via QR code scanning, which generates a scannable code for mobile banking apps.

### E-Ticket QR Codes
Each booking confirmation includes a QR code that can be scanned at airports for check-in.

## Invoice Generation

Users can download HTML invoices for their bookings directly from the confirmation screen. The invoices include:
- Booking reference
- Flight details
- Passenger information
- Price breakdown
- Company branding

## Development

### Adding New Features
1. Create new models in the `models/` directory
2. Implement business logic in the `services/` directory
3. Create new screens in the `screens/` directory
4. Add reusable components to the `widgets/` directory
5. Update navigation as needed

### Code Quality
- Follow Flutter linting rules
- Use descriptive variable and function names
- Comment complex logic
- Maintain consistent code formatting

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flight and airline data sourced from public sources
- Icons from FluentUI Icons package
- UI inspiration from popular travel booking platforms