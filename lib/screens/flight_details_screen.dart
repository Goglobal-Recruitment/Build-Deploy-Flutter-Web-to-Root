import 'package:booktickets/models/flight.dart';
import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:booktickets/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class FlightDetailsScreen extends StatefulWidget {
  final Flight flight;

  const FlightDetailsScreen({Key? key, required this.flight})
      : super(key: key);

  @override
  State<FlightDetailsScreen> createState() => _FlightDetailsScreenState();
}

class _FlightDetailsScreenState extends State<FlightDetailsScreen> {
  FareOption? _selectedFare;

  void _selectFare(FareOption fare) {
    setState(() {
      _selectedFare = fare;
    });
  }

  void _continueToPassengerInfo() {
    if (_selectedFare != null) {
      Get.toNamed(
        '/passenger-info',
        arguments: {
          'flight': widget.flight,
          'selectedFare': _selectedFare,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: AppBar(
        backgroundColor: Styles.secondaryColor,
        title: Text(
          'Flight Details',
          style: Styles.headLineStyle1.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Itinerary section
            Container(
              margin: EdgeInsets.all(AppLayout.getHeight(20)),
              padding: EdgeInsets.all(AppLayout.getHeight(20)),
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
                  
                  // Flight route
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.flight.departureTime.formatTime(),
                            style: Styles.headLineStyle1,
                          ),
                          Text(
                            '${widget.flight.duration ~/ 60}h ${widget.flight.duration % 60}m',
                            style: Styles.headLineStyle4,
                          ),
                          Text(
                            widget.flight.arrivalTime.formatTime(),
                            style: Styles.headLineStyle1,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            widget.flight.originCode,
                            style: Styles.headLineStyle3,
                          ),
                          Gap(AppLayout.getHeight(5)),
                          const Icon(
                            Icons.flight_takeoff,
                            color: Colors.blue,
                            size: 30,
                          ),
                          Gap(AppLayout.getHeight(5)),
                          Text(
                            widget.flight.destinationCode,
                            style: Styles.headLineStyle3,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.flight.departureTime.formatDate(),
                            style: Styles.headLineStyle4,
                          ),
                          Gap(AppLayout.getHeight(25)),
                          Text(
                            widget.flight.arrivalTime.formatDate(),
                            style: Styles.headLineStyle4,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap(AppLayout.getHeight(15)),
                  
                  // Airline and aircraft
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
                          '${widget.flight.airlineName} • ${widget.flight.flightNumber}',
                          style: Styles.headLineStyle3,
                        ),
                        Gap(AppLayout.getWidth(10)),
                        Text(
                          widget.flight.segments.first.aircraft,
                          style: Styles.headLineStyle4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Fare options section
            Container(
              margin: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(20)),
              padding: EdgeInsets.all(AppLayout.getHeight(20)),
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
                  
                  // Fare options list
                  for (var fare in widget.flight.fareOptions)
                    Container(
                      margin: EdgeInsets.only(bottom: AppLayout.getHeight(15)),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedFare == fare
                              ? Styles.successColor
                              : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(AppLayout.getHeight(10)),
                        color: _selectedFare == fare
                            ? Styles.successColor.withOpacity(0.1)
                            : Colors.white,
                      ),
                      child: Column(
                        children: [
                          // Fare header
                          ListTile(
                            title: Text(
                              fare.type,
                              style: Styles.headLineStyle3.copyWith(
                                color: _selectedFare == fare
                                    ? Styles.successColor
                                    : Styles.textColor,
                              ),
                            ),
                            trailing: Text(
                              'R${fare.price.toStringAsFixed(2)}',
                              style: Styles.headLineStyle1.copyWith(
                                color: _selectedFare == fare
                                    ? Styles.successColor
                                    : Styles.primaryColor,
                              ),
                            ),
                            onTap: () => _selectFare(fare),
                          ),
                          
                          // Fare details
                          Container(
                            padding: EdgeInsets.all(AppLayout.getWidth(15)),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.luggage,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
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
                                      fare.isRefundable
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      size: 16,
                                      color: fare.isRefundable
                                          ? Styles.successColor
                                          : Styles.errorColor,
                                    ),
                                    Gap(AppLayout.getWidth(5)),
                                    Text(
                                      fare.refundPolicy,
                                      style: Styles.headLineStyle4,
                                    ),
                                  ],
                                ),
                                Gap(AppLayout.getHeight(10)),
                                Row(
                                  children: [
                                    Icon(
                                      fare.isRefundable
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      size: 16,
                                      color: fare.isRefundable
                                          ? Styles.successColor
                                          : Styles.errorColor,
                                    ),
                                    Gap(AppLayout.getWidth(5)),
                                    Text(
                                      fare.cabinClass,
                                      style: Styles.headLineStyle4,
                                    ),
                                  ],
                                ),
                                Gap(AppLayout.getHeight(15)),
                                
                                // Select button
                                CustomButton(
                                  text: _selectedFare == fare
                                      ? 'Selected'
                                      : 'Select ${fare.type}',
                                  backgroundColor: _selectedFare == fare
                                      ? Styles.successColor
                                      : Styles.primaryColor,
                                  textColor: Colors.white,
                                  onPressed: () => _selectFare(fare),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            
            Gap(AppLayout.getHeight(20)),
            
            // Continue button
            Container(
              margin: EdgeInsets.all(AppLayout.getWidth(20)),
              child: CustomButton(
                text: 'Continue to Passenger Info',
                onPressed: _continueToPassengerInfo,
                isEnabled: _selectedFare != null,
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
    return '${this.day.toString().padLeft(2, '0')}/${this.month.toString().padLeft(2, '0')}';
  }
}