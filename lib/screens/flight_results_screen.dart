import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../models/flight.dart';
import '../services/flight_service.dart';
import '../utils/app_layout.dart';
import '../utils/app_styles.dart';
import '../widgets/flight_card.dart';

class FlightResultsScreen extends StatefulWidget {
  final Map<String, dynamic> searchParams;

  const FlightResultsScreen({Key? key, required this.searchParams})
      : super(key: key);

  @override
  State<FlightResultsScreen> createState() => _FlightResultsScreenState();
}

class _FlightResultsScreenState extends State<FlightResultsScreen> {
  late List<Flight> _flights;
  List<Flight> _selectedFlights = [];
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

  void _toggleFlightSelection(Flight flight) {
    setState(() {
      if (_selectedFlights.contains(flight)) {
        _selectedFlights.remove(flight);
      } else {
        _selectedFlights.add(flight);
      }
    });
  }

  void _compareFlights() {
    if (_selectedFlights.length < 2) {
      Get.snackbar(
        "Selection Required",
        "Please select at least 2 flights to compare",
        backgroundColor: Styles.warningColor,
        colorText: Colors.white,
      );
      return;
    }
    
    Get.toNamed(
      '/flight-comparison',
      arguments: _selectedFlights,
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
        actions: [
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
                      final flight = _flights[index];
                      final isSelected = _selectedFlights.contains(flight);
                      
                      return Stack(
                        children: [
                          FlightCard(
                            flight: flight,
                            onTap: () => _openFlightDetails(flight),
                          ),
                          // Selection indicator
                          if (isSelected)
                            Positioned(
                              top: AppLayout.getHeight(10),
                              right: AppLayout.getWidth(10),
                              child: Container(
                                padding: EdgeInsets.all(AppLayout.getWidth(5)),
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          // Selection overlay
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _toggleFlightSelection(flight),
                                borderRadius: BorderRadius.circular(AppLayout.getHeight(10)),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          
          // Comparison bar (only shown when flights are selected)
          if (_selectedFlights.isNotEmpty)
            Container(
              padding: EdgeInsets.all(AppLayout.getHeight(10)),
              color: Styles.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_selectedFlights.length} flight${_selectedFlights.length > 1 ? 's' : ''} selected',
                    style: const TextStyle(color: Colors.white),
                  ),
                  ElevatedButton(
                    onPressed: _compareFlights,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Styles.primaryColor,
                    ),
                    child: const Text('Compare'),
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