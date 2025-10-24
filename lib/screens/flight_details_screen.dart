import 'package:booktickets/models/flight.dart';
import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:booktickets/widgets/column_layout.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'passenger_info_screen.dart';

class FlightDetailsScreen extends StatefulWidget {
  final Flight flight;
  final int passengers;

  const FlightDetailsScreen({
    Key? key,
    required this.flight,
    required this.passengers,
  }) : super(key: key);

  @override
  State<FlightDetailsScreen> createState() => _FlightDetailsScreenState();
}

class _FlightDetailsScreenState extends State<FlightDetailsScreen> {
  FareOption? _selectedFare;

  @override
  void initState() {
    super.initState();
    if (widget.flight.fareOptions.isNotEmpty) {
      _selectedFare = widget.flight.fareOptions[0];
    }
  }

  void _selectFare(FareOption fare) {
    setState(() {
      _selectedFare = fare;
    });
  }

  void _continueToBooking() {
    if (_selectedFare == null) {
      Get.snackbar(
        "Error",
        "Please select a fare option",
        backgroundColor: Styles.errorColor,
        colorText: Colors.white,
      );
      return;
    }

    Get.to(() => PassengerInfoScreen(
          flight: widget.flight,
          selectedFare: _selectedFare!,
          passengers: widget.passengers,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: AppBar(
        title: Text('Flight Details'),
        backgroundColor: Styles.secondaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Flight itinerary
            _buildItinerary(),
            Gap(AppLayout.getHeight(20)),
            
            // Fare options
            _buildFareOptions(),
            Gap(AppLayout.getHeight(20)),
            
            // Baggage information
            _buildBaggageInfo(),
            Gap(AppLayout.getHeight(20)),
            
            // Fare rules
            _buildFareRules(),
            Gap(AppLayout.getHeight(20)),
            
            // Continue button
            Container(
              padding: EdgeInsets.all(AppLayout.getWidth(20)),
              child: ElevatedButton(
                onPressed: _continueToBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.primaryColor,
                  minimumSize: Size.fromHeight(AppLayout.getHeight(50)),
                ),
                child: Text(
                  'Continue to Passenger Info',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItinerary() {
    return Container(
      margin: EdgeInsets.all(AppLayout.getWidth(15)),
      padding: EdgeInsets.all(AppLayout.getWidth(15)),
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
            'Itinerary',
            style: Styles.headLineStyle2,
          ),
          Gap(AppLayout.getHeight(15)),
          
          // Flight segments
          for (int i = 0; i < widget.flight.segments.length; i++) ...[
            if (i > 0) ...[
              Gap(AppLayout.getHeight(15)),
              // Layover information
              Container(
                padding: EdgeInsets.all(AppLayout.getWidth(10)),
                decoration: BoxDecoration(
                  color: Styles.accentColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(AppLayout.getHeight(5)),
                ),
                child: Text(
                  'Layover: ${widget.flight.segments[i].departureTime.difference(widget.flight.segments[i-1].arrivalTime).inMinutes} minutes',
                  style: Styles.headLineStyle4,
                ),
              ),
              Gap(AppLayout.getHeight(15)),
            ],
            
            // Segment details
            Row(
              children: [
                // Departure time and airport
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.flight.segments[i].departureTime.formatTime(),
                        style: Styles.headLineStyle1,
                      ),
                      Text(
                        widget.flight.segments[i].originCode,
                        style: Styles.headLineStyle3,
                      ),
                      Text(
                        widget.flight.segments[i].departureTime.formatDate(),
                        style: Styles.headLineStyle4,
                      ),
                    ],
                  ),
                ),
                
                // Flight duration and aircraft
                Column(
                  children: [
                    Text(
                      '${widget.flight.segments[i].duration ~/ 60}h ${widget.flight.segments[i].duration % 60}m',
                      style: Styles.headLineStyle4,
                    ),
                    const Icon(
                      Icons.flight_takeoff,
                      size: 24,
                      color: Colors.blue,
                    ),
                    Text(
                      widget.flight.segments[i].aircraft,
                      style: Styles.headLineStyle4,
                    ),
                  ],
                ),
                
                // Arrival time and airport
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.flight.segments[i].arrivalTime.formatTime(),
                        style: Styles.headLineStyle1,
                      ),
                      Text(
                        widget.flight.segments[i].destinationCode,
                        style: Styles.headLineStyle3,
                      ),
                      Text(
                        widget.flight.segments[i].arrivalTime.formatDate(),
                        style: Styles.headLineStyle4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            Gap(AppLayout.getHeight(10)),
            
            // Airline information
            Row(
              children: [
                Text(
                  '${widget.flight.segments[i].airlineName} • ${widget.flight.segments[i].airlineCode}${widget.flight.flightNumber}',
                  style: Styles.headLineStyle4,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFareOptions() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(15)),
      padding: EdgeInsets.all(AppLayout.getWidth(15)),
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
            'Fare Options',
            style: Styles.headLineStyle2,
          ),
          Gap(AppLayout.getHeight(15)),
          
          // Fare cards
          for (var fare in widget.flight.fareOptions)
            _buildFareCard(fare),
        ],
      ),
    );
  }

  Widget _buildFareCard(FareOption fare) {
    final bool isSelected = _selectedFare?.type == fare.type;
    
    return Container(
      margin: EdgeInsets.only(bottom: AppLayout.getHeight(10)),
      decoration: BoxDecoration(
        color: isSelected ? Styles.primaryColor.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(AppLayout.getHeight(10)),
        border: Border.all(
          color: isSelected ? Styles.primaryColor : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                fare.type,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Styles.primaryColor : Colors.black,
                ),
              ),
              Text(
                '\$${fare.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Styles.primaryColor : Colors.black,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          children: [
            Container(
              padding: EdgeInsets.all(AppLayout.getWidth(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.luggage, size: 16),
                      Gap(AppLayout.getWidth(5)),
                      Text(
                        '${fare.baggageAllowance}kg baggage allowance',
                        style: Styles.headLineStyle4,
                      ),
                    ],
                  ),
                  Gap(AppLayout.getHeight(5)),
                  Row(
                    children: [
                      Icon(
                        fare.isRefundable ? Icons.check_circle : Icons.cancel,
                        size: 16,
                        color: fare.isRefundable ? Colors.green : Colors.red,
                      ),
                      Gap(AppLayout.getWidth(5)),
                      Text(
                        fare.isRefundable ? 'Refundable' : 'Non-refundable',
                        style: Styles.headLineStyle4,
                      ),
                    ],
                  ),
                  Gap(AppLayout.getHeight(5)),
                  Text(
                    fare.refundPolicy,
                    style: Styles.headLineStyle4,
                  ),
                  Gap(AppLayout.getHeight(10)),
                  ElevatedButton(
                    onPressed: () => _selectFare(fare),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? Styles.successColor
                          : Styles.primaryColor,
                    ),
                    child: Text(
                      isSelected ? 'Selected' : 'Select ${fare.type}',
                      style: const TextStyle(color: Colors.white),
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

  Widget _buildBaggageInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(15)),
      padding: EdgeInsets.all(AppLayout.getWidth(15)),
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
            'Baggage Information',
            style: Styles.headLineStyle2,
          ),
          Gap(AppLayout.getHeight(15)),
          
          DataTable(
            columns: const [
              DataColumn(label: Text('Fare Type')),
              DataColumn(label: Text('Cabin Bag')),
              DataColumn(label: Text('Check-in Bag')),
            ],
            rows: widget.flight.fareOptions.map((fare) {
              return DataRow(
                cells: [
                  DataCell(Text(fare.type)),
                  const DataCell(Text('7kg')),
                  DataCell(Text('${fare.baggageAllowance}kg')),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFareRules() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(15)),
      padding: EdgeInsets.all(AppLayout.getWidth(15)),
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
            'Fare Rules',
            style: Styles.headLineStyle2,
          ),
          Gap(AppLayout.getHeight(15)),
          
          const Text(
            '• Name changes are not permitted\n'
            '• Flight changes permitted with fee\n'
            '• Cancellation fees apply based on fare type\n'
            '• No-show fee applies if you miss your flight\n'
            '• Seats can be selected for an additional fee\n'
            '• Meals are included in Flex fare only',
            style: TextStyle(height: 1.5),
          ),
        ],
      ),
    );
  }
}

extension on DateTime {
  String formatTime() {
    return '${this.hour.toString().padLeft(2, '0')}:${this.minute.toString().padLeft(2, '0')}';
  }
  
  String formatDate() {
    return '${this.day}/${this.month}/${this.year}';
  }
}