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
  String _selectedCabinClass = 'Economy';
  int _stopsFilter = -1; // -1 for all, 0 for direct, 1 for 1 stop, etc.
  double _minPrice = 0;
  double _maxPrice = 50000;
  final FlightService _flightService = FlightService();

  @override
  void initState() {
    super.initState();
    _selectedCabinClass = widget.searchParams['cabinClass'] ?? 'Economy';
    _searchFlights();
  }

  void _searchFlights() {
    final flights = _flightService.searchFlights(
      originCode: widget.searchParams['originCode'],
      destinationCode: widget.searchParams['destinationCode'],
      date: widget.searchParams['date'],
      passengers: widget.searchParams['passengers'],
    );

    // Apply filters
    List<Flight> filteredFlights = flights;
    
    // Filter by cabin class
    if (_selectedCabinClass != 'All') {
      filteredFlights = filteredFlights.where((flight) {
        return flight.fareOptions.any((fare) => fare.cabinClass == _selectedCabinClass);
      }).toList();
    }
    
    // Filter by stops
    if (_stopsFilter >= 0) {
      filteredFlights = filteredFlights.where((flight) => flight.stops == _stopsFilter).toList();
    }
    
    // Filter by price range
    filteredFlights = filteredFlights.where((flight) {
      double bestPrice = flight.bestPrice;
      return bestPrice >= _minPrice && bestPrice <= _maxPrice;
    }).toList();

    _flights = _flightService.sortFlights(filteredFlights, _sortOption);
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

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.all(AppLayout.getHeight(20)),
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filters',
                    style: Styles.headLineStyle1,
                  ),
                  Gap(AppLayout.getHeight(20)),
                  
                  // Cabin class filter
                  Text(
                    'Cabin Class',
                    style: Styles.headLineStyle2,
                  ),
                  Gap(AppLayout.getHeight(10)),
                  Wrap(
                    spacing: AppLayout.getWidth(10),
                    children: [
                      'All',
                      'Economy',
                      'Premium Economy',
                      'Business',
                      'First'
                    ].map((cabin) {
                      return ChoiceChip(
                        label: Text(cabin),
                        selected: _selectedCabinClass == cabin,
                        onSelected: (selected) {
                          setModalState(() {
                            _selectedCabinClass = selected ? cabin : 'All';
                          });
                        },
                      );
                    }).toList(),
                  ),
                  Gap(AppLayout.getHeight(20)),
                  
                  // Stops filter
                  Text(
                    'Stops',
                    style: Styles.headLineStyle2,
                  ),
                  Gap(AppLayout.getHeight(10)),
                  Wrap(
                    spacing: AppLayout.getWidth(10),
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: _stopsFilter == -1,
                        onSelected: (selected) {
                          setModalState(() {
                            _stopsFilter = selected ? -1 : _stopsFilter;
                          });
                        },
                      ),
                      FilterChip(
                        label: const Text('Direct'),
                        selected: _stopsFilter == 0,
                        onSelected: (selected) {
                          setModalState(() {
                            _stopsFilter = selected ? 0 : _stopsFilter;
                          });
                        },
                      ),
                      FilterChip(
                        label: const Text('1 Stop'),
                        selected: _stopsFilter == 1,
                        onSelected: (selected) {
                          setModalState(() {
                            _stopsFilter = selected ? 1 : _stopsFilter;
                          });
                        },
                      ),
                      FilterChip(
                        label: const Text('2+ Stops'),
                        selected: _stopsFilter >= 2,
                        onSelected: (selected) {
                          setModalState(() {
                            _stopsFilter = selected ? 2 : _stopsFilter;
                          });
                        },
                      ),
                    ],
                  ),
                  Gap(AppLayout.getHeight(20)),
                  
                  // Price range filter
                  Text(
                    'Price Range',
                    style: Styles.headLineStyle2,
                  ),
                  Gap(AppLayout.getHeight(10)),
                  RangeSlider(
                    values: RangeValues(_minPrice, _maxPrice),
                    min: 0,
                    max: 50000,
                    divisions: 100,
                    labels: RangeLabels(
                      'R${_minPrice.round()}',
                      'R${_maxPrice.round()}',
                    ),
                    onChanged: (RangeValues values) {
                      setModalState(() {
                        _minPrice = values.start;
                        _maxPrice = values.end;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('R${_minPrice.round()}'),
                      Text('R${_maxPrice.round()}'),
                    ],
                  ),
                  Gap(AppLayout.getHeight(20)),
                  
                  // Apply and Reset buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              _selectedCabinClass = 'All';
                              _stopsFilter = -1;
                              _minPrice = 0;
                              _maxPrice = 50000;
                            });
                          },
                          child: Text('Reset'),
                        ),
                      ),
                      Gap(AppLayout.getWidth(10)),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _searchFlights();
                          },
                          child: Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final originCode = widget.searchParams['originCode'];
    final destinationCode = widget.searchParams['destinationCode'];
    final date = widget.searchParams['date'] as DateTime;
    final passengers = widget.searchParams['passengers'];
    final cabinClass = widget.searchParams['cabinClass'] ?? 'Economy';

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
          
          // Filters bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(15)),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: _showFilters,
                  icon: const Icon(Icons.filter_list),
                  label: Text('Filters'),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedCabinClass = 'All';
                      _stopsFilter = -1;
                      _minPrice = 0;
                      _maxPrice = 50000;
                      _searchFlights();
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text('Reset'),
                ),
              ],
            ),
          ),
          
          // Flight list
          Expanded(
            child: _flights.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 60,
                          color: Colors.grey,
                        ),
                        Gap(AppLayout.getHeight(20)),
                        Text(
                          'No flights found',
                          style: Styles.headLineStyle2,
                        ),
                        Gap(AppLayout.getHeight(10)),
                        Text(
                          'Try adjusting your filters',
                          style: Styles.headLineStyle4,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
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