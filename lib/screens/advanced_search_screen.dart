import 'package:booktickets/models/airport.dart';
import 'package:booktickets/models/flight.dart';
import 'package:booktickets/services/flight_service.dart';
import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:booktickets/widgets/custom_button.dart';
import 'package:booktickets/widgets/icon_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AdvancedSearchScreen extends StatefulWidget {
  const AdvancedSearchScreen({Key? key}) : super(key: key);

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  final FlightService _flightService = FlightService();
  late List<Airport> _airports;
  
  // Search parameters
  Airport? _selectedOrigin;
  Airport? _selectedDestination;
  DateTime _departureDate = DateTime.now().add(const Duration(days: 1));
  DateTime? _returnDate;
  int _passengers = 1;
  String _selectedCabinClass = 'Economy';
  int _selectedStops = -1; // -1 for all, 0 for direct, 1 for 1 stop, etc.
  double _maxPrice = 50000;
  
  // Form controllers
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _airports = _flightService.getAirports();
    if (_airports.isNotEmpty) {
      _selectedOrigin = _airports[0];
      _selectedDestination = _airports.length > 1 ? _airports[1] : _airports[0];
    }
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _selectDepartureDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _departureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _departureDate) {
      setState(() {
        _departureDate = picked;
      });
    }
  }

  Future<void> _selectReturnDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _departureDate.add(const Duration(days: 7)),
      firstDate: _departureDate.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _returnDate = picked;
      });
    }
  }

  void _clearReturnDate() {
    setState(() {
      _returnDate = null;
    });
  }

  void _searchFlights() {
    if (_selectedOrigin == null || _selectedDestination == null) {
      Get.snackbar(
        "Error",
        "Please select both origin and destination",
        backgroundColor: Styles.errorColor,
        colorText: Colors.white,
      );
      return;
    }

    // Navigate to results screen with all search parameters
    Get.toNamed(
      '/flight-results',
      arguments: {
        'originCode': _selectedOrigin!.code,
        'destinationCode': _selectedDestination!.code,
        'date': _departureDate,
        'passengers': _passengers,
        'cabinClass': _selectedCabinClass,
        'stops': _selectedStops,
        'maxPrice': _maxPrice,
        'returnDate': _returnDate,
      },
    );
  }

  void _showAirportSelector(bool isOrigin) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.all(AppLayout.getHeight(20)),
          child: Column(
            children: [
              Text(
                isOrigin ? 'Select Origin Airport' : 'Select Destination Airport',
                style: Styles.headLineStyle1,
              ),
              Gap(AppLayout.getHeight(20)),
              Expanded(
                child: ListView.builder(
                  itemCount: _airports.length,
                  itemBuilder: (context, index) {
                    final airport = _airports[index];
                    return ListTile(
                      title: Text('${airport.city} (${airport.code})'),
                      subtitle: Text(airport.country),
                      onTap: () {
                        setState(() {
                          if (isOrigin) {
                            _selectedOrigin = airport;
                          } else {
                            _selectedDestination = airport;
                          }
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: AppBar(
        backgroundColor: Styles.secondaryColor,
        title: Text(
          "Advanced Search",
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
            // Trip type toggle
            Text(
              "Trip Type",
              style: Styles.headLineStyle2,
            ),
            Gap(AppLayout.getHeight(10)),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: "One Way",
                    backgroundColor: _returnDate == null ? Styles.primaryColor : Colors.grey.shade300,
                    textColor: _returnDate == null ? Colors.white : Colors.black,
                    onPressed: () {
                      setState(() {
                        _returnDate = null;
                      });
                    },
                  ),
                ),
                Gap(AppLayout.getWidth(10)),
                Expanded(
                  child: CustomButton(
                    text: "Return",
                    backgroundColor: _returnDate != null ? Styles.primaryColor : Colors.grey.shade300,
                    textColor: _returnDate != null ? Colors.white : Colors.black,
                    onPressed: () => _selectReturnDate(context),
                  ),
                ),
              ],
            ),
            Gap(AppLayout.getHeight(20)),
            
            // Origin selection
            const AppIconText(icon: Icons.flight_takeoff_rounded, text: "From"),
            Gap(AppLayout.getHeight(10)),
            TextFormField(
              readOnly: true,
              controller: TextEditingController(
                text: _selectedOrigin != null 
                    ? '${_selectedOrigin!.city} (${_selectedOrigin!.code})' 
                    : '',
              ),
              decoration: const InputDecoration(
                labelText: "Origin Airport",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              onTap: () => _showAirportSelector(true),
            ),
            Gap(AppLayout.getHeight(20)),
            
            // Destination selection
            const AppIconText(icon: Icons.flight_land_rounded, text: "To"),
            Gap(AppLayout.getHeight(10)),
            TextFormField(
              readOnly: true,
              controller: TextEditingController(
                text: _selectedDestination != null 
                    ? '${_selectedDestination!.city} (${_selectedDestination!.code})' 
                    : '',
              ),
              decoration: const InputDecoration(
                labelText: "Destination Airport",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              onTap: () => _showAirportSelector(false),
            ),
            Gap(AppLayout.getHeight(20)),
            
            // Departure date
            const AppIconText(icon: Icons.date_range, text: "Departure Date"),
            Gap(AppLayout.getHeight(10)),
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Select Date",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              controller: TextEditingController(
                text: "${_departureDate.day}/${_departureDate.month}/${_departureDate.year}",
              ),
              onTap: () => _selectDepartureDate(context),
            ),
            Gap(AppLayout.getHeight(20)),
            
            // Return date (if round trip)
            if (_returnDate != null) ...[
              const AppIconText(icon: Icons.date_range, text: "Return Date"),
              Gap(AppLayout.getHeight(10)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Select Date",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      controller: TextEditingController(
                        text: "${_returnDate!.day}/${_returnDate!.month}/${_returnDate!.year}",
                      ),
                      onTap: () => _selectReturnDate(context),
                    ),
                  ),
                  Gap(AppLayout.getWidth(10)),
                  IconButton(
                    onPressed: _clearReturnDate,
                    icon: const Icon(Icons.clear),
                  ),
                ],
              ),
              Gap(AppLayout.getHeight(20)),
            ],
            
            // Cabin class selection
            const AppIconText(icon: Icons.airline_seat_recline_normal, text: "Cabin Class"),
            Gap(AppLayout.getHeight(10)),
            DropdownButtonFormField<String>(
              value: _selectedCabinClass,
              decoration: const InputDecoration(
                labelText: "Select Cabin Class",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Economy', child: Text('Economy')),
                DropdownMenuItem(value: 'Premium Economy', child: Text('Premium Economy')),
                DropdownMenuItem(value: 'Business', child: Text('Business')),
                DropdownMenuItem(value: 'First', child: Text('First')),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCabinClass = newValue!;
                });
              },
            ),
            Gap(AppLayout.getHeight(20)),
            
            // Passengers selection
            const AppIconText(icon: Icons.person, text: "Passengers"),
            Gap(AppLayout.getHeight(10)),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (_passengers > 1) {
                      setState(() {
                        _passengers--;
                      });
                    }
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text("$_passengers Passenger${_passengers > 1 ? 's' : ''}", 
                    style: Styles.headLineStyle3),
                IconButton(
                  onPressed: () {
                    if (_passengers < 9) {
                      setState(() {
                        _passengers++;
                      });
                    }
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            Gap(AppLayout.getHeight(20)),
            
            // Advanced filters
            Text(
              "Advanced Filters",
              style: Styles.headLineStyle2,
            ),
            Gap(AppLayout.getHeight(10)),
            
            // Stops filter
            const AppIconText(icon: Icons.flight, text: "Stops"),
            Gap(AppLayout.getHeight(10)),
            DropdownButtonFormField<int>(
              value: _selectedStops,
              decoration: const InputDecoration(
                labelText: "Number of Stops",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: -1, child: Text('Any Number of Stops')),
                DropdownMenuItem(value: 0, child: Text('Direct Flights Only')),
                DropdownMenuItem(value: 1, child: Text('1 Stop Maximum')),
                DropdownMenuItem(value: 2, child: Text('2 Stops Maximum')),
              ],
              onChanged: (int? newValue) {
                setState(() {
                  _selectedStops = newValue!;
                });
              },
            ),
            Gap(AppLayout.getHeight(20)),
            
            // Price filter
            const AppIconText(icon: Icons.attach_money, text: "Maximum Price"),
            Gap(AppLayout.getHeight(10)),
            Slider(
              value: _maxPrice,
              min: 0,
              max: 50000,
              divisions: 100,
              label: 'R${_maxPrice.round()}',
              onChanged: (double value) {
                setState(() {
                  _maxPrice = value;
                });
              },
            ),
            Text(
              'Max Price: R${_maxPrice.round()}',
              style: Styles.headLineStyle4,
            ),
            Gap(AppLayout.getHeight(30)),
            
            // Search button
            CustomButton(
              text: "Search Flights",
              onPressed: _searchFlights,
            ),
          ],
        ),
      ),
    );
  }
}