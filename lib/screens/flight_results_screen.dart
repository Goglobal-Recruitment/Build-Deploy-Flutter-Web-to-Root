import 'package:booktickets/models/airport.dart';
import 'package:booktickets/models/flight.dart';
import 'package:booktickets/services/flight_service.dart';
import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:booktickets/widgets/flight_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class FlightResultsScreen extends StatefulWidget {
  final Map<String, dynamic> searchParams;

  const FlightResultsScreen({Key? key, required this.searchParams})
      : super(key: key);

  @override
  State<FlightResultsScreen> createState() => _FlightResultsScreenState();
}

class _FlightResultsScreenState extends State<FlightResultsScreen> {
  late List<Flight> _flights;
  FlightSortOption _sortOption = FlightSortOption.priceLowToHigh;
  final FlightService _flightService = FlightService();

  @override
  void initState() {
    super.initState();
    _searchFlights();
  }

  void _searchFlights() {
    final flights = _flightService.searchFlights(
      originCode: widget.searchParams['originCode'],
      destinationCode: widget.searchParams['destinationCode'],
      date: widget.searchParams['date'],
      passengers: widget.searchParams['passengers'],
    );

    _flights = _flightService.sortFlights(flights, _sortOption);
    setState(() {});
  }

  void _sortFlights(FlightSortOption option) {
    setState(() {
      _sortOption = option;
      _flights = _flightService.sortFlights(_flights, option);
    });
  }

  void _openFlightDetails(Flight flight) {
    Get.toNamed(
      '/flight-details',
      arguments: flight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final originCode = widget.searchParams['originCode'];
    final destinationCode = widget.searchParams['destinationCode'];
    final date = widget.searchParams['date'] as DateTime;
    final passengers = widget.searchParams['passengers'];

    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: AppBar(
        backgroundColor: Styles.secondaryColor,
        title: Text(
          '$originCode → $destinationCode',
          style: Styles.headLineStyle1.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Search info bar
          Container(
            padding: EdgeInsets.all(AppLayout.getHeight(15)),
            color: Styles.accentColor.withOpacity(0.3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${date.day}/${date.month}/${date.year} • $passengers Passenger${passengers > 1 ? 's' : ''} • ${_flights.length} flights found',
                  style: Styles.headLineStyle3,
                ),
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
                  onChanged: (option) {
                    if (option != null) {
                      _sortFlights(option);
                    }
                  },
                ),
              ],
            ),
          ),
          
          // Flight list
          Expanded(
            child: ListView.builder(
              itemCount: _flights.length,
              itemBuilder: (context, index) {
                return FlightCard(
                  flight: _flights[index],
                  onTap: () => _openFlightDetails(_flights[index]),
                );
              },
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