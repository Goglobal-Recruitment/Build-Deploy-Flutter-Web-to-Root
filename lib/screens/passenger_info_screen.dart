import 'package:booktickets/models/booking.dart';
import 'package:booktickets/models/flight.dart';
import 'package:booktickets/services/flight_service.dart';
import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:uuid/v4.dart';

import 'payment_screen.dart';

class PassengerInfoScreen extends StatefulWidget {
  final Flight flight;
  final FareOption selectedFare;
  final int passengers;

  const PassengerInfoScreen({
    Key? key,
    required this.flight,
    required this.selectedFare,
    required this.passengers,
  }) : super(key: key);

  @override
  State<PassengerInfoScreen> createState() => _PassengerInfoScreenState();
}

class _PassengerInfoScreenState extends State<PassengerInfoScreen> {
  final FlightService _flightService = FlightService();
  final List<TextEditingController> _firstNameControllers = [];
  final List<TextEditingController> _lastNameControllers = [];
  final List<TextEditingController> _emailController = [];
  final List<TextEditingController> _phoneController = [];
  final List<DateTime?> _dateOfBirth = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers for each passenger
    for (int i = 0; i < widget.passengers; i++) {
      _firstNameControllers.add(TextEditingController());
      _lastNameControllers.add(TextEditingController());
      _emailController.add(TextEditingController());
      _phoneController.add(TextEditingController());
      _dateOfBirth.add(null);
    }
    
    // Pre-fill first passenger with sample data for demo
    if (_firstNameControllers.isNotEmpty) {
      _firstNameControllers[0].text = "John";
      _lastNameControllers[0].text = "Doe";
      _emailController[0].text = "john.doe@example.com";
      _phoneController[0].text = "+1234567890";
      _dateOfBirth[0] = DateTime(1990, 1, 1);
    }
  }

  @override
  void dispose() {
    for (var controller in _firstNameControllers) {
      controller.dispose();
    }
    for (var controller in _lastNameControllers) {
      controller.dispose();
    }
    for (var controller in _emailController) {
      controller.dispose();
    }
    for (var controller in _phoneController) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth[index] ?? DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 12)),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirth[index] = picked;
      });
    }
  }

  void _continueToPayment() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Create passenger objects
    final List<Passenger> passengers = [];
    for (int i = 0; i < widget.passengers; i++) {
      passengers.add(Passenger(
        id: const UuidV4().generate(),
        firstName: _firstNameControllers[i].text,
        lastName: _lastNameControllers[i].text,
        dateOfBirth: _dateOfBirth[i]!,
        email: _emailController[i].text,
        phone: _phoneController[i].text,
      ));
    }

    // Create booking
    final booking = _flightService.createBooking(
      flight: widget.flight,
      selectedFare: widget.selectedFare,
      passengers: passengers,
    );

    Get.to(() => PaymentScreen(booking: booking));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: AppBar(
        title: const Text('Passenger Information'),
        backgroundColor: Styles.secondaryColor,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Flight summary
              _buildFlightSummary(),
              Gap(AppLayout.getHeight(20)),
              
              // Passenger forms
              for (int i = 0; i < widget.passengers; i++)
                _buildPassengerForm(i),
              Gap(AppLayout.getHeight(20)),
              
              // Continue button
              Container(
                padding: EdgeInsets.all(AppLayout.getWidth(20)),
                child: ElevatedButton(
                  onPressed: _continueToPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.primaryColor,
                    minimumSize: Size.fromHeight(AppLayout.getHeight(50)),
                  ),
                  child: Text(
                    'Proceed to Payment',
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
      ),
    );
  }

  Widget _buildFlightSummary() {
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
            'Flight Summary',
            style: Styles.headLineStyle2,
          ),
          Gap(AppLayout.getHeight(10)),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.flight.originCode} → ${widget.flight.destinationCode}',
                style: Styles.headLineStyle3,
              ),
              Text(
                '\$${(widget.selectedFare.price * widget.passengers).toStringAsFixed(2)}',
                style: Styles.headLineStyle1.copyWith(
                  color: Styles.primaryColor,
                ),
              ),
            ],
          ),
          Gap(AppLayout.getHeight(5)),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.flight.departureTime.formatDate()}',
                style: Styles.headLineStyle4,
              ),
              Text(
                '${widget.passengers} Passenger${widget.passengers > 1 ? 's' : ''}',
                style: Styles.headLineStyle4,
              ),
            ],
          ),
          Gap(AppLayout.getHeight(5)),
          
          Text(
            '${widget.selectedFare.type} Fare',
            style: Styles.headLineStyle4,
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerForm(int index) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppLayout.getWidth(15),
        vertical: AppLayout.getHeight(5),
      ),
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
            'Passenger ${index + 1}',
            style: Styles.headLineStyle2,
          ),
          Gap(AppLayout.getHeight(15)),
          
          // First name
          TextFormField(
            controller: _firstNameControllers[index],
            decoration: const InputDecoration(
              labelText: 'First Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter first name';
              }
              return null;
            },
          ),
          Gap(AppLayout.getHeight(10)),
          
          // Last name
          TextFormField(
            controller: _lastNameControllers[index],
            decoration: const InputDecoration(
              labelText: 'Last Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter last name';
              }
              return null;
            },
          ),
          Gap(AppLayout.getHeight(10)),
          
          // Date of birth
          TextFormField(
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Date of Birth',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            controller: TextEditingController(
              text: _dateOfBirth[index] != null
                  ? '${_dateOfBirth[index]!.day}/${_dateOfBirth[index]!.month}/${_dateOfBirth[index]!.year}'
                  : '',
            ),
            validator: (value) {
              if (_dateOfBirth[index] == null) {
                return 'Please select date of birth';
              }
              return null;
            },
            onTap: () => _selectDate(context, index),
          ),
          Gap(AppLayout.getHeight(10)),
          
          // Email
          TextFormField(
            controller: _emailController[index],
            decoration: const InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email address';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          Gap(AppLayout.getHeight(10)),
          
          // Phone
          TextFormField(
            controller: _phoneController[index],
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter phone number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

extension on DateTime {
  String formatDate() {
    return '${this.day}/${this.month}/${this.year}';
  }
}