import 'dart:html' as html;

import 'package:booktickets/models/booking.dart';
import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:booktickets/utils/invoice_generator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Booking booking;

  const BookingDetailsScreen({Key? key, required this.booking})
      : super(key: key);

  void _downloadInvoice() {
    // Generate passenger data for invoice
    final passengers = booking.passengers.map((p) {
      return {
        'name': p.fullName,
        'dob': p.dateOfBirth.formatDate(),
        'email': p.email,
        'phone': p.phone,
      };
    }).toList();

    // Generate HTML invoice using our utility
    final invoiceContent = InvoiceGenerator.generateInvoiceHtml(
      bookingReference: booking.bookingReference,
      bookingDate: booking.bookingDate.formatDate(),
      originCode: booking.flight.originCode,
      destinationCode: booking.flight.destinationCode,
      departureTime: booking.flight.departureTime.formatTime(),
      arrivalTime: booking.flight.arrivalTime.formatTime(),
      airlineName: booking.flight.airlineName,
      flightNumber: booking.flight.flightNumber,
      duration: '${booking.flight.duration ~/ 60}h ${booking.flight.duration % 60}m',
      fareType: booking.selectedFare.type,
      farePrice: booking.selectedFare.price,
      passengerCount: booking.passengers.length,
      passengers: passengers,
      totalPrice: booking.totalPrice,
    );

    final blob = html.Blob([invoiceContent], 'text/html');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'invoice-${booking.bookingReference}.html')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: AppBar(
        title: Text('Booking: ${booking.bookingReference}'),
        backgroundColor: Styles.secondaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Booking status
            Container(
              margin: EdgeInsets.all(AppLayout.getWidth(15)),
              padding: EdgeInsets.all(AppLayout.getWidth(20)),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Booking Reference',
                        style: Styles.headLineStyle2,
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
                  Gap(AppLayout.getHeight(10)),
                  Text(
                    booking.bookingReference,
                    style: Styles.headLineStyle1.copyWith(
                      color: Styles.primaryColor,
                      fontSize: 28,
                      fontFamily: 'monospace',
                      letterSpacing: 3,
                    ),
                  ),
                  Gap(AppLayout.getHeight(15)),
                  Text(
                    'Booked on: ${booking.bookingDate.formatDateTime()}',
                    style: Styles.headLineStyle4,
                  ),
                ],
              ),
            ),
            
            // Flight details
            Container(
              margin: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(15)),
              padding: EdgeInsets.all(AppLayout.getWidth(20)),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Flight Details',
                    style: Styles.headLineStyle2,
                  ),
                  Gap(AppLayout.getHeight(15)),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.flight.originCode,
                            style: Styles.headLineStyle1,
                          ),
                          Text(
                            booking.flight.departureTime.formatTime(),
                            style: Styles.headLineStyle3,
                          ),
                          Text(
                            booking.flight.departureTime.formatDate(),
                            style: Styles.headLineStyle4,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${booking.flight.duration ~/ 60}h ${booking.flight.duration % 60}m',
                            style: Styles.headLineStyle4,
                          ),
                          const Icon(
                            Icons.flight_takeoff,
                            size: 30,
                            color: Colors.blue,
                          ),
                          Text(
                            booking.flight.stops == 0 ? 'Direct' : '${booking.flight.stops} stop${booking.flight.stops > 1 ? 's' : ''}',
                            style: Styles.headLineStyle4,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            booking.flight.destinationCode,
                            style: Styles.headLineStyle1,
                          ),
                          Text(
                            booking.flight.arrivalTime.formatTime(),
                            style: Styles.headLineStyle3,
                          ),
                          Text(
                            booking.flight.arrivalTime.formatDate(),
                            style: Styles.headLineStyle4,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap(AppLayout.getHeight(15)),
                  
                  // Airline info
                  Container(
                    padding: EdgeInsets.all(AppLayout.getWidth(10)),
                    decoration: BoxDecoration(
                      color: Styles.accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppLayout.getHeight(5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.airline_seat_recline_normal),
                        Gap(AppLayout.getWidth(10)),
                        Text(
                          '${booking.flight.airlineName} • ${booking.flight.flightNumber}',
                          style: Styles.headLineStyle3,
                        ),
                      ],
                    ),
                  ),
                  Gap(AppLayout.getHeight(10)),
                  
                  // Fare info
                  Container(
                    padding: EdgeInsets.all(AppLayout.getWidth(10)),
                    decoration: BoxDecoration(
                      color: Styles.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppLayout.getHeight(5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_offer),
                        Gap(AppLayout.getWidth(10)),
                        Text(
                          '${booking.selectedFare.type} Fare • ${booking.selectedFare.baggageAllowance}kg baggage',
                          style: Styles.headLineStyle3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Gap(AppLayout.getHeight(20)),
            
            // Passenger info
            Container(
              margin: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(15)),
              padding: EdgeInsets.all(AppLayout.getWidth(20)),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Passenger Information',
                    style: Styles.headLineStyle2,
                  ),
                  Gap(AppLayout.getHeight(15)),
                  
                  for (var passenger in booking.passengers)
                    Container(
                      margin: EdgeInsets.only(bottom: AppLayout.getHeight(15)),
                      padding: EdgeInsets.all(AppLayout.getWidth(15)),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(AppLayout.getHeight(5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            passenger.fullName,
                            style: Styles.headLineStyle3,
                          ),
                          Gap(AppLayout.getHeight(5)),
                          Text(
                            'DOB: ${passenger.dateOfBirth.formatDate()}',
                            style: Styles.headLineStyle4,
                          ),
                          Gap(AppLayout.getHeight(5)),
                          Text(
                            'Email: ${passenger.email}',
                            style: Styles.headLineStyle4,
                          ),
                          Gap(AppLayout.getHeight(5)),
                          Text(
                            'Phone: ${passenger.phone}',
                            style: Styles.headLineStyle4,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            
            Gap(AppLayout.getHeight(20)),
            
            // Price breakdown
            Container(
              margin: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(15)),
              padding: EdgeInsets.all(AppLayout.getWidth(20)),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price Breakdown',
                    style: Styles.headLineStyle2,
                  ),
                  Gap(AppLayout.getHeight(15)),
                  
                  _buildPriceRow('Flight Fare (${booking.selectedFare.type})', 
                      booking.selectedFare.price),
                  _buildPriceRow('Passengers', 
                      booking.passengers.length.toDouble(), isCount: true),
                  _buildPriceRow('Subtotal', 
                      booking.selectedFare.price * booking.passengers.length),
                  _buildPriceRow('Taxes & Fees (15%)', 
                      booking.totalPrice * 0.15),
                  const Divider(),
                  _buildPriceRow('Total', booking.totalPrice, isTotal: true),
                ],
              ),
            ),
            
            Gap(AppLayout.getHeight(20)),
            
            // Action buttons
            Container(
              margin: EdgeInsets.all(AppLayout.getWidth(20)),
              child: ElevatedButton(
                onPressed: _downloadInvoice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.primaryColor,
                  minimumSize: Size.fromHeight(AppLayout.getHeight(50)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.download, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Download Invoice',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double value, {bool isTotal = false, bool isCount = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppLayout.getHeight(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal 
                ? Styles.headLineStyle3.copyWith(fontWeight: FontWeight.bold)
                : Styles.headLineStyle4,
          ),
          Text(
            isCount ? value.toInt().toString() : '\$${value.toStringAsFixed(2)}',
            style: isTotal 
                ? Styles.headLineStyle1.copyWith(
                    color: Styles.primaryColor,
                    fontWeight: FontWeight.bold,
                  )
                : Styles.headLineStyle4,
          ),
        ],
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
  String formatTime() {
    return '${this.hour.toString().padLeft(2, '0')}:${this.minute.toString().padLeft(2, '0')}';
  }
  
  String formatDate() {
    return '${this.day.toString().padLeft(2, '0')}/${this.month.toString().padLeft(2, '0')}/${this.year}';
  }
  
  String formatDateTime() {
    return '${formatDate()} ${formatTime()}';
  }
}