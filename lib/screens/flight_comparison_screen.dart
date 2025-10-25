import 'package:booktickets/models/flight.dart';
import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:booktickets/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class FlightComparisonScreen extends StatefulWidget {
  final List<Flight> flights;

  const FlightComparisonScreen({Key? key, required this.flights}) : super(key: key);

  @override
  State<FlightComparisonScreen> createState() => _FlightComparisonScreenState();
}

class _FlightComparisonScreenState extends State<FlightComparisonScreen> {
  List<FareOption?> _selectedFares = [];

  @override
  void initState() {
    super.initState();
    _selectedFares = List<FareOption?>.filled(widget.flights.length, null);
  }

  void _selectFare(int flightIndex, FareOption fare) {
    setState(() {
      _selectedFares[flightIndex] = fare;
    });
  }

  void _bookFlight(int flightIndex) {
    if (_selectedFares[flightIndex] != null) {
      Get.toNamed(
        '/passenger-info',
        arguments: {
          'flight': widget.flights[flightIndex],
          'selectedFare': _selectedFares[flightIndex],
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
          "Compare Flights",
          style: Styles.headLineStyle1.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppLayout.getWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Compare ${widget.flights.length} flight options side by side",
              style: Styles.headLineStyle3,
            ),
            Gap(AppLayout.getHeight(20)),
            
            // Comparison table header
            Container(
              decoration: BoxDecoration(
                color: Styles.primaryColor,
                borderRadius: BorderRadius.circular(AppLayout.getHeight(10)),
              ),
              padding: EdgeInsets.all(AppLayout.getWidth(15)),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Flight Details",
                      style: Styles.headLineStyle2.copyWith(color: Colors.white),
                    ),
                  ),
                  for (int i = 0; i < widget.flights.length; i++)
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "${widget.flights[i].airlineName}",
                            style: Styles.headLineStyle3.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "${widget.flights[i].flightNumber}",
                            style: Styles.headLineStyle4.copyWith(color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Gap(AppLayout.getHeight(10)),
            
            // Departure time comparison
            _buildComparisonRow(
              "Departure",
              widget.flights.map((flight) => flight.departureTime.formatTime()).toList(),
            ),
            
            // Arrival time comparison
            _buildComparisonRow(
              "Arrival",
              widget.flights.map((flight) => flight.arrivalTime.formatTime()).toList(),
            ),
            
            // Duration comparison
            _buildComparisonRow(
              "Duration",
              widget.flights.map((flight) => 
                '${flight.duration ~/ 60}h ${flight.duration % 60}m').toList(),
            ),
            
            // Stops comparison
            _buildComparisonRow(
              "Stops",
              widget.flights.map((flight) => 
                flight.stops == 0 ? 'Direct' : '${flight.stops} stop${flight.stops > 1 ? 's' : ''}').toList(),
            ),
            
            // Aircraft comparison
            _buildComparisonRow(
              "Aircraft",
              widget.flights.map((flight) => flight.segments.first.aircraft).toList(),
            ),
            
            Gap(AppLayout.getHeight(20)),
            
            // Fare options comparison
            Text(
              "Fare Options",
              style: Styles.headLineStyle2,
            ),
            Gap(AppLayout.getHeight(10)),
            
            // Light fare comparison
            _buildFareComparisonRow(
              "Light",
              widget.flights.map((flight) {
                final lightFare = flight.fareOptions.firstWhere(
                  (fare) => fare.type == 'Light',
                  orElse: () => flight.fareOptions.first,
                );
                return lightFare;
              }).toList(),
            ),
            
            // Standard fare comparison
            _buildFareComparisonRow(
              "Standard",
              widget.flights.map((flight) {
                final standardFare = flight.fareOptions.firstWhere(
                  (fare) => fare.type == 'Standard',
                  orElse: () => flight.fareOptions.length > 1 ? flight.fareOptions[1] : flight.fareOptions.first,
                );
                return standardFare;
              }).toList(),
            ),
            
            // Flex fare comparison
            _buildFareComparisonRow(
              "Flex",
              widget.flights.map((flight) {
                final flexFare = flight.fareOptions.firstWhere(
                  (fare) => fare.type == 'Flex',
                  orElse: () => flight.fareOptions.last,
                );
                return flexFare;
              }).toList(),
            ),
            
            Gap(AppLayout.getHeight(30)),
            
            // Booking buttons
            Text(
              "Select a flight to book",
              style: Styles.headLineStyle2,
            ),
            Gap(AppLayout.getHeight(10)),
            for (int i = 0; i < widget.flights.length; i++)
              Container(
                margin: EdgeInsets.only(bottom: AppLayout.getHeight(10)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${widget.flights[i].airlineName} • ${widget.flights[i].flightNumber}",
                        style: Styles.headLineStyle3,
                      ),
                    ),
                    CustomButton(
                      text: _selectedFares[i] != null 
                          ? "R${_selectedFares[i]!.price.toStringAsFixed(2)}" 
                          : "Select Fare",
                      backgroundColor: _selectedFares[i] != null 
                          ? Styles.primaryColor 
                          : Colors.grey.shade300,
                      textColor: _selectedFares[i] != null 
                          ? Colors.white 
                          : Colors.black,
                      onPressed: _selectedFares[i] != null 
                          ? () => _bookFlight(i) 
                          : null,
                      width: AppLayout.getWidth(120),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(String label, List<String> values) {
    return Container(
      margin: EdgeInsets.only(bottom: AppLayout.getHeight(5)),
      padding: EdgeInsets.all(AppLayout.getWidth(10)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppLayout.getHeight(5)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Styles.headLineStyle3,
            ),
          ),
          for (int i = 0; i < values.length; i++)
            Expanded(
              child: Text(
                values[i],
                style: Styles.headLineStyle4,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFareComparisonRow(String fareType, List<FareOption> fares) {
    return Container(
      margin: EdgeInsets.only(bottom: AppLayout.getHeight(10)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppLayout.getHeight(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppLayout.getWidth(10)),
            decoration: BoxDecoration(
              color: Styles.accentColor.withOpacity(0.3),
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppLayout.getHeight(5))),
            ),
            child: Text(
              fareType,
              style: Styles.headLineStyle3,
            ),
          ),
          for (int i = 0; i < fares.length; i++)
            Container(
              padding: EdgeInsets.all(AppLayout.getWidth(10)),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "R${fares[i].price.toStringAsFixed(2)}",
                        style: Styles.headLineStyle1.copyWith(color: Styles.primaryColor),
                      ),
                      Text(
                        "${fares[i].baggageAllowance}kg baggage",
                        style: Styles.headLineStyle4,
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => _selectFare(i, fares[i]),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedFares[i] == fares[i] 
                          ? Styles.successColor 
                          : Styles.primaryColor,
                      minimumSize: Size(AppLayout.getWidth(100), AppLayout.getHeight(40)),
                    ),
                    child: Text(
                      _selectedFares[i] == fares[i] ? "Selected" : "Select",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
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
}