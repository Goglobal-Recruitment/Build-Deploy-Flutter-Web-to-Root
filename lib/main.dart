import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:booktickets/screens/bottom_bar.dart';
import 'package:booktickets/screens/search_screen.dart';
import 'package:booktickets/screens/advanced_search_screen.dart';
import 'package:booktickets/screens/flight_results_screen.dart';
import 'package:booktickets/screens/flight_details_screen.dart';
import 'package:booktickets/screens/flight_comparison_screen.dart';
import 'package:booktickets/screens/passenger_info_screen.dart';
import 'package:booktickets/screens/payment_screen.dart';
import 'package:booktickets/screens/booking_confirmation_screen.dart';
import 'package:booktickets/screens/manage_bookings_screen.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:booktickets/services/payment_service.dart';
import 'package:booktickets/models/flight.dart';

// Define primary and secondary colors
const Color primary = Color(0xFF1D6ED6);
const Color secondary = Color(0xFF0E2D5D);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Paystack before app runs
  PaymentService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkyQuest - Find Your Perfect Flight',
      theme: ThemeData(
        primaryColor: primary,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: secondary,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: secondary,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const BottomBar(),
      getPages: [
        GetPage(name: '/', page: () => const BottomBar()),
        GetPage(name: '/search', page: () => const SearchScreen()),
        GetPage(name: '/advanced-search', page: () => const AdvancedSearchScreen()),
        GetPage(name: '/flight-results', page: () {
          final args = Get.arguments as Map<String, dynamic>? ?? {};
          return FlightResultsScreen(searchParams: args);
        }),
        GetPage(name: '/flight-details', page: () {
          final flight = Get.arguments;
          return FlightDetailsScreen(flight: flight);
        }),
        GetPage(name: '/flight-comparison', page: () {
          final flights = Get.arguments as List;
          return FlightComparisonScreen(flights: flights.cast<Flight>());
        }),
        GetPage(name: '/passenger-info', page: () {
          final args = Get.arguments as Map<String, dynamic>;
          return PassengerInfoScreen(
            flight: args['flight'],
            selectedFare: args['selectedFare'],
            passengerCount: 1,
          );
        }),
        GetPage(name: '/payment', page: () {
          final args = Get.arguments as Map<String, dynamic>;
          return PaymentScreen(
            flight: args['flight'],
            selectedFare: args['selectedFare'],
            passengers: args['passengers'],
          );
        }),
        GetPage(name: '/booking-confirmation', page: () {
          final booking = Get.arguments;
          return BookingConfirmationScreen(booking: booking);
        }),
        GetPage(name: '/manage-bookings', page: () => const ManageBookingsScreen()),
      ],
    );
  }
}