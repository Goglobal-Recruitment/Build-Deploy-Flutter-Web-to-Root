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
  List<Flight> _selectedFlights = []; // For comparison functionality
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

  // Toggle flight selection for comparison
  void _toggleFlightSelection(Flight flight) {
    setState(() {
      if (_selectedFlights.contains(flight)) {
        _selectedFlights.remove(flight);
      } else {
        _selectedFlights.add(flight);
      }
    });
  }

  // Navigate to comparison screen
  void _compareFlights() {
    if (_selectedFlights.length < 2) {
      Get.snackbar(
        "Selection Required",
        "Please select at least 2 flights to compare",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    Get.toNamed(
      '/flight-comparison',
      arguments: _selectedFlights,
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
        actions: [
          // Show compare icon only when flights are selected
          if (_selectedFlights.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.compare, color: Colors.white),
              onPressed: _compareFlights,
            ),
        ],
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
                  '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} • $passengers Passenger${passengers > 1 ? 's' : ''} • ${_flights.length} flights found',
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
                final flight = _flights[index];
                final isSelected = _selectedFlights.contains(flight);
                
                return Stack(
                  children: [
                    FlightCard(
                      flight: flight,
                      onTap: () => _openFlightDetails(flight),
                    ),
                    // Add selection indicator
                    if (isSelected)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    // Add tap handler for selection
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _toggleFlightSelection(flight),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}