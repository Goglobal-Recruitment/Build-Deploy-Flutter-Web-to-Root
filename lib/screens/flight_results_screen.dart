import 'package:booktickets/models/airport.dart';
import 'package:booktickets/models/flight.dart';
import 'package:booktickets/services/flight_service.dart';
import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:booktickets/widgets/column_layout.dart';
import 'package:booktickets/widgets/custom_app_bar.dart';
import 'package:booktickets/widgets/flight_card.dart';
import 'package:booktickets/widgets/thick_container.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'flight_details_screen.dart';

class FlightResultsScreen extends StatefulWidget {
  final Airport origin;
  final Airport destination;
  final DateTime date;
  final int passengers;

  const FlightResultsScreen({
    Key? key,
    required this.origin,
    required this.destination,
    required this.date,
    required this.passengers,
  }) : super(key: key);

  @override
  State<FlightResultsScreen> createState() => _FlightResultsScreenState();
}

class _FlightResultsScreenState extends State<FlightResultsScreen> {
  final FlightService _flightService = FlightService();
  late List<Flight> _flights;
  List<Flight> _filteredFlights = [];
  FlightSortOption _sortOption = FlightSortOption.priceLowToHigh;
  double _maxPrice = 1000;
  int _maxStops = 2;
  String? _selectedAirline;

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  void _loadFlights() {
    _flights = _flightService.searchFlights(
      originCode: widget.origin.code,
      destinationCode: widget.destination.code,
      date: widget.date,
      passengers: widget.passengers,
    );
    
    _filteredFlights = List.from(_flights);
    _sortFlights();
    
    // Set max price to highest price in results
    if (_flights.isNotEmpty) {
      _maxPrice = _flights
          .map((flight) => flight.bestPrice)
          .reduce((a, b) => a > b ? a : b);
    }
  }

  void _sortFlights() {
    setState(() {
      _filteredFlights = _flightService.sortFlights(_filteredFlights, _sortOption);
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredFlights = _flightService.filterFlights(
        flights: _flights,
        maxPrice: _maxPrice,
        maxStops: _maxStops,
        airlineCode: _selectedAirline,
      );
      _sortFlights();
    });
  }

  void _showFlightDetails(Flight flight) {
    Get.to(() => FlightDetailsScreen(
          flight: flight,
          passengers: widget.passengers,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: CustomAppBar(
        title: '${widget.origin.code} → ${widget.destination.code}',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Search info
          Container(
            padding: EdgeInsets.all(AppLayout.getHeight(15)),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.date.day}/${widget.date.month}/${widget.date.year}',
                      style: Styles.headLineStyle3,
                    ),
                    Text(
                      '${widget.passengers} Passenger${widget.passengers > 1 ? 's' : ''}',
                      style: Styles.headLineStyle4,
                    ),
                  ],
                ),
                Text(
                  '${_filteredFlights.length} flights found',
                  style: Styles.headLineStyle3,
                ),
              ],
            ),
          ),
          Gap(AppLayout.getHeight(10)),
          
          // Filters
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppLayout.getWidth(15),
              vertical: AppLayout.getHeight(10),
            ),
            color: Colors.white,
            child: Row(
              children: [
                // Sort dropdown
                DropdownButton<FlightSortOption>(
                  value: _sortOption,
                  items: const [
                    DropdownMenuItem(
                      value: FlightSortOption.priceLowToHigh,
                      child: Text('Price: Low to High'),
                    ),
                    DropdownMenuItem(
                      value: FlightSortOption.priceHighToLow,
                      child: Text('Price: High to Low'),
                    ),
                    DropdownMenuItem(
                      value: FlightSortOption.durationShortToLong,
                      child: Text('Duration: Short to Long'),
                    ),
                    DropdownMenuItem(
                      value: FlightSortOption.durationLongToShort,
                      child: Text('Duration: Long to Short'),
                    ),
                  ],
                  onChanged: (FlightSortOption? value) {
                    if (value != null) {
                      setState(() {
                        _sortOption = value;
                        _sortFlights();
                      });
                    }
                  },
                ),
                const Spacer(),
                TextButton(
                  onPressed: _showFilters,
                  child: const Text('Filters'),
                ),
              ],
            ),
          ),
          Gap(AppLayout.getHeight(10)),
          
          // Flight list
          Expanded(
            child: ListView.builder(
              itemCount: _filteredFlights.length,
              itemBuilder: (context, index) {
                final flight = _filteredFlights[index];
                return FlightCard(
                  flight: flight,
                  onTap: () => _showFlightDetails(flight),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.all(AppLayout.getHeight(20)),
              height: AppLayout.getHeight(400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filters',
                    style: Styles.headLineStyle2,
                  ),
                  Gap(AppLayout.getHeight(20)),
                  
                  // Price filter
                  Text('Max Price: \$${_maxPrice.round()}'),
                  Slider(
                    value: _maxPrice,
                    min: 100,
                    max: 2000,
                    divisions: 190,
                    label: _maxPrice.round().toString(),
                    onChanged: (double value) {
                      setModalState(() {
                        _maxPrice = value;
                      });
                    },
                  ),
                  Gap(AppLayout.getHeight(20)),
                  
                  // Stops filter
                  Text('Max Stops: $_maxStops'),
                  Slider(
                    value: _maxStops.toDouble(),
                    min: 0,
                    max: 2,
                    divisions: 2,
                    label: _maxStops.toString(),
                    onChanged: (double value) {
                      setModalState(() {
                        _maxStops = value.toInt();
                      });
                    },
                  ),
                  Gap(AppLayout.getHeight(20)),
                  
                  // Airline filter
                  Text('Airline'),
                  DropdownButton<String>(
                    value: _selectedAirline,
                    hint: const Text('Select Airline'),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Airlines'),
                      ),
                      ..._flightService.getAirlines().map((airline) {
                        return DropdownMenuItem(
                          value: airline['code'],
                          child: Text(airline['name']!),
                        );
                      }).toList(),
                    ],
                    onChanged: (String? value) {
                      setModalState(() {
                        _selectedAirline = value;
                      });
                    },
                  ),
                  const Spacer(),
                  
                  // Apply button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _applyFilters();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Styles.primaryColor,
                      minimumSize: Size.fromHeight(AppLayout.getHeight(50)),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

extension on DateTime {
  String formatTime() {
    return '${this.hour.toString().padLeft(2, '0')}:${this.minute.toString().padLeft(2, '0')}';
  }
}