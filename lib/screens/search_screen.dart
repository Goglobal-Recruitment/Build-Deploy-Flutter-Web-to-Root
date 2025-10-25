import 'package:booktickets/models/airport.dart';
import 'package:booktickets/models/flight.dart';
import 'package:booktickets/services/flight_service.dart';
import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/widgets/icon_text_widget.dart';
import 'package:booktickets/widgets/ticket_tabs.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../utils/app_styles.dart';
import '../widgets/double_text_widget.dart';
import 'flight_results_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FlightService _flightService = FlightService();
  late List<Airport> _airports;
  Airport? _selectedOrigin;
  Airport? _selectedDestination;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  int _passengers = 1;
  String _selectedCabinClass = 'Economy';

  @override
  void initState() {
    super.initState();
    _airports = _flightService.getAirports();
    if (_airports.isNotEmpty) {
      _selectedOrigin = _airports[0];
      _selectedDestination = _airports.length > 1 ? _airports[1] : _airports[0];
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
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
    Get.to(() => FlightResultsScreen(
          searchParams: {
            'originCode': _selectedOrigin!.code,
            'destinationCode': _selectedDestination!.code,
            'date': _selectedDate,
            'passengers': _passengers,
            'cabinClass': _selectedCabinClass,
          },
        ));
  }

  void _goToAdvancedSearch() {
    Get.toNamed('/advanced-search');
  }

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: AppLayout.getWidth(20), vertical: AppLayout.getHeight(20)),
        children: [
          Gap(AppLayout.getHeight(40)),
          Text("Find Your\nPerfect Flight", 
              style: Styles.headLineStyle1.copyWith(
                  fontSize: AppLayout.getWidth(35))),
          Gap(AppLayout.getHeight(20)),
          const AppTicketTabs(firstTab: "Flights", secondTab: "Hotels"),
          Gap(AppLayout.getHeight(25)),
          
          // Origin selection
          const AppIconText(icon: Icons.flight_takeoff_rounded, text: "From"),
          Gap(AppLayout.getHeight(10)),
          DropdownButtonFormField<Airport>(
            value: _selectedOrigin,
            decoration: const InputDecoration(
              labelText: "Origin Airport",
              border: OutlineInputBorder(),
            ),
            items: _airports.map((Airport airport) {
              return DropdownMenuItem<Airport>(
                value: airport,
                child: Text("${airport.city} (${airport.code})"),
              );
            }).toList(),
            onChanged: (Airport? newValue) {
              setState(() {
                _selectedOrigin = newValue;
              });
            },
          ),
          Gap(AppLayout.getHeight(20)),
          
          // Destination selection
          const AppIconText(icon: Icons.flight_land_rounded, text: "To"),
          Gap(AppLayout.getHeight(10)),
          DropdownButtonFormField<Airport>(
            value: _selectedDestination,
            decoration: const InputDecoration(
              labelText: "Destination Airport",
              border: OutlineInputBorder(),
            ),
            items: _airports.map((Airport airport) {
              return DropdownMenuItem<Airport>(
                value: airport,
                child: Text("${airport.city} (${airport.code})"),
              );
            }).toList(),
            onChanged: (Airport? newValue) {
              setState(() {
                _selectedDestination = newValue;
              });
            },
          ),
          Gap(AppLayout.getHeight(20)),
          
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
          
          // Date selection
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
              text: "${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}",
            ),
            onTap: () => _selectDate(context),
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
          Gap(AppLayout.getHeight(25)),
          
          // Search button
          ElevatedButton(
            onPressed: _searchFlights,
            style: ElevatedButton.styleFrom(
              backgroundColor: Styles.primaryColor,
              padding: EdgeInsets.symmetric(
                  vertical: AppLayout.getHeight(18),
                  horizontal: AppLayout.getWidth(15)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppLayout.getWidth(10)),
              ),
            ),
            child: Center(
              child: Text(
                "Search Flights",
                style: Styles.textStyle.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Gap(AppLayout.getHeight(15)),
          
          // Advanced search link
          TextButton(
            onPressed: _goToAdvancedSearch,
            child: Text(
              "Advanced Search Options",
              style: Styles.headLineStyle4.copyWith(
                color: Styles.primaryColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Gap(AppLayout.getHeight(25)),
          
          // Promotional content
          const AppDoubleTextWidget(
              bigText: "Special Offers", smallText: "View all"),
          Gap(AppLayout.getHeight(15)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: AppLayout.getHeight(200),
                width: size.width * 0.42,
                padding: EdgeInsets.symmetric(
                    horizontal: AppLayout.getHeight(15),
                    vertical: AppLayout.getWidth(15)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppLayout.getHeight(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 1,
                        spreadRadius: 1)
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      height: AppLayout.getHeight(100),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppLayout.getHeight(12)),
                          color: Styles.primaryColor.withOpacity(0.1),
                          image: const DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage("assets/images/img.png"),
                          )),
                    ),
                    Gap(AppLayout.getHeight(12)),
                    Text(
                      "20% off early bookings",
                      style: Styles.headLineStyle2,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              Container(
                height: AppLayout.getHeight(200),
                width: size.width * 0.42,
                padding: EdgeInsets.symmetric(
                    horizontal: AppLayout.getHeight(15),
                    vertical: AppLayout.getWidth(15)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppLayout.getHeight(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 1,
                        spreadRadius: 1)
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      height: AppLayout.getHeight(100),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppLayout.getHeight(12)),
                          color: Styles.accentColor.withOpacity(0.3),
                          image: const DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage("assets/images/img_1.png"),
                          )),
                    ),
                    Gap(AppLayout.getHeight(12)),
                    Text(
                      "Refer a friend, get \$50",
                      style: Styles.headLineStyle2,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}