import 'dart:html' as html;

import 'package:booktickets/models/booking.dart';
import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:booktickets/utils/invoice_generator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:barcode_widget/barcode_widget.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Booking booking;

  const BookingConfirmationScreen({Key? key, required this.booking})
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

  void _goToHome() {
    Get.offAllNamed('/'); // Navigate to home screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Success header
            Container(
              padding: EdgeInsets.all(AppLayout.getHeight(40)),
              color: Styles.successColor,
              child: Column(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 80,
                  ),
                  Gap(AppLayout.getHeight(20)),
                  Text(
                    'Booking Confirmed!',
                    style: Styles.headLineStyle1.copyWith(
                      color: Colors.white,
                      fontSize: 32,
                    ),
                  ),
                  Gap(AppLayout.getHeight(10)),
                  Text(
                    'Your flight is all set. Have a great trip!',
                    style: Styles.textStyle.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            Gap(AppLayout.getHeight(30)),
            
            // Booking reference
            Container(
              margin: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(20)),
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
                children: [
                  Text(
                    'Booking Reference',
                    style: Styles.headLineStyle2,
                  ),
                  Gap(AppLayout.getHeight(10)),
                  Text(
                    booking.bookingReference,
                    style: Styles.headLineStyle1.copyWith(
                      color: Styles.primaryColor,
                      fontSize: 36,
                      fontFamily: 'monospace',
                      letterSpacing: 5,
                    ),
                  ),
                  Gap(AppLayout.getHeight(10)),
                  Text(
                    'Save this reference for your records',
                    style: Styles.headLineStyle4,
                  ),
                ],
              ),
            ),
            
            Gap(AppLayout.getHeight(20)),
            
            // E-Ticket with QR Code
            Container(
              margin: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(20)),
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
                    'E-Ticket',
                    style: Styles.headLineStyle2,
                  ),
                  Gap(AppLayout.getHeight(15)),
                  
                  // QR Code for the ticket
                  Center(
                    child: BarcodeWidget(
                      barcode: Barcode.qrCode(),
                      data: 'booking:${booking.bookingReference}|flight:${booking.flight.flightNumber}|passenger:${booking.passengers.length}',
                      width: 200,
                      height: 200,
                    ),
                  ),
                  Gap(AppLayout.getHeight(15)),
                  Text(
                    'Scan this QR code at the airport for check-in',
                    textAlign: TextAlign.center,
                    style: Styles.headLineStyle4,
                  ),
                ],
              ),
            ),
            
            Gap(AppLayout.getHeight(20)),
            
            // Flight details
            Container(
              margin: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(20)),
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
                ],
              ),
            ),
            
            Gap(AppLayout.getHeight(20)),
            
            // Passenger info
            Container(
              margin: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(20)),
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
                      margin: EdgeInsets.only(bottom: AppLayout.getHeight(10)),
                      padding: EdgeInsets.all(AppLayout.getWidth(10)),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(AppLayout.getHeight(5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person),
                          Gap(AppLayout.getWidth(10)),
                          Expanded(
                            child: Text(
                              passenger.fullName,
                              style: Styles.headLineStyle3,
                          ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            
            Gap(AppLayout.getHeight(20)),
            
            // Action buttons
            Container(
              margin: EdgeInsets.all(AppLayout.getWidth(20)),
              child: Column(
                children: [
                  ElevatedButton(
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
                  Gap(AppLayout.getHeight(15)),
                  
                  OutlinedButton(
                    onPressed: _goToHome,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Styles.primaryColor),
                      minimumSize: Size.fromHeight(AppLayout.getHeight(50)),
                    ),
                    child: Text(
                      'Back to Home',
                      style: TextStyle(
                        color: Styles.primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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