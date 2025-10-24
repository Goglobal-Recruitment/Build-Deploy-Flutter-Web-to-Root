import 'dart:html' as html;

import 'package:booktickets/models/booking.dart';
import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Booking booking;

  const BookingConfirmationScreen({Key? key, required this.booking})
      : super(key: key);

  void _downloadInvoice() {
    // In a real app, this would generate a PDF or HTML invoice
    final invoiceContent = '''
<!DOCTYPE html>
<html>
<head>
    <title>Invoice - ${booking.bookingReference}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .header { text-align: center; margin-bottom: 30px; }
        .booking-info { background: #f5f5f5; padding: 20px; border-radius: 8px; margin: 20px 0; }
        .flight-details { margin: 20px 0; }
        .passenger-list { margin: 20px 0; }
        .price-breakdown { margin: 20px 0; }
        table { width: 100%; border-collapse: collapse; margin: 10px 0; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <div class="header">
        <h1>SkyQuest Airlines</h1>
        <h2>Booking Confirmation</h2>
    </div>
    
    <div class="booking-info">
        <h3>Booking Reference: ${booking.bookingReference}</h3>
        <p>Booking Date: ${booking.bookingDate.formatDate()}</p>
        <p>Status: ${booking.status.toString().split('.').last.toUpperCase()}</p>
    </div>
    
    <div class="flight-details">
        <h3>Flight Details</h3>
        <p>${booking.flight.originCode} → ${booking.flight.destinationCode}</p>
        <p>Departure: ${booking.flight.departureTime.formatDateTime()}</p>
        <p>Arrival: ${booking.flight.arrivalTime.formatDateTime()}</p>
        <p>Flight: ${booking.flight.airlineName} ${booking.flight.flightNumber}</p>
        <p>Duration: ${booking.flight.duration ~/ 60}h ${booking.flight.duration % 60}m</p>
    </div>
    
    <div class="passenger-list">
        <h3>Passenger Information</h3>
        <table>
            <tr>
                <th>Name</th>
                <th>Date of Birth</th>
                <th>Email</th>
                <th>Phone</th>
            </tr>
            ${booking.passengers.map((p) => '''
            <tr>
                <td>${p.fullName}</td>
                <td>${p.dateOfBirth.formatDate()}</td>
                <td>${p.email}</td>
                <td>${p.phone}</td>
            </tr>
            ''').join('')}
        </table>
    </div>
    
    <div class="price-breakdown">
        <h3>Price Breakdown</h3>
        <table>
            <tr>
                <td>Flight Fare (${booking.selectedFare.type})</td>
                <td>\$${booking.selectedFare.price.toStringAsFixed(2)}</td>
            </tr>
            <tr>
                <td>Passengers</td>
                <td>${booking.passengers.length}</td>
            </tr>
            <tr>
                <td>Subtotal</td>
                <td>\$${(booking.selectedFare.price * booking.passengers.length).toStringAsFixed(2)}</td>
            </tr>
            <tr>
                <td>Taxes & Fees (15%)</td>
                <td>\$${(booking.totalPrice * 0.15).toStringAsFixed(2)}</td>
            </tr>
            <tr>
                <td><strong>Total</strong></td>
                <td><strong>\$${booking.totalPrice.toStringAsFixed(2)}</strong></td>
            </tr>
        </table>
    </div>
    
    <div class="footer">
        <p>Thank you for choosing SkyQuest Airlines!</p>
        <p>For assistance, contact support@skyquest.com</p>
    </div>
</body>
</html>
    ''';

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