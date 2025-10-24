import 'package:booktickets/models/booking.dart';
import 'package:booktickets/services/flight_service.dart';
import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'booking_details_screen.dart';

class ManageBookingsScreen extends StatefulWidget {
  const ManageBookingsScreen({Key? key}) : super(key: key);

  @override
  State<ManageBookingsScreen> createState() => _ManageBookingsScreenState();
}

class _ManageBookingsScreenState extends State<ManageBookingsScreen> {
  final FlightService _flightService = FlightService();
  late List<Booking> _bookings;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _loadBookings() {
    // In a real app, this would load from local storage or a backend
    // For now, we'll create some sample bookings
    _bookings = [
      _createSampleBooking(1),
      _createSampleBooking(2),
      _createSampleBooking(3),
    ];
  }

  Booking _createSampleBooking(int id) {
    final airports = _flightService.getAirports();
    final airlines = _flightService.getAirlines();
    
    final origin = airports[id % airports.length];
    final destination = airports[(id + 3) % airports.length];
    final airline = airlines[id % airlines.length];
    
    final now = DateTime.now();
    final departure = now.add(Duration(days: id * 3));
    final arrival = departure.add(const Duration(hours: 3));
    
    final flight = _flightService.generateMockFlights(
      originCode: origin.code,
      destinationCode: destination.code,
      date: departure,
      count: 1,
    ).first;
    
    return Booking(
      id: 'BKG$id',
      bookingReference: 'SQ${(1000 + id * 123) % 10000}',
      flight: flight,
      selectedFare: flight.fareOptions[1],
      passengers: [
        Passenger(
          id: 'PAX$id',
          firstName: 'John',
          lastName: 'Doe',
          dateOfBirth: DateTime(1990, 1, 1),
          email: 'john.doe@example.com',
          phone: '+1234567890',
        ),
      ],
      totalPrice: flight.fareOptions[1].price,
      bookingDate: now.subtract(Duration(days: id)),
      status: BookingStatus.confirmed,
    );
  }

  void _viewBookingDetails(Booking booking) {
    Get.to(() => BookingDetailsScreen(booking: booking));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Styles.secondaryColor,
        foregroundColor: Colors.white,
      ),
      body: _bookings.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: _bookings.length,
              itemBuilder: (context, index) {
                return _buildBookingCard(_bookings[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.airline_seat_recline_normal,
            size: 80,
            color: Colors.grey.shade400,
          ),
          Gap(AppLayout.getHeight(20)),
          Text(
            'No bookings yet',
            style: Styles.headLineStyle2,
          ),
          Gap(AppLayout.getHeight(10)),
          Text(
            'Search for flights and make your first booking',
            style: Styles.headLineStyle4,
          ),
          Gap(AppLayout.getHeight(30)),
          ElevatedButton(
            onPressed: () {
              // Navigate to home/search screen
              Get.offAllNamed('/');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Styles.primaryColor,
              padding: EdgeInsets.symmetric(
                horizontal: AppLayout.getWidth(30),
                vertical: AppLayout.getHeight(15),
              ),
            ),
            child: Text(
              'Search Flights',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Container(
      margin: EdgeInsets.all(AppLayout.getWidth(15)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppLayout.getHeight(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _viewBookingDetails(booking),
        child: Padding(
          padding: EdgeInsets.all(AppLayout.getWidth(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking reference and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    booking.bookingReference,
                    style: Styles.headLineStyle1.copyWith(
                      fontFamily: 'monospace',
                      letterSpacing: 2,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppLayout.getWidth(10),
                      vertical: AppLayout.getHeight(5),
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking.status),
                      borderRadius: BorderRadius.circular(AppLayout.getHeight(5)),
                    ),
                    child: Text(
                      booking.status.toString().split('.').last.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Gap(AppLayout.getHeight(15)),
              
              // Flight route
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    booking.flight.originCode,
                    style: Styles.headLineStyle1,
                  ),
                  const Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  const Icon(
                    Icons.flight_takeoff,
                    color: Colors.blue,
                  ),
                  const Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  Text(
                    booking.flight.destinationCode,
                    style: Styles.headLineStyle1,
                  ),
                ],
              ),
              Gap(AppLayout.getHeight(10)),
              
              // Flight date and passengers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    booking.flight.departureTime.formatDate(),
                    style: Styles.headLineStyle4,
                  ),
                  Text(
                    '${booking.passengers.length} Passenger${booking.passengers.length > 1 ? 's' : ''}',
                    style: Styles.headLineStyle4,
                  ),
                ],
              ),
              Gap(AppLayout.getHeight(15)),
              
              // Airline and flight number
              Text(
                '${booking.flight.airlineName} • ${booking.flight.flightNumber}',
                style: Styles.headLineStyle4,
              ),
              Gap(AppLayout.getHeight(15)),
              
              // Booking date
              Text(
                'Booked on: ${booking.bookingDate.formatDate()}',
                style: Styles.headLineStyle4,
              ),
              Gap(AppLayout.getHeight(10)),
              
              // Action button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _viewBookingDetails(booking),
                    child: const Text('View Details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return Styles.successColor;
      case BookingStatus.pending:
        return Styles.warningColor;
      case BookingStatus.cancelled:
        return Styles.errorColor;
      default:
        return Colors.grey;
    }
  }
}

extension on DateTime {
  String formatDate() {
    return '${this.day.toString().padLeft(2, '0')}/${this.month.toString().padLeft(2, '0')}/${this.year}';
  }
}